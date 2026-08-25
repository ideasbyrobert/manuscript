import Darwin
import Foundation

package actor Session: Link
{
    private let process = Process()
    private let input = Pipe()
    private let output = Pipe()
    private let patience: Patience
    private var next = 1
    private var waiting: [Int: CheckedContinuation<Message, any Error>] = [:]
    private var listening: [String: [Listener]] = [:]
    private var listeners = 0
    private var unclaimed: [String: [Message]] = [:]
    private var disconnect: Int?
    private var answered = false
    private var ended = false
    private var started = false

    package init(
        executable: URL,
        arguments: [String] = [],
        environment: [String: String] = [:],
        patience: Patience = Patience())
    {
        self.patience = patience
        process.executableURL = executable
        process.arguments = arguments
        process.environment = ProcessInfo.processInfo.environment
            .merging(environment) { _, given in given }
        process.standardInput = input
        process.standardOutput = output
    }

    package var isEnded: Bool
    {
        ended
    }

    package var isRunning: Bool
    {
        process.isRunning
    }

    package func start() throws
    {
        try process.run()
        started = true
        var flag: Int32 = 1
        _ = fcntl(
            input.fileHandleForWriting.fileDescriptor,
            F_SETNOSIGPIPE,
            flag)
        flag = 0
        let descriptor = output.fileHandleForReading.fileDescriptor
        let (stream, feed) = AsyncStream<Message>.makeStream()
        Thread
        {
            Self.read(descriptor, into: feed)
        }
        .start()
        Task
        {
            for await message in stream
            {
                self.deliver(message)
            }
            self.finish()
        }
    }

    package func request(
        _ command: String,
        _ arguments: JSON? = nil) async throws -> Message
    {
        guard started else
        {
            throw AdapterError.notStarted
        }
        guard !ended else
        {
            throw AdapterError.ended
        }
        let seq = next
        next += 1
        try write(.request(seq, command, arguments))
        return try await withTaskCancellationHandler
        {
            try await withCheckedThrowingContinuation
            {
                waiting[seq] = $0
            }
        }
        onCancel:
        {
            Task
            {
                await self.abandon(seq)
            }
        }
    }

    package func once(_ event: String) async -> Message?
    {
        if var kept = unclaimed[event], !kept.isEmpty
        {
            let first = kept.removeFirst()
            unclaimed[event] = kept
            return first
        }
        guard !ended else
        {
            return nil
        }
        listeners += 1
        let id = listeners
        return await withTaskCancellationHandler
        {
            await withCheckedContinuation
            {
                listening[event, default: []].append(Listener(id: id, wake: $0))
            }
        }
        onCancel:
        {
            Task
            {
                await self.abandon(event, id)
            }
        }
    }

    private func abandon(_ seq: Int)
    {
        waiting.removeValue(forKey: seq)?.resume(throwing: CancellationError())
    }

    private func abandon(_ event: String, _ id: Int)
    {
        guard let index = listening[event]?.firstIndex(where: { $0.id == id })
        else
        {
            return
        }
        listening[event]?.remove(at: index).wake.resume(returning: nil)
    }

    package func end() async -> Shutdown.Reason
    {
        guard started, !ended, process.isRunning else
        {
            finish()
            return .exited
        }
        let asked = ContinuousClock.now
        let seq = next
        next += 1
        disconnect = seq
        try? write(.request(seq, "disconnect", ["terminateDebuggee": true]))
        while true
        {
            let action = Shutdown.action(
                answered: answered,
                running: process.isRunning,
                elapsed: asked.duration(to: .now),
                patience: patience)
            guard case .finish(let reason) = action else
            {
                try? await Task.sleep(for: .milliseconds(10))
                continue
            }
            if reason != .exited
            {
                await terminate()
            }
            finish()
            return reason
        }
    }

    private func terminate() async
    {
        try? input.fileHandleForWriting.close()
        process.terminate()
        await settle(patience.kill)
        guard process.isRunning else
        {
            return
        }
        kill(process.processIdentifier, SIGKILL)
        await settle(patience.kill)
    }

    private func settle(_ limit: Duration) async
    {
        let from = ContinuousClock.now
        while process.isRunning, from.duration(to: .now) < limit
        {
            try? await Task.sleep(for: .milliseconds(10))
        }
    }

    private func write(_ message: Message) throws
    {
        try input.fileHandleForWriting.write(contentsOf: Frame.encode(message))
    }

    private func deliver(_ message: Message)
    {
        if message.type == .response, let seq = message.requestSeq
        {
            if seq == disconnect
            {
                answered = true
            }
            waiting.removeValue(forKey: seq)?.resume(returning: message)
        }
        if message.type == .event, let name = message.event
        {
            guard let listeners = listening.removeValue(forKey: name),
                !listeners.isEmpty else
            {
                unclaimed[name, default: []].append(message)
                unclaimed[name] = unclaimed[name]!.suffix(64)
                return
            }
            for listener in listeners
            {
                listener.wake.resume(returning: message)
            }
        }
    }

    private func finish()
    {
        guard !ended else
        {
            return
        }
        ended = true
        for (_, waiter) in waiting
        {
            waiter.resume(throwing: AdapterError.ended)
        }
        waiting = [:]
        for (_, listeners) in listening
        {
            for listener in listeners
            {
                listener.wake.resume(returning: nil)
            }
        }
        listening = [:]
    }

    private static func read(
        _ descriptor: Int32,
        into feed: AsyncStream<Message>.Continuation)
    {
        var buffer = Data()
        var piece = [UInt8](repeating: 0, count: 64 * 1_024)
        while true
        {
            let count = Darwin.read(descriptor, &piece, piece.count)
            guard count > 0 else
            {
                break
            }
            buffer.append(contentsOf: piece[0 ..< count])
            var parsing = true
            while parsing
            {
                switch Frame.parse(buffer)
                {
                case .message(let message, let consumed):
                    feed.yield(message)
                    buffer = Data(buffer.dropFirst(consumed))
                case .incomplete:
                    parsing = false
                case .corrupt:
                    feed.finish()
                    return
                }
            }
        }
        feed.finish()
    }
}

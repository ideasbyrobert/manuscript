@testable import Adapter

actor Scripted: Link
{
    struct Sent: Equatable
    {
        let seq: Int
        let command: String
        let arguments: JSON?
    }

    private(set) var sent: [Sent] = []
    private(set) var ended = false
    private var next = 1
    private var waiting: [Int: CheckedContinuation<Message, any Error>] = [:]
    private var listening: [String: [CheckedContinuation<Message?, Never>]]
        = [:]
    private var unclaimed: [String: [Message]] = [:]

    var commands: [String]
    {
        sent.map(\.command)
    }

    func request(_ command: String, _ arguments: JSON?) async throws -> Message
    {
        let seq = next
        next += 1
        sent.append(Sent(seq: seq, command: command, arguments: arguments))
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

    private func abandon(_ seq: Int)
    {
        waiting.removeValue(forKey: seq)?.resume(throwing: CancellationError())
    }

    func once(_ event: String) async -> Message?
    {
        if var kept = unclaimed[event], !kept.isEmpty
        {
            let first = kept.removeFirst()
            unclaimed[event] = kept
            return first
        }
        return await withCheckedContinuation
        {
            listening[event, default: []].append($0)
        }
    }

    func end() async -> Shutdown.Reason
    {
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
                listener.resume(returning: nil)
            }
        }
        listening = [:]
        return .exited
    }

    func answer(
        _ seq: Int,
        success: Bool = true,
        body: JSON? = nil,
        message: String? = nil)
    {
        guard let waiter = waiting.removeValue(forKey: seq),
            let asked = sent.first(where: { $0.seq == seq }) else
        {
            return
        }
        waiter.resume(returning: .response(
            100 + seq,
            to: .request(seq, asked.command),
            success: success,
            body: body,
            message: message))
    }

    func emit(_ event: String, body: JSON? = nil)
    {
        let message = Message.event(0, event, body: body)
        guard let listeners = listening.removeValue(forKey: event),
            !listeners.isEmpty else
        {
            unclaimed[event, default: []].append(message)
            return
        }
        for listener in listeners
        {
            listener.resume(returning: message)
        }
    }

    func sentCount(reaches count: Int) async -> Bool
    {
        for _ in 0 ..< 2_000
        {
            if sent.count >= count
            {
                return true
            }
            try? await Task.sleep(for: .milliseconds(1))
        }
        return false
    }
}

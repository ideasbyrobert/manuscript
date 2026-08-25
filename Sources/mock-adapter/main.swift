import Adapter
import Darwin
import Foundation

let environment = ProcessInfo.processInfo.environment
let splitsFrames = environment["MOCK_SPLIT_FRAMES"] == "1"
let onDisconnect = environment["MOCK_DISCONNECT"] ?? "exit"
let initializedAfterStart = environment["MOCK_INITIALIZED"] == "after-start"
if onDisconnect == "ignore-term"
{
    signal(SIGTERM, SIG_IGN)
}
let out = FileHandle.standardOutput
var seq = 1
var buffer = Data()
var initializedSent = false
var startAcknowledged = false

@MainActor
func emit(_ message: Message)
{
    let (head, body) = Frame.parts(of: message)
    if splitsFrames
    {
        out.write(head)
        usleep(50_000)
        out.write(body)
    }
    else
    {
        out.write(head + body)
    }
}

@MainActor
func respond(
    _ request: Message,
    success: Bool = true,
    body: JSON? = nil,
    message: String? = nil)
{
    emit(.response(
        seq,
        to: request,
        success: success,
        body: body,
        message: message))
    seq += 1
}

@MainActor
func event(_ name: String, body: JSON? = nil)
{
    emit(.event(seq, name, body: body))
    seq += 1
}

@MainActor
func stopped(_ reason: String)
{
    event(
        "stopped",
        body:
        [
            "reason": .string(reason),
            "threadId": 1,
            "allThreadsStopped": true
        ])
}

@MainActor
func initialized()
{
    initializedSent = true
    event("initialized")
}

@MainActor
func handle(_ request: Message)
{
    switch request.command ?? ""
    {
    case "initialize":
        respond(request, body: ["supportsConfigurationDoneRequest": true])
        if !initializedAfterStart
        {
            initialized()
        }
    case "launch", "attach":
        respond(request)
        startAcknowledged = true
        if initializedAfterStart
        {
            initialized()
        }
    case "setBreakpoints":
        guard initializedSent else
        {
            respond(
                request,
                success: false,
                message: "setBreakpoints before initialized")
            return
        }
        let line = request.arguments?["lines"]?.array?.first ?? 11
        respond(
            request,
            body: ["breakpoints": [["verified": true, "line": line]]])
    case "configurationDone":
        guard startAcknowledged else
        {
            respond(
                request,
                success: false,
                message: "configurationDone before the start was acknowledged")
            return
        }
        respond(request)
        stopped("breakpoint")
    case "next", "stepIn", "stepOut":
        respond(request)
        stopped("step")
    case "evaluate":
        let expression = request.arguments?["expression"]?.string ?? ""
        respond(
            request,
            body:
            [
                "result": .string("value(\(expression))"),
                "variablesReference": 0
            ])
    case "disconnect":
        switch onDisconnect
        {
        case "ignore":
            sleep(30)
        case "linger", "ignore-term":
            respond(request)
            sleep(30)
        default:
            respond(request)
        }
        exit(0)
    default:
        respond(request)
    }
}

while true
{
    let chunk = FileHandle.standardInput.availableData
    guard !chunk.isEmpty else
    {
        break
    }
    buffer.append(chunk)
    var parsing = true
    while parsing
    {
        switch Frame.parse(buffer)
        {
        case .message(let request, let consumed):
            handle(request)
            buffer.removeFirst(consumed)
        case .incomplete:
            parsing = false
        case .corrupt:
            exit(2)
        }
    }
}

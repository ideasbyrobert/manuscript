import Foundation
import Testing

@testable import Adapter

@Suite("The envelope the protocol reads")
struct MessageTests
{
    @Test("a response is written with request_seq, as the wire spells it")
    func wireSpelling() throws
    {
        let request = Message.request(7, "evaluate", ["expression": "x"])
        let response = Message.response(8, to: request, body: ["result": "v"])
        let data = try JSONEncoder().encode(response)
        let text = String(decoding: data, as: UTF8.self)
        #expect(text.contains("\"request_seq\":7"))
        #expect(!text.contains("requestSeq"))
        #expect(response.command == "evaluate")
        #expect(response.type == .response)
    }

    @Test("failure speaks only when success is false")
    func failure()
    {
        let request = Message.request(1, "launch")
        #expect(Message.response(2, to: request).failure == nil)
        #expect(Message.request(3, "x").failure == nil)
        let refused = Message.response(
            4,
            to: request,
            success: false,
            message: "no program")
        #expect(refused.failure == "no program")
        let mute = Message.response(5, to: request, success: false)
        #expect(mute.failure == "(no message)")
    }

    @Test("an event carries its name and body and nothing of a request")
    func event()
    {
        let stopped = Message.event(9, "stopped", body: ["threadId": 1])
        #expect(stopped.type == .event)
        #expect(stopped.event == "stopped")
        #expect(stopped.body?["threadId"]?.int == 1)
        #expect(stopped.command == nil)
        #expect(stopped.requestSeq == nil)
    }
}

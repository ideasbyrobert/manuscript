import Foundation
import Testing

@testable import Adapter

@Suite("Content-Length frames, wherever the pipe cuts them")
struct FrameTests
{
    private let request = Message.request(1, "test", ["foo": 1])

    private func raw(_ head: String, _ body: String) -> Data
    {
        Data(head.utf8) + Data(body.utf8)
    }

    @Test("nothing, a bare header, and a short body are all incomplete")
    func incomplete()
    {
        #expect(Frame.parse(Data()) == .incomplete)
        #expect(Frame.parse(Data("Content-Length: 10\r\n".utf8)) == .incomplete)
        let short = raw("Content-Length: 100\r\n\r\n", "{}")
        #expect(Frame.parse(short) == .incomplete)
    }

    @Test("a whole frame parses and reports its own length")
    func whole()
    {
        let data = Frame.encode(request)
        #expect(Frame.parse(data) == .message(request, consumed: data.count))
    }

    @Test("two frames: the first parses and the rest is exactly the second")
    func firstOfTwo()
    {
        let second = Message.request(2, "other")
        let data = Frame.encode(request) + Frame.encode(second)
        guard case .message(let found, let consumed) = Frame.parse(data) else
        {
            Issue.record("first frame did not parse")
            return
        }
        #expect(found == request)
        #expect(data[consumed...] == Frame.encode(second))
    }

    @Test("the header name is read in any case")
    func caseInsensitiveHeader()
    {
        let body = Frame.parts(of: request).body
        let data = raw("content-length: \(body.count)\r\n\r\n", "")
            + body
        #expect(Frame.parse(data) == .message(request, consumed: data.count))
    }

    @Test("garbage, a negative length and a non-object body are corrupt")
    func corrupt()
    {
        let negative = raw("Content-Length: -5\r\n\r\n", "{}")
        #expect(Frame.parse(negative) == .corrupt)
        let list = raw("Content-Length: 7\r\n\r\n", "[1,2,3]")
        #expect(Frame.parse(list) == .corrupt)
        #expect(Frame.parse(raw("Nonsense: 3\r\n\r\n", "{}")) == .corrupt)
        let long = Data(repeating: 0xFF, count: 9_000)
        #expect(Frame.parse(long) == .corrupt)
    }

    @Test("a frame in a slice that does not start at zero still parses")
    func sliceNotAtZero()
    {
        let second = Message.request(2, "other")
        let data = Frame.encode(request) + Frame.encode(second)
        let rest = data.dropFirst(Frame.encode(request).count)
        #expect(rest.startIndex != 0)
        #expect(Frame.parse(rest) == .message(second, consumed: rest.count))
    }

    @Test("a body cut in the middle waits, then parses once whole")
    func cutBody()
    {
        let data = Frame.encode(request)
        let half = data[..<(data.count - 3)]
        #expect(Frame.parse(half) == .incomplete)
        #expect(Frame.parse(data) == .message(request, consumed: data.count))
    }
}

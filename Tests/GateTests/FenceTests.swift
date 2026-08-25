import Testing

@testable import Gate

@Suite("A fence only the newest ticket passes")
struct FenceTests
{
    @Test("only the newest attempt may publish")
    func onlyTheNewest()
    {
        var fence = Fence<String>()
        let first = fence.begin(for: "a")
        let second = fence.begin(for: "b")
        #expect(!fence.accepts(first))
        #expect(fence.accepts(second))
    }

    @Test("retrying the same subject still refuses the older attempt")
    func retryRefusesOlder()
    {
        var fence = Fence<String>()
        let first = fence.begin(for: "a")
        let second = fence.begin(for: "a")
        #expect(!fence.accepts(first))
        #expect(fence.accepts(second))
        #expect(first.subject == second.subject)
    }

    @Test("invalidation refuses an attempt still in flight")
    func invalidationRefuses()
    {
        var fence = Fence<String>()
        let ticket = fence.begin(for: "a")
        #expect(fence.accepts(ticket))
        fence.invalidate()
        #expect(!fence.accepts(ticket))
    }

    @Test("a ticket another fence issued is refused, whatever its generation")
    func anotherFenceRefused()
    {
        var one = Fence<String>()
        var two = Fence<String>()
        let fromOne = one.begin(for: "a")
        let fromTwo = two.begin(for: "a")
        #expect(!two.accepts(fromOne))
        #expect(!one.accepts(fromTwo))
        #expect(one.accepts(fromOne))
    }

    @Test("two tickets for one subject never alias as keys")
    func neverAlias()
    {
        var one = Fence<String>()
        var two = Fence<String>()
        let a = one.begin(for: "x")
        let b = one.begin(for: "x")
        let c = two.begin(for: "x")
        #expect(Set([a, b, c]).count == 3)
    }
}

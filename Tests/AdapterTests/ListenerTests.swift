import Testing

@testable import Adapter

@Suite("A waiter with a name to find it by")
struct ListenerTests
{
    @Test("a listener is woken by whoever finds its id")
    func wokenById() async
    {
        let found: Message? = await withCheckedContinuation
        {
            let listener = Listener(id: 3, wake: $0)
            #expect(listener.id == 3)
            listener.wake.resume(returning: .event(1, "x"))
        }
        #expect(found?.event == "x")
    }
}

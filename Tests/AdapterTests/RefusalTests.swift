import Testing

@testable import Adapter

@Suite("A refusal is an error that remembers who refused")
struct RefusalTests
{
    @Test("it can be thrown and caught with its words intact")
    func thrownAndCaught()
    {
        do
        {
            throw Refusal(command: "initialize", message: "adapter unavailable")
        }
        catch let refusal as Refusal
        {
            #expect(refusal.command == "initialize")
            #expect(refusal.message == "adapter unavailable")
        }
        catch
        {
            Issue.record("caught something other than a refusal")
        }
    }
}

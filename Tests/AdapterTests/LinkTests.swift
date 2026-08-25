import Foundation
import Testing

@testable import Adapter

@Suite("The seam a launch talks through")
struct LinkTests
{
    @Test("a double answers a request by its sequence")
    func doubleAnswers() async throws
    {
        let link = Scripted()
        let asked = Task
        {
            try await link.request("evaluate", ["expression": "x"])
        }
        #expect(await link.sentCount(reaches: 1))
        await link.answer(1, body: ["result": "v"])
        let response = try await within(.seconds(2)) { try await asked.value }
        #expect(response.body?["result"]?.string == "v")
        #expect(await link.commands == ["evaluate"])
    }

    @Test("a double resolves a wait when the event is emitted")
    func doubleEmits() async throws
    {
        let link = Scripted()
        let waited = Task
        {
            await link.once("initialized")
        }
        try await Task.sleep(for: .milliseconds(20))
        await link.emit("initialized")
        let event = try await within(.seconds(2)) { await waited.value }
        #expect(event?.event == "initialized")
    }

    @Test("a session is a link, so the launch cannot tell them apart")
    func sessionIsALink()
    {
        let session = Session(executable: URL(fileURLWithPath: "/usr/bin/true"))
        let link: any Link = session
        #expect(link is Session)
    }
}

import Testing
import WebKit

@testable import Web

@MainActor
@Suite("The view we build")
struct ConfigurationTests
{
    @Test("the store is not persistent, so a test host writes nothing")
    func nonPersistentStore()
    {
        let configuration = Configuration.make()
        #expect(!configuration.websiteDataStore.isPersistent)
    }

    @Test("the view presents as Safari, because sites gate on it")
    func presentsAsSafari()
    {
        let name = Configuration.make().applicationNameForUserAgent
        #expect(name == Configuration.safari)
        #expect(Configuration.safari.contains("Safari"))
    }

    @Test("a never-windowed view is not suspended")
    func notSuspended()
    {
        let configuration = Configuration.make()
        #expect(configuration.preferences.inactiveSchedulingPolicy == .none)
    }
}

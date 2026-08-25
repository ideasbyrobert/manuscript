import Testing

@testable import Posture

@Suite("What the process says about where it lives")
struct ContainerTests
{
    @Test("the test host is not contained, and says so beside its home")
    func testHostIsFree()
    {
        let facts = Container.facts
        #expect(facts["contained"] == "false")
        #expect(facts["home"]?.isEmpty == false)
        #expect(facts["HOME"]?.isEmpty == false)
        #expect(facts["APP_SANDBOX_CONTAINER_ID"] == "")
    }
}

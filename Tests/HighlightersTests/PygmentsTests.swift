import Testing

@testable import Highlighters

@Suite("Where Pygments and Chroma put the block")
struct PygmentsTests
{
    private static let wrappers = [".highlight", ".chroma", ".codehilite"]

    private var containers: [String]
    {
        Pygments.highlighter.containers
    }

    @Test("a wrapper is grounded whether it holds the block or is one",
          arguments: PygmentsTests.wrappers)
    func everyWrapperIsGroundedBothWays(wrapper: String)
    {
        #expect(
            containers.contains(wrapper + ":has(> pre)"),
            "a div or figure wearing \(wrapper) keeps the page's ground")
        #expect(
            containers.contains("pre" + wrapper),
            "a pre wearing \(wrapper) is left unpainted")
    }

    @Test("a bare wrapper class never grounds anything",
          arguments: PygmentsTests.wrappers)
    func aBareWrapperIsNeverAContainer(wrapper: String)
    {
        #expect(
            !containers.contains(wrapper),
            "\(wrapper) would reach any element wearing that name")
    }

    @Test("every wrapper scopes its own pre and code")
    func everyWrapperScopesItsContents()
    {
        for wrapper in PygmentsTests.wrappers
        {
            #expect(containers.contains(wrapper + " pre"))
            #expect(containers.contains(wrapper + " code"))
        }
    }
}

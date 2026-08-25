import Testing

@testable import Highlighters
@testable import ThemeDomain

@Suite("A custom property carried to a role")
struct PropertyBridgeTests
{
    @Test("the property and the role are kept as given")
    func keepsBoth()
    {
        let bridge = PropertyBridge("--prettylights-syntax-keyword", .keyword)
        #expect(bridge.property == "--prettylights-syntax-keyword")
        #expect(bridge.role == .keyword)
    }

    @Test("every bridge in the catalogue names a custom property")
    func bridgesAreCustomProperties()
    {
        #expect(!PrettyLights.bridges.isEmpty)
        for bridge in PrettyLights.bridges
        {
            #expect(bridge.property.hasPrefix("--"), "\(bridge.property)")
        }
    }
}

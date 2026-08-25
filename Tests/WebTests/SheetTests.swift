import Testing

@testable import Web

@Suite("The script that carries the sheet into the page")
struct SheetScriptTests
{
    @Test("the css is embedded as a quoted literal, not concatenated")
    func cssIsQuoted()
    {
        let script = Sheet.script(css: "a{color:red}")
        #expect(script.contains("const source = \"a{color:red}\""))
    }

    @Test("special characters in the css are escaped, not broken out of")
    func escapes()
    {
        let script = Sheet.script(css: "a::after{content:\"\\A\"}")
        #expect(!script.contains("content:\"\\A\"}\""))
        #expect(script.contains("\\\""))
    }

    @Test("the script names the element it plants and re-plants on load")
    func plantsAndReplants()
    {
        let script = Sheet.script(css: "x")
        #expect(script.contains("\"manuscript-sheet\""))
        #expect(script.contains("DOMContentLoaded"))
        #expect(script.contains("window.addEventListener(\"load\""))
    }
}

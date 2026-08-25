import Testing

@testable import Adapter

@Suite("What a launch says about itself")
struct ConfigurationTests
{
    private let launch = Configuration(
        clientID: "manuscript",
        adapterID: "lldb",
        start: .launch(["program": "/tmp/hello"]),
        breakpoints: ["/proj/B.swift": [22, 3], "/proj/A.swift": [11]])

    @Test("initialize names the client and the adapter, lines from one")
    func initializeArguments()
    {
        let arguments = launch.initializeArguments
        #expect(arguments["clientID"]?.string == "manuscript")
        #expect(arguments["adapterID"]?.string == "lldb")
        #expect(arguments["linesStartAt1"]?.bool == true)
        #expect(arguments["supportsRunInTerminalRequest"]?.bool == false)
    }

    @Test("the start command follows the kind of start, and keeps its words")
    func start()
    {
        #expect(launch.startCommand == "launch")
        #expect(launch.startArguments["program"]?.string == "/tmp/hello")
        let attach = Configuration(
            clientID: "m",
            adapterID: "lldb",
            start: .attach(["pid": 1234]))
        #expect(attach.startCommand == "attach")
        #expect(attach.startArguments["pid"]?.int == 1234)
        #expect(attach.breakpointRequests.isEmpty)
    }

    @Test("one breakpoint request per source, sources and lines sorted")
    func breakpointRequests()
    {
        let requests = launch.breakpointRequests
        #expect(requests.count == 2)
        #expect(requests[0]["source"]?["path"]?.string == "/proj/A.swift")
        #expect(requests[0]["source"]?["name"]?.string == "A.swift")
        #expect(requests[1]["lines"]?.array?.compactMap(\.int) == [3, 22])
        let lines = requests[1]["breakpoints"]?.array?
            .compactMap { $0["line"]?.int }
        #expect(lines == [3, 22])
        #expect(requests[1]["sourceModified"]?.bool == false)
    }
}

import Foundation

package struct Configuration: Hashable, Sendable
{
    package enum Start: Hashable, Sendable
    {
        case launch(JSON)
        case attach(JSON)
    }

    package let clientID: String
    package let adapterID: String
    package let start: Start
    package let breakpoints: [String: [Int]]

    package init(
        clientID: String,
        adapterID: String,
        start: Start,
        breakpoints: [String: [Int]] = [:])
    {
        self.clientID = clientID
        self.adapterID = adapterID
        self.start = start
        self.breakpoints = breakpoints
    }

    package var initializeArguments: JSON
    {
        [
            "clientID": .string(clientID),
            "adapterID": .string(adapterID),
            "linesStartAt1": true,
            "columnsStartAt1": true,
            "pathFormat": "path",
            "supportsRunInTerminalRequest": false
        ]
    }

    package var startCommand: String
    {
        switch start
        {
        case .launch: return "launch"
        case .attach: return "attach"
        }
    }

    package var startArguments: JSON
    {
        switch start
        {
        case .launch(let arguments): return arguments
        case .attach(let arguments): return arguments
        }
    }

    package var breakpointRequests: [JSON]
    {
        breakpoints.keys.sorted().map
        {
            path in
            let lines = (breakpoints[path] ?? []).sorted()
            return [
                "source":
                [
                    "path": .string(path),
                    "name": .string((path as NSString).lastPathComponent)
                ],
                "breakpoints": .array(lines.map
                {
                    ["line": .number(Double($0))]
                }),
                "lines": .array(lines.map { .number(Double($0)) }),
                "sourceModified": false
            ]
        }
    }
}

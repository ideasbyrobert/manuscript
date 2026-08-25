package enum Probe: String, CaseIterable, Codable, Sendable
{
    case sandbox
    case read
    case bookmark
    case web
    case debug
    case mach
    case machClient = "mach-client"

    package var entitlements: Entitlements
    {
        switch self
        {
        case .bookmark: return .sandboxed.adding(.bookmarksAppScope)
        case .web: return .sandboxed.adding(.networkClient)
        default: return .sandboxed
        }
    }

    package func measure(_ arguments: [String]) async -> Report
    {
        let facts = Container.facts
        switch self
        {
        case .sandbox:
            let paths = ["outside": arguments.first ?? ""]
            return Report(self, verdicts: Outside.measure(paths), facts: facts)
        case .read:
            let paths =
            [
                "documents": arguments.first ?? "",
                "argv": arguments.dropFirst().first ?? ""
            ]
            return Report(self, verdicts: Outside.measure(paths), facts: facts)
        default:
            return Report(self, verdicts: [], facts: facts)
        }
    }
}

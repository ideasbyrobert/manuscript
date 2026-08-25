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
        Report(self, verdicts: [])
    }
}

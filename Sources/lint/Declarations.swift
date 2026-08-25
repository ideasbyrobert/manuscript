enum Declarations
{
    static let kinds = ["struct", "enum", "class", "actor", "protocol"]

    static func opens(_ code: String) -> Bool
    {
        let body = BlockKeyword.stripped(code)
        return kinds.contains { body.hasPrefix($0 + " ") }
    }

    static func count(in lines: [SourceLine]) -> Int
    {
        lines.filter { $0.opensTopLevelType }.count
    }
}

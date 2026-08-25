package indirect enum Block: Sendable
{
    case rule(Rule)
    case when(MediaCondition, [Block])

    package var important: Block
    {
        switch self
        {
        case .rule(let rule):
            return .rule(rule.important)
        case .when(let condition, let blocks):
            return .when(condition, blocks.map { $0.important })
        }
    }

    package var text: String
    {
        switch self
        {
        case .rule(let rule):
            return rule.text
        case .when(let condition, let blocks):
            return Block.wrap(condition, blocks)
        }
    }

    private static func wrap(
        _ condition: MediaCondition,
        _ blocks: [Block]) -> String
    {
        let inner = blocks.map { $0.text }.filter { !$0.isEmpty }
        guard !inner.isEmpty else
        {
            return ""
        }
        let indented = inner
            .joined(separator: "\n\n")
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { $0.isEmpty ? "" : "    " + $0 }
            .joined(separator: "\n")
        return "@media \(condition.text)\n{\n" + indented + "\n}"
    }
}

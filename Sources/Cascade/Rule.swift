package struct Rule: Sendable, Equatable
{
    package let selectors: [String]
    package let declarations: [Declaration]

    package init(
        _ selectors: [String],
        _ declarations: [Declaration])
    {
        self.selectors = selectors
        self.declarations = declarations
    }

    package var important: Rule
    {
        Rule(selectors, declarations.map { $0.important })
    }

    package var text: String
    {
        guard !selectors.isEmpty, !declarations.isEmpty else
        {
            return ""
        }
        let head = selectors.joined(separator: ",\n")
        let body = declarations
            .map { "    " + $0.text }
            .joined(separator: "\n")
        return head + "\n{\n" + body + "\n}"
    }
}

package struct StyleSheet: Sendable
{
    private let blocks: [Block]

    package init(_ blocks: [Block])
    {
        self.blocks = blocks
    }

    package var userOrigin: StyleSheet
    {
        StyleSheet(blocks.map { $0.important })
    }

    package var text: String
    {
        blocks
            .map { $0.text }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }
}

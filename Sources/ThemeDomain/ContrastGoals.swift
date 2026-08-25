import Pigment

enum ContrastGoals
{
    static let bySlot: [InkSlot: ContrastGoal] =
    [
        .keyword: ContrastGoal(79, chromaFactor: 1.00),
        .type: ContrastGoal(71, chromaFactor: 0.95),
        .alternateType: ContrastGoal(78, chromaFactor: 0.85),
        .member: ContrastGoal(72, chromaFactor: 0.95),
        .alternateMember: ContrastGoal(77, chromaFactor: 0.85),
        .string: ContrastGoal(73, chromaFactor: 0.90),
        .number: ContrastGoal(79, chromaFactor: 0.95),
        .preprocessor: ContrastGoal(78, chromaFactor: 0.80),
        .link: ContrastGoal(79, chromaFactor: 0.95)
    ]

    static let softKeyword = ContrastGoal(77, chromaFactor: 0.82)
    static let alternateString = ContrastGoal(78, chromaFactor: 0.75)
    static let namespace = ContrastGoal(77, chromaFactor: 0.70)
    static let label = ContrastGoal(76, chromaFactor: 0.85)

    static let error = ContrastGoal(70, chromaFactor: 1.00)
    static let warning = ContrastGoal(69, chromaFactor: 1.00)
    static let information = ContrastGoal(72, chromaFactor: 0.90)
    static let hint = ContrastGoal(70, chromaFactor: 0.80)
    static let addition = ContrastGoal(71, chromaFactor: 1.00)
    static let removal = ContrastGoal(69, chromaFactor: 1.00)
    static let modification = ContrastGoal(71, chromaFactor: 0.95)

    static let plainText = Readability(97)
    static let dimText = Readability(82)
    static let faintText = Readability(64)
    static let ghostText = Readability(39)
    static let whitespace = Readability(33)
    static let indentGuide = Readability(19)
    static let comment = Readability(59)
    static let documentation = Readability(64)
    static let punctuation = Readability(81)
    static let operatorGlyph = Readability(85)
    static let modeAccent = Readability(71)
    static let modeNormal = Readability(73)
    static let jumpLabel = Readability(69)
    static let debugger = Readability(75)
    static let breakpoint = Readability(73)

    static let selection = ContrastRatio(1.30)
    static let dimSelection = ContrastRatio(1.16)
    static let matchingBracket = ContrastRatio(1.32)
    static let searchHighlight = ContrastRatio(1.14)
}

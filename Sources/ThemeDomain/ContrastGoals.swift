import Pigment

public enum ContrastGoals
{
    public static let bySlot: [InkSlot: ContrastGoal] =
    [
        .keyword: ContrastGoal(6.90, chromaFactor: 1.00),
        .type: ContrastGoal(5.60, chromaFactor: 0.95),
        .alternateType: ContrastGoal(6.50, chromaFactor: 0.85),
        .member: ContrastGoal(5.30, chromaFactor: 0.95),
        .alternateMember: ContrastGoal(6.10, chromaFactor: 0.85),
        .string: ContrastGoal(5.40, chromaFactor: 0.90),
        .number: ContrastGoal(5.90, chromaFactor: 0.95),
        .preprocessor: ContrastGoal(6.40, chromaFactor: 0.80),
        .link: ContrastGoal(6.60, chromaFactor: 0.95)
    ]

    public static let softKeyword = ContrastGoal(6.20, chromaFactor: 0.82)
    public static let alternateString = ContrastGoal(6.30, chromaFactor: 0.75)
    public static let namespace = ContrastGoal(6.00, chromaFactor: 0.70)
    public static let label = ContrastGoal(6.00, chromaFactor: 0.85)

    public static let error = ContrastGoal(5.20, chromaFactor: 1.00)
    public static let warning = ContrastGoal(4.60, chromaFactor: 1.00)
    public static let information = ContrastGoal(5.20, chromaFactor: 0.90)
    public static let hint = ContrastGoal(4.80, chromaFactor: 0.80)
    public static let addition = ContrastGoal(5.00, chromaFactor: 1.00)
    public static let removal = ContrastGoal(5.00, chromaFactor: 1.00)
    public static let modification = ContrastGoal(5.00, chromaFactor: 0.95)

    public static let plainText = ContrastRatio(14.00)
    public static let dimText = ContrastRatio(7.20)
    public static let faintText = ContrastRatio(3.90)
    public static let ghostText = ContrastRatio(2.10)
    public static let whitespace = ContrastRatio(1.85)
    public static let indentGuide = ContrastRatio(1.42)
    public static let comment = ContrastRatio(3.40)
    public static let documentation = ContrastRatio(3.90)
    public static let punctuation = ContrastRatio(6.80)
    public static let operatorGlyph = ContrastRatio(8.20)
    public static let modeAccent = ContrastRatio(5.00)
    public static let modeNormal = ContrastRatio(5.40)
    public static let jumpLabel = ContrastRatio(5.00)
    public static let debugger = ContrastRatio(5.60)
    public static let breakpoint = ContrastRatio(5.40)
}

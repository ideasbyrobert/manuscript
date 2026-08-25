public enum PaletteName: String, CaseIterable, Sendable
{
    case background
    case raisedBackground
    case overlayBackground
    case insetBackground
    case cursorLine
    case cursorColumn
    case softBorder
    case ruler

    case text
    case dimText
    case faintText
    case ghostText
    case whitespace
    case indentGuide

    case keyword
    case softKeyword
    case type
    case alternateType
    case member
    case alternateMember
    case string
    case alternateString
    case number
    case preprocessor
    case link
    case namespace
    case label
    case comment
    case documentation
    case punctuation
    case `operator`

    case error
    case warning
    case information
    case hint
    case addition
    case removal
    case modification

    case selection
    case dimSelection
    case cursor
    case matchingBracket
    case searchHighlight
    case jumpLabel
    case modeNormal
    case modeInsert
    case modeSelect
    case debugger
    case breakpoint
    case modificationBackground
}

package enum PostScriptName
{
    package static func of(
        _ typeface: Typeface,
        weight: TypeWeight = .regular,
        slant: TypeSlant = .upright) -> String?
    {
        guard typeface.weights.contains(weight) else
        {
            return nil
        }
        guard slant == .upright || typeface.carriesItalics else
        {
            return nil
        }
        if typeface == .sfCompactText
            && weight == .regular
            && slant == .italic
        {
            return "SFCompactText-Italic"
        }
        return typeface.stem + "-" + weight.suffix + slant.suffix
    }
}

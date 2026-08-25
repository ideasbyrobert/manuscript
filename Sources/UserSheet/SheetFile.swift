package enum SheetFile
{
    package static func name(for pair: ThemePair) -> String
    {
        pair.name + ".css"
    }

    package static func text(for pair: ThemePair) -> String
    {
        UserStyleSheet.sheet(for: pair).text + "\n"
    }
}

import Foundation
import ThemeDomain
import UserSheet

let arguments = CommandLine.arguments
guard arguments.count == 2 else
{
    FileHandle.standardError.write(
        Data("stylesheet: expected one output directory\n".utf8))
    exit(2)
}

let directory = arguments[1]
let pairs = ThemePair.all(in: Theme.catalogue())
let expected = Theme.catalogue().count / 2
guard pairs.count == expected else
{
    FileHandle.standardError.write(
        Data("stylesheet: \(pairs.count) of \(expected) presets paired\n"
            .utf8))
    exit(1)
}
do
{
    try FileManager.default.createDirectory(
        atPath: directory,
        withIntermediateDirectories: true)
    for pair in pairs
    {
        let path = directory + "/" + SheetFile.name(for: pair)
        let text = SheetFile.text(for: pair)
        try text.write(toFile: path, atomically: true, encoding: .utf8)
        print("\(path)  \(text.count) characters")
    }
}
catch
{
    FileHandle.standardError.write(
        Data("stylesheet: \(error)\n".utf8))
    exit(1)
}

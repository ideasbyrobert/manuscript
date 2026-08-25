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
do
{
    try FileManager.default.createDirectory(
        atPath: directory,
        withIntermediateDirectories: true)
    for pair in ThemePair.all(in: Theme.catalogue())
    {
        let path = directory + "/" + pair.name + ".css"
        let text = UserStyleSheet.sheet(for: pair).text + "\n"
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

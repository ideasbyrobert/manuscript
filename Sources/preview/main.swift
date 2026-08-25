import Foundation
import Specimen
import ThemeDomain

let arguments = CommandLine.arguments
guard arguments.count == 2 else
{
    FileHandle.standardError.write(
        Data("specimen: expected one output path\n".utf8))
    exit(2)
}

let page = SpecimenCatalogue.page(for: Theme.catalogue())
do
{
    try page.write(
        toFile: arguments[1],
        atomically: true,
        encoding: .utf8)
    print("\(arguments[1])  \(page.count) characters")
}
catch
{
    FileHandle.standardError.write(
        Data("specimen: \(error)\n".utf8))
    exit(1)
}

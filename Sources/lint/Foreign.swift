import Foundation

enum Foreign
{
    static let admitted = [".gitignore", "Package.resolved"]

    static func rejects(_ file: URL) -> Bool
    {
        guard file.pathExtension != "swift" else
        {
            return false
        }
        return !admitted.contains(file.lastPathComponent)
    }
}

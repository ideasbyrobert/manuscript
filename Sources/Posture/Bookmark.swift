import Foundation

package enum Bookmark
{
    package static func path(_ given: String) -> String
    {
        guard !given.hasPrefix("/") else
        {
            return given
        }
        let name = given.isEmpty ? "held" : given
        let url = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent(name)
        try? Data("inside the container\n".utf8).write(to: url)
        return url.path
    }

    package static func measure(_ path: String) -> [Verdict]
    {
        let url = URL(fileURLWithPath: path)
        let data: Data
        do
        {
            data = try url.bookmarkData(options: .withSecurityScope)
        }
        catch let error as NSError
        {
            return [Verdict(
                "mint",
                .denied,
                code: error.code,
                domain: error.domain,
                message: error.localizedDescription)]
        }
        var stale = false
        let resolved: URL
        do
        {
            resolved = try URL(
                resolvingBookmarkData: data,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &stale)
        }
        catch let error as NSError
        {
            return [
                Verdict("mint", .permitted),
                Verdict(
                    "resolve",
                    .denied,
                    code: error.code,
                    domain: error.domain)]
        }
        let opened = resolved.startAccessingSecurityScopedResource()
        defer
        {
            if opened
            {
                resolved.stopAccessingSecurityScopedResource()
            }
        }
        return [
            Verdict("mint", .permitted),
            Verdict("resolve", .permitted),
            Verdict("access", opened ? .permitted : .denied)
        ] + Outside.measure(["read": resolved.path])
    }
}

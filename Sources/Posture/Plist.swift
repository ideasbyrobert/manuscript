package enum Plist
{
    package enum Value: Hashable, Sendable
    {
        case flag(Bool)
        case text(String)
        case list([String])
    }

    package static func document(_ entries: [String: Value]) -> String
    {
        var lines =
        [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            "<plist version=\"1.0\">",
            "<dict>"
        ]
        for key in entries.keys.sorted()
        {
            lines.append("<key>\(escaped(key))</key>")
            lines.append(contentsOf: rendered(entries[key]!))
        }
        lines.append(contentsOf: ["</dict>", "</plist>", ""])
        return lines.joined(separator: "\n")
    }

    private static func rendered(_ value: Value) -> [String]
    {
        switch value
        {
        case .flag(let flag):
            return [flag ? "<true/>" : "<false/>"]
        case .text(let text):
            return ["<string>\(escaped(text))</string>"]
        case .list(let items):
            return ["<array>"]
                + items.map { "<string>\(escaped($0))</string>" }
                + ["</array>"]
        }
    }

    private static func escaped(_ text: String) -> String
    {
        var out = ""
        for character in text
        {
            switch character
            {
            case "&": out += "&amp;"
            case "<": out += "&lt;"
            case ">": out += "&gt;"
            case "\"": out += "&quot;"
            default: out.append(character)
            }
        }
        return out
    }
}

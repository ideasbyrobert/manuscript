struct SourceLine
{
    let number: Int
    let text: String

    var width: Int
    {
        text.count
    }

    var carriesComment: Bool
    {
        !isToolsVersionDirective
            && (code.contains("//") || code.contains("/*"))
    }

    var opensBraceOnSameLine: Bool
    {
        guard code.reversed().drop(while: { $0 == " " }).first == "{" else
        {
            return false
        }
        return BlockKeyword.opens(code)
    }

    private var isToolsVersionDirective: Bool
    {
        text.drop { $0 == " " }.hasPrefix("// swift-tools-version:")
    }

    private var code: String
    {
        var stripped = ""
        var quoted = false
        var previous: Character?
        for character in text
        {
            if character == "\"", previous != "\\"
            {
                quoted.toggle()
                previous = character
                continue
            }
            if !quoted
            {
                stripped.append(character)
            }
            previous = character
        }
        return stripped
    }
}

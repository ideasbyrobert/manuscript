import ThemeDomain

package enum Pygments
{
    package static let highlighter = Highlighter(
        name: "Pygments",
        containers: scoped(["pre", "code"]) + [".highlight", ".chroma"],
        bindings: bindings)

    private static let wrappers = [".highlight", ".chroma", ".codehilite"]

    private static func scoped(_ classes: [String]) -> [String]
    {
        wrappers.flatMap
        { wrapper in
            classes.map { wrapper + " " + $0 }
        }
    }

    private static let bindings: [TokenBinding] =
    [
        TokenBinding(
            scoped([".c", ".ch", ".cm", ".c1", ".cs", ".cd"]),
            .comment,
            .italic),
        TokenBinding(scoped([".cp", ".cpf"]), .preprocessor),
        TokenBinding(
            scoped([".k", ".kc", ".kd", ".kn", ".kp", ".kr"]),
            .keyword,
            .bold),
        TokenBinding(scoped([".kt", ".nc", ".nn", ".bp"]), .type),
        TokenBinding(scoped([".nf", ".fm", ".nd"]), .member),
        TokenBinding(scoped([".nb", ".no"]), .alternateType),
        TokenBinding(scoped([".nt", ".na"]), .label),
        TokenBinding(
            scoped([".nv", ".vc", ".vg", ".vi", ".vm", ".nx", ".nl"]),
            .alternateMember),
        TokenBinding(
            scoped([".s", ".sa", ".sb", ".sc", ".dl", ".sd", ".s2",
                    ".sh", ".sx", ".s1", ".ss"]),
            .string),
        TokenBinding(scoped([".se", ".si", ".sr"]), .alternateString),
        TokenBinding(
            scoped([".m", ".mb", ".mf", ".mh", ".mi", ".mo", ".il"]),
            .number),
        TokenBinding(scoped([".o", ".ow"]), .operator),
        TokenBinding(scoped([".p", ".pm"]), .punctuation),
        TokenBinding(scoped([".gi"]), .addition),
        TokenBinding(scoped([".gd"]), .removal),
        TokenBinding(scoped([".err", ".gr", ".gt"]), .error)
    ]
}

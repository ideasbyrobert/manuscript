import Cascade
import ThemeDomain

package enum Pygments
{
    package static let highlighter = Highlighter(
        name: "Pygments",
        containers: wrappers.flatMap { [$0 + " pre", $0 + " code"] }
            + hosts + gutters,
        bindings: bindings,
        resets: resets)

    package static let lineBands = scoped([".hll", ".hl"])

    private static let wrappers = [".highlight", ".chroma", ".codehilite"]

    private static let resets: [Rule] =
    [
        Rule(
            scoped([".err", ".gd", ".gi", ".gr", ".gt"]),
            [Declaration("background-color", "transparent")]),
        Rule(scoped([".err"]), [Declaration("border", "none")])
    ]

    private static let gutters =
    [
        ".highlighttable", ".highlighttable td", ".codehilitetable",
        ".codehilitetable td", ".chroma .lntable", ".chroma .lntd",
        "td.linenos pre", ".linenodiv pre"
    ]

    private static let hosts = wrappers.flatMap
    {
        [$0 + ":has(> pre)", "pre" + $0]
    }

    private static let block = ":is("
        + wrappers.flatMap { [$0 + " pre", "pre" + $0] }
            .joined(separator: ", ")
        + ")"

    private static func scoped(_ classes: [String]) -> [String]
    {
        classes.map { block + " " + $0 }
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
        TokenBinding(scoped([".gh", ".gu"]), .type, .bold),
        TokenBinding(scoped([".gp"]), .preprocessor, .bold),
        TokenBinding(scoped([".go"]), .dimText),
        TokenBinding(scoped([".ge"]), .text, .italic),
        TokenBinding(scoped([".gs", ".ges"]), .text, .bold),
        TokenBinding(scoped([".g"]), .text),
        TokenBinding(scoped([".err", ".gr", ".gt"]), .error),
        TokenBinding(scoped([".n", ".l", ".ld", ".x"]), .text),
        TokenBinding(scoped([".ne"]), .error),
        TokenBinding(scoped([".ni", ".esc"]), .alternateString),
        TokenBinding(scoped([".py"]), .alternateMember),
        TokenBinding(scoped([".w"]), .whitespace),
        TokenBinding(
            scoped([".linenos", ".lnt", ".ln"])
                + ["td.linenos pre", ".linenodiv pre"],
            .faintText),
        TokenBinding(
            scoped([".linenos.special"]) + ["td.linenos pre .special"],
            .warning)
    ]
}

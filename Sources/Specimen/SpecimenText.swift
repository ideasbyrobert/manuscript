package enum SpecimenText
{
    package static let code: [String] =
    [
        "{documentation|/// Readability of an ink upon a ground.}",
        "{documentation|/// Signed, so polarity survives it.}",
        "{keyword|package} {keyword|struct} {type|Readability}: "
            + "{alternateType|Sendable}",
        "{",
        "    {keyword|static} {keyword|let} {member|weight} = "
            + "{number|0.2126729}",
        "    {keyword|static} {keyword|let} {member|floor} = {number|0.022}",
        "",
        "    {keyword|package} {keyword|let} {member|value}: {type|Double}",
        "",
        "    {comment|// A darker ground reverses the sign.}",
        "    {keyword|package} {keyword|static} {keyword|func} "
            + "{alternateMember|between}(",
        "        {label|_} {member|ink}: {type|SRGB},",
        "        {label|_} {member|ground}: {type|SRGB}) {operator|->} "
            + "{type|Readability}",
        "    {",
        "        {keyword|let} {member|lit} = "
            + "{namespace|Self}.{alternateMember|flare}({member|ink})",
        "        {keyword|guard} {member|lit} {operator|>} {member|floor} "
            + "{softKeyword|else}",
        "        {",
        "            {keyword|return} {type|Readability}({number|0})",
        "        }",
        "        {preprocessor|#if} {preprocessor|DEBUG}",
        "        {alternateMember|log}({string|\"solved \"} {operator|+} "
            + "{alternateString|\"upon it\"})",
        "        {preprocessor|#endif}",
        "        {link|https://bottosson.github.io/oklab}",
        "        {keyword|return} {type|Readability}({member|lit} {operator|*} "
            + "{number|100})",
        "    }",
        "}",
    ]

    package static let bookTitle = "Moby-Dick, or, The Whale"

    package static let bookAuthor = "Herman Melville, 1851"

    package static let book: [String] =
    [
        "Call me Ishmael. Some years ago—never mind how long "
            + "precisely—having little or no money in my purse, and "
            + "nothing particular to interest me on shore, I thought I "
            + "would sail about a little and see the watery part of the "
            + "world.",
        "It is a way I have of driving off the spleen and regulating "
            + "the circulation. Whenever I find myself growing grim "
            + "about the mouth; whenever it is a damp, drizzly November "
            + "in my soul; whenever I find myself involuntarily pausing "
            + "before coffin warehouses, and bringing up the rear of "
            + "every funeral I meet; then, I account it high time to get "
            + "to sea as soon as I can.",
        "There now is your insular city of the Manhattoes, belted "
            + "round by wharves as Indian isles by coral reefs—commerce "
            + "surrounds it with her surf. Right and left, the streets "
            + "take you waterward."
    ]

    package static let editorialLede =
        "Every colour on this page was solved, not chosen. A hue is "
            + "fixed, a target named, and lightness moved until the "
            + "ink meets the ground at exactly the readability asked "
            + "of it."

    package static let editorialBody: [String] =
    [
        "The measure is perceptual rather than a contrast ratio. A "
            + "ratio is blind to polarity, so one number described a "
            + "light page and a dark one that read thirty-four points "
            + "apart. Solving perceptually closes that gap to nothing.",
        "The neutrals are tinted toward the preset's own hue, capped "
            + "at a share of what the gamut holds at that lightness. "
            + "This is not a departure from Apple's practice but a copy "
            + "of it: the dark editor in Xcode sits at hue 280, and its "
            + "comments are a hand-picked slate, not a system grey."
    ]

    package static let captions: [String] =
    [
        "Body sets in New York, the serif Apple cut at four optical "
            + "sizes.",
        "Code sets in SF Mono. Weight steps one rung on a dark ground, "
            + "as Apple's own themes do.",
        "Interface text sets in SF Pro."
    ]
}

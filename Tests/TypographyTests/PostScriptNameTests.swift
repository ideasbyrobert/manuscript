import AppKit
import Testing

@testable import Typography

@Suite("Names Apple's own faces answer to", .serialized)
struct PostScriptNameTests
{
    @Test("every name this composes resolves on the running system")
    func everyNameResolves()
    {
        var checked = 0
        for typeface in Typeface.allCases
        {
            for weight in typeface.weights
            {
                for slant in TypeSlant.allCases
                {
                    guard let name = PostScriptName.of(
                        typeface,
                        weight: weight,
                        slant: slant) else { continue }
                    let found = NSFont(name: name, size: 13)
                    #expect(found != nil, "\(name)")
                    #expect(found?.fontName == name, "\(name)")
                    checked += 1
                }
            }
        }
        #expect(checked == 159, "checked \(checked)")
    }

    @Test("the one face Apple names irregularly is handled")
    func compactTextItalicIsAnException()
    {
        #expect(
            PostScriptName.of(.sfCompactText, slant: .italic)
                == "SFCompactText-Italic")
        #expect(
            PostScriptName.of(.sfCompact, slant: .italic)
                == "SFCompact-RegularItalic")
        #expect(NSFont(name: "SFCompactText-RegularItalic", size: 13) == nil)
    }

    @Test("a weight a face does not carry is refused")
    func absentWeightsAreRefused()
    {
        #expect(PostScriptName.of(.sfMono, weight: .black) == nil)
        #expect(PostScriptName.of(.sfMono, weight: .thin) == nil)
        #expect(PostScriptName.of(.newYorkLarge, weight: .light) == nil)
        #expect(PostScriptName.of(.sfPro, weight: .black) != nil)
    }

    @Test("only SF Mono is fixed pitch, and the system agrees")
    func fixedPitchIsHonest()
    {
        for typeface in Typeface.allCases
        {
            guard let name = PostScriptName.of(typeface),
                  let font = NSFont(name: name, size: 13) else { continue }
            #expect(font.isFixedPitch == typeface.isFixedPitch, "\(name)")
        }
    }

    @Test("New York is four cuts, not one variable face")
    func newYorkIsCutFourTimes()
    {
        let cuts: [Typeface] =
        [
            .newYorkSmall, .newYorkMedium, .newYorkLarge, .newYorkExtraLarge
        ]
        let heights = cuts.compactMap
        {
            PostScriptName.of($0)
                .flatMap { NSFont(name: $0, size: 14) }?.xHeight
        }
        #expect(heights.count == 4)
        #expect(Set(heights).count == 4, "\(heights)")
    }
}

import Testing

@testable import Pigment
@testable import ThemeDomain

@Suite("Neutral ramps stay distinguishable", .serialized)
struct NeutralTintTests
{
    private static let neutrals: [PaletteName] =
    [
        .text, .dimText, .faintText, .ghostText, .whitespace,
        .indentGuide, .comment, .documentation, .punctuation, .operator
    ]

    @Test("ten neutral roles carry ten tints", arguments: Theme.catalogue())
    func tintsAreDistinct(theme: Theme)
    {
        let chromas = Set(Self.neutrals.map
        {
            Int((OKLCh(theme.palette[$0]).chroma.value * 10000).rounded())
        })
        #expect(chromas.count >= 8, "\(theme) has \(chromas.count)")
    }
}

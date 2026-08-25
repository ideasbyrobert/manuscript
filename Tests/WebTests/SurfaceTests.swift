import AppKit
import Foundation
import Testing

@testable import Pigment
@testable import ThemeDomain
@testable import UserSheet
@testable import Web

@MainActor
@Suite("The window, on screen", .serialized)
struct SurfaceTests
{
    private func centre(of image: NSImage) -> (Int, Int, Int)?
    {
        guard let data = image.tiffRepresentation,
            let rep = NSBitmapImageRep(data: data) else
        {
            return nil
        }
        let point = rep.colorAt(x: rep.pixelsWide / 2, y: rep.pixelsHigh / 2)
        guard let colour = point?.usingColorSpace(.sRGB) else
        {
            return nil
        }
        return (
            Int((colour.redComponent * 255).rounded()),
            Int((colour.greenComponent * 255).rounded()),
            Int((colour.blueComponent * 255).rounded()))
    }

    private func expected(_ colour: SRGB) -> (Int, Int, Int)
    {
        (
            Int((colour.red * 255).rounded()),
            Int((colour.green * 255).rounded()),
            Int((colour.blue * 255).rounded()))
    }

    @Test("the window shows our ground, measured from the pixels it drew")
    func showsOurGround() async throws
    {
        let pair = try #require(
            ThemePair.all(in: Theme.catalogue())
                .first { $0.name == "ember" })
        let surface = Surface(css: AuthorSheet.text(for: pair))
        surface.show()
        try await surface.present(
            html: Fixture.filled,
            base: URL(string: "https://manuscript.test/"))
        try await Task.sleep(for: .milliseconds(200))
        let image = try await surface.snapshot()
        let drawn = try #require(centre(of: image))
        let inset = expected(pair.light.palette[.insetBackground])
        let apart = abs(drawn.0 - inset.0) + abs(drawn.1 - inset.1)
            + abs(drawn.2 - inset.2)
        #expect(apart <= 12, "drawn \(drawn) inset \(inset)")
    }
}

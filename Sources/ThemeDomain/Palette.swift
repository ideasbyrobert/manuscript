import Pigment

package struct Palette: Sendable
{
    private let swatches: [PaletteName: SRGB]

    init(swatches: [PaletteName: SRGB])
    {
        let missing = Set(PaletteName.allCases).subtracting(swatches.keys)
        precondition(missing.isEmpty, "palette is missing \(missing)")
        self.swatches = swatches.mapValues { $0.quantised }
    }

    package subscript(name: PaletteName) -> SRGB
    {
        swatches[name]!
    }

    package func notation(_ name: PaletteName) -> String
    {
        self[name].hexNotation
    }

    func contrast(
        _ ink: PaletteName,
        against ground: PaletteName = .background) -> ContrastRatio
    {
        ContrastRatio.between(self[ink], self[ground])
    }
}

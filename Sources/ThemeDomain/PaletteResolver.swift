import AppleColors
import Pigment

public struct PaletteResolver
{
    private let preset: Preset
    private let appearance: Appearance
    private let systemColours: any SystemColourSource
    private let tint: Chroma
    private let groundLightness: Lightness
    private let ground: SRGB
    private let solver: LightnessSolver

    public init(
        preset: Preset,
        appearance: Appearance,
        systemColours: any SystemColourSource = RecordedSystemColours.macOS27)
    {
        self.preset = preset
        self.appearance = appearance
        self.systemColours = systemColours
        tint = preset.tint(in: appearance)
        groundLightness = GroundLightness.of(appearance)
        ground = OKLCh(
            lightness: groundLightness,
            chroma: tint,
            hue: preset.tintHue).srgb
        solver = LightnessSolver(ground: ground)
    }

    public func resolve() -> Palette
    {
        var swatches: [PaletteName: SRGB] = [:]
        for group in [surfaces(), neutrals(), syntax(), statuses(), furniture()]
        {
            swatches.merge(group) { current, _ in current }
        }
        return Palette(swatches: swatches)
    }

    private func surfaces() -> [PaletteName: SRGB]
    {
        [
            .background: ground,
            .raisedBackground: surface(steppedBy: 0.0300, tintedBy: 1.0),
            .overlayBackground: surface(steppedBy: 0.0480, tintedBy: 1.6),
            .insetBackground: surface(steppedBy: 0.0160, tintedBy: 1.4),
            .cursorLine: surface(steppedBy: 0.0115, tintedBy: 3.5),
            .cursorColumn: surface(steppedBy: 0.0075, tintedBy: 3.4),
            .softBorder: surface(steppedBy: 0.0680, tintedBy: 2.0),
            .ruler: surface(steppedBy: 0.0300, tintedBy: 5.0)
        ]
    }

    private func neutrals() -> [PaletteName: SRGB]
    {
        [
            .text: neutral(ContrastGoals.plainText, tintedBy: 2.2),
            .dimText: neutral(ContrastGoals.dimText, tintedBy: 3.0),
            .faintText: neutral(ContrastGoals.faintText, tintedBy: 3.4),
            .ghostText: neutral(ContrastGoals.ghostText, tintedBy: 3.6),
            .whitespace: neutral(ContrastGoals.whitespace, tintedBy: 4.0),
            .indentGuide: neutral(ContrastGoals.indentGuide, tintedBy: 4.0),
            .comment: neutral(ContrastGoals.comment, tintedBy: 3.8),
            .documentation: neutral(ContrastGoals.documentation, tintedBy: 4.6),
            .punctuation: neutral(ContrastGoals.punctuation, tintedBy: 2.6),
            .operator: neutral(ContrastGoals.operatorGlyph, tintedBy: 2.4)
        ]
    }

    private func syntax() -> [PaletteName: SRGB]
    {
        [
            .keyword: ink(for: .keyword),
            .type: ink(for: .type),
            .alternateType: ink(for: .alternateType),
            .member: ink(for: .member),
            .alternateMember: ink(for: .alternateMember),
            .string: ink(for: .string),
            .number: ink(for: .number),
            .preprocessor: ink(for: .preprocessor),
            .link: ink(for: .link),
            .softKeyword: ink(
                preset.ink(for: .keyword),
                goal: ContrastGoals.softKeyword),
            .alternateString: ink(
                preset.ink(for: .string),
                goal: ContrastGoals.alternateString),
            .namespace: ink(
                preset.ink(for: .type),
                goal: ContrastGoals.namespace),
            .label: ink(
                preset.ink(for: .preprocessor),
                goal: ContrastGoals.label)
        ]
    }

    private func statuses() -> [PaletteName: SRGB]
    {
        [
            .error: ink(.red, goal: ContrastGoals.error),
            .warning: ink(.orange, goal: ContrastGoals.warning),
            .information: ink(.blue, goal: ContrastGoals.information),
            .hint: ink(.teal, goal: ContrastGoals.hint),
            .addition: ink(.green, goal: ContrastGoals.addition),
            .removal: ink(.red, goal: ContrastGoals.removal),
            .modification: ink(.blue, goal: ContrastGoals.modification)
        ]
    }

    private func furniture() -> [PaletteName: SRGB]
    {
        let base = InterfaceColours.selection(in: appearance)
        let dark = appearance == .dark
        return [
            .selection: blend(base, by: dark ? 0.34 : 0.22),
            .dimSelection: blend(base, by: dark ? 0.62 : 0.55),
            .matchingBracket: blend(base, by: dark ? 0.30 : 0.18),
            .cursor: caret(),
            .searchHighlight: blend(
                systemColours.colour(.yellow, in: appearance),
                by: dark ? 0.72 : 0.62),
            .jumpLabel: ink(
                .pink,
                goal: ContrastGoal(ContrastGoals.jumpLabel, chromaFactor: 1)),
            .modeNormal: ink(
                preset.ink(for: .keyword),
                goal: ContrastGoal(ContrastGoals.modeNormal, chromaFactor: 1)),
            .modeInsert: ink(
                .green,
                goal: ContrastGoal(ContrastGoals.modeAccent, chromaFactor: 1)),
            .modeSelect: ink(
                .indigo,
                goal: ContrastGoal(ContrastGoals.modeAccent, chromaFactor: 1)),
            .debugger: ink(
                .green,
                goal: ContrastGoal(ContrastGoals.debugger, chromaFactor: 1)),
            .breakpoint: ink(
                .blue,
                goal: ContrastGoal(
                    ContrastGoals.breakpoint,
                    chromaFactor: 0.9)),
            .modificationBackground: ColourBlend.of(
                ink(.blue, goal: ContrastGoals.modification),
                towards: ground,
                by: 0.87)
        ]
    }

    private func surface(
        steppedBy step: Double,
        tintedBy factor: Double) -> SRGB
    {
        let direction = appearance == .dark ? step : -step
        return OKLCh(
            lightness: groundLightness.adjusted(by: direction),
            chroma: tint.scaled(by: factor),
            hue: preset.tintHue).srgb
    }

    private func neutral(
        _ target: ContrastRatio,
        tintedBy factor: Double) -> SRGB
    {
        let chroma = tint
            .scaled(by: factor)
            .capped(at: GroundLightness.tintCeiling(for: appearance))
        let lightness = solver.lightnessReaching(
            target,
            hue: preset.tintHue,
            chroma: chroma)
        return OKLCh(
            lightness: lightness,
            chroma: chroma,
            hue: preset.tintHue).srgb
    }

    private func ink(for slot: InkSlot) -> SRGB
    {
        ink(preset.ink(for: slot), goal: preset.goal(for: slot))
    }

    private func ink(_ colour: SystemColour, goal: ContrastGoal) -> SRGB
    {
        let source = OKLCh(systemColours.colour(colour, in: appearance))
        let chroma = source.chroma.scaled(
            by: goal.chromaFactor * MutedInks.boost(for: colour))
        let lightness = solver.lightnessReaching(
            goal.target,
            hue: source.hue,
            chroma: chroma)
        return OKLCh(lightness: lightness, chroma: chroma, hue: source.hue).srgb
    }

    private func blend(_ colour: SRGB, by fraction: Double) -> SRGB
    {
        ColourBlend.of(colour, towards: ground, by: fraction)
    }

    private func caret() -> SRGB
    {
        guard appearance == .dark else
        {
            return InterfaceColours.accent
        }
        let accent = OKLCh(InterfaceColours.accent)
        return accent
            .withLightness(accent.lightness.adjusted(by: 0.10))
            .srgb
    }
}

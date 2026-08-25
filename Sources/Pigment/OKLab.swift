import Foundation

struct OKLab: Hashable, Sendable
{
    package let lightness: Double
    let a: Double
    let b: Double

    init(lightness: Double, a: Double, b: Double)
    {
        self.lightness = lightness
        self.a = a
        self.b = b
    }

    init(_ colour: SRGB)
    {
        let linear = LinearRGB(colour)
        let long = Self.cubeRoot(
            0.4122214708 * linear.red
                + 0.5363325363 * linear.green
                + 0.0514459929 * linear.blue)
        let medium = Self.cubeRoot(
            0.2119034982 * linear.red
                + 0.6806995451 * linear.green
                + 0.1073969566 * linear.blue)
        let short = Self.cubeRoot(
            0.0883024619 * linear.red
                + 0.2817188376 * linear.green
                + 0.6299787005 * linear.blue)
        self.init(
            lightness: 0.2104542553 * long
                + 0.7936177850 * medium
                - 0.0040720468 * short,
            a: 1.9779984951 * long
                - 2.4285922050 * medium
                + 0.4505937099 * short,
            b: 0.0259040371 * long
                + 0.7827717662 * medium
                - 0.8086757660 * short)
    }

    package var srgb: SRGB
    {
        let long = pow(lightness + 0.3963377774 * a + 0.2158037573 * b, 3)
        let medium = pow(lightness - 0.1055613458 * a - 0.0638541728 * b, 3)
        let short = pow(lightness - 0.0894841775 * a - 1.2914855480 * b, 3)
        return LinearRGB(
            red: 4.0767416621 * long
                - 3.3077115913 * medium
                + 0.2309699292 * short,
            green: -1.2684380046 * long
                + 2.6097574011 * medium
                - 0.3413193965 * short,
            blue: -0.0041960863 * long
                - 0.7034186147 * medium
                + 1.7076147010 * short).encoded
    }

    func blended(towards other: OKLab, by fraction: Double) -> OKLab
    {
        OKLab(
            lightness: lightness + (other.lightness - lightness) * fraction,
            a: a + (other.a - a) * fraction,
            b: b + (other.b - b) * fraction)
    }

    @inlinable
    static func cubeRoot(_ value: Double) -> Double
    {
        value < 0 ? -pow(-value, 1.0 / 3.0) : pow(value, 1.0 / 3.0)
    }
}

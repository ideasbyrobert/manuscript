import Foundation

package struct Hue: Hashable, Sendable
{
    let degrees: Double

    package init(degrees: Double)
    {
        let wrapped = degrees.truncatingRemainder(dividingBy: 360)
        self.degrees = wrapped < 0 ? wrapped + 360 : wrapped
    }

    var radians: Double
    {
        degrees * .pi / 180
    }

    func separation(from other: Hue) -> Double
    {
        let gap = abs(degrees - other.degrees)
        return min(gap, 360 - gap)
    }
}

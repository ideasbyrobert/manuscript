struct Violation
{
    let location: String
    let line: Int
    let rule: String
    let detail: String

    var report: String
    {
        let place = "\(location):\(line)"
        let padded = place.padding(
            toLength: max(place.count, 44),
            withPad: " ",
            startingAt: 0)
        return "\(padded) \(rule)  \(detail)"
    }
}

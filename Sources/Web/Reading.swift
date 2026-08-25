package struct Reading: Codable, Hashable, Sendable
{
    package let blocks: Int
    package let grounded: Int
    package let ungrounded: Int
    package let spans: Int
    package let under: Int
    package let worst: Double
    package let collateral: Int
    package let orphan: Int
    package let siteDark: Bool
    package let weDark: Bool
}

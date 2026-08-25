public enum ColourBlend
{
    public static func of(
        _ one: SRGB,
        towards other: SRGB,
        by fraction: Double) -> SRGB
    {
        OKLab(one).blended(towards: OKLab(other), by: fraction).srgb.clipped
    }
}

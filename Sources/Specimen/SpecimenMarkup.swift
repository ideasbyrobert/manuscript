import ThemeDomain

package enum SpecimenMarkup
{
    package static func tokens(in line: String) -> [SpecimenToken]
    {
        var found: [SpecimenToken] = []
        var plain = ""
        var index = line.startIndex
        while index < line.endIndex
        {
            guard line[index] == "{",
                  let bar = line[index...].firstIndex(of: "|"),
                  let close = line[bar...].firstIndex(of: "}") else
            {
                plain.append(line[index])
                index = line.index(after: index)
                continue
            }
            if !plain.isEmpty
            {
                found.append(SpecimenToken(plain, role: nil))
                plain = ""
            }
            let opening = line.index(after: index)
            let named = String(line[opening ..< bar])
            let role = PaletteName(rawValue: named)
            precondition(role != nil, "unknown role \(named)")
            found.append(SpecimenToken(
                String(line[line.index(after: bar) ..< close]),
                role: role))
            index = line.index(after: close)
        }
        if !plain.isEmpty
        {
            found.append(SpecimenToken(plain, role: nil))
        }
        return found
    }
}

package struct Declaration: Sendable
{
    let property: String
    let value: String
    let isImportant: Bool

    package init(
        _ property: String,
        _ value: String,
        isImportant: Bool = false)
    {
        self.property = property
        self.value = value
        self.isImportant = isImportant
    }

    var important: Declaration
    {
        Declaration(property, value, isImportant: true)
    }

    var text: String
    {
        let mark = isImportant ? " !important" : ""
        return "\(property): \(value)\(mark);"
    }
}

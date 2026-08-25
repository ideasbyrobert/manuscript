package struct Declaration: Sendable, Equatable
{
    package let property: String
    package let value: String
    package let isImportant: Bool

    package init(
        _ property: String,
        _ value: String,
        isImportant: Bool = false)
    {
        self.property = property
        self.value = value
        self.isImportant = isImportant
    }

    package var important: Declaration
    {
        Declaration(property, value, isImportant: true)
    }

    package var text: String
    {
        let mark = isImportant ? " !important" : ""
        return "\(property): \(value)\(mark);"
    }
}

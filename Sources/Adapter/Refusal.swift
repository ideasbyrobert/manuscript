package struct Refusal: Error, Hashable, Sendable
{
    package let command: String
    package let message: String

    package init(command: String, message: String)
    {
        self.command = command
        self.message = message
    }
}

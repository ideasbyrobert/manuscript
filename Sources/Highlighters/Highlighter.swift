import Cascade

package struct Highlighter: Sendable
{
    let name: String
    package let containers: [String]
    package let bindings: [TokenBinding]
    package let resets: [Rule]

    package init(
        name: String,
        containers: [String],
        bindings: [TokenBinding],
        resets: [Rule] = [])
    {
        self.name = name
        self.containers = containers
        self.bindings = bindings
        self.resets = resets
    }
}

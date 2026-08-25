import Foundation

package enum Container
{
    package static var facts: [String: String]
    {
        let environment = ProcessInfo.processInfo.environment
        let home = NSHomeDirectory()
        let contained = home.contains("/Library/Containers/")
        return [
            "HOME": environment["HOME"] ?? "",
            "TMPDIR": environment["TMPDIR"] ?? "",
            "APP_SANDBOX_CONTAINER_ID":
                environment["APP_SANDBOX_CONTAINER_ID"] ?? "",
            "home": home,
            "bundle": Bundle.main.bundleIdentifier ?? "",
            "contained": contained ? "true" : "false"
        ]
    }
}

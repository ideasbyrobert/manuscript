import Foundation
import WebKit

package enum Configuration
{
    package static let safari = "Version/18.6 Safari/605.1.15"

    @MainActor
    package static var world: WKContentWorld
    {
        WKContentWorld.world(name: "ManuscriptPrivate")
    }

    @MainActor
    package static func make() -> WKWebViewConfiguration
    {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        configuration.preferences.inactiveSchedulingPolicy = .none
        configuration.applicationNameForUserAgent = safari
        return configuration
    }

    @MainActor
    package static func view(_ configuration: WKWebViewConfiguration)
        -> WKWebView
    {
        WKWebView(
            frame: .init(x: 0, y: 0, width: 640, height: 480),
            configuration: configuration)
    }
}

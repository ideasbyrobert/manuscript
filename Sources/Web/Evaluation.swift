import Foundation
import WebKit

package enum Evaluation
{
    @MainActor
    package static func text(
        _ script: String,
        in web: WKWebView,
        world: WKContentWorld) async throws -> String
    {
        let value = try await web.evaluateJavaScript(
            script,
            in: nil,
            contentWorld: world)
        guard let text = value as? String else
        {
            throw WebError.notText
        }
        return text
    }

    @MainActor
    package static func read<T: Decodable>(
        _ type: T.Type,
        _ script: String,
        in web: WKWebView,
        world: WKContentWorld) async throws -> T
    {
        let carried = try await text(script, in: web, world: world)
        return try JSONDecoder().decode(T.self, from: Data(carried.utf8))
    }
}

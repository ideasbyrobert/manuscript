import WebKit

@MainActor
final class Hang: NSObject, WKURLSchemeHandler
{
    func webView(_ web: WKWebView, start task: any WKURLSchemeTask)
    {
    }

    func webView(_ web: WKWebView, stop task: any WKURLSchemeTask)
    {
    }
}

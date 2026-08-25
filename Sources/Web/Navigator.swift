import Foundation
import Gate
import WebKit

@MainActor
package final class Navigator: NSObject, WKNavigationDelegate
{
    private struct Pending
    {
        let resume: CheckedContinuation<Void, any Error>
        let watchdog: Task<Void, Never>
    }

    package let world = Configuration.world
    private var fence = Fence<URL>()
    private var waiting: [ObjectIdentifier: Pending] = [:]
    package private(set) var document: Fence<URL>.Ticket?

    package override init()
    {
        super.init()
    }

    package func load(
        _ url: URL,
        in web: WKWebView,
        within limit: Duration = .seconds(12)) async throws
    {
        try await run(fence.begin(for: url), within: limit, in: web)
        {
            web.load(URLRequest(url: url))
        }
    }

    package func load(
        html: String,
        base: URL?,
        in web: WKWebView,
        within limit: Duration = .seconds(12)) async throws
    {
        let subject = base ?? URL(string: "about:blank")!
        try await run(fence.begin(for: subject), within: limit, in: web)
        {
            web.loadHTMLString(html, baseURL: base)
        }
    }

    private func run(
        _ ticket: Fence<URL>.Ticket,
        within limit: Duration,
        in web: WKWebView,
        _ start: () -> WKNavigation?) async throws
    {
        guard let navigation = start() else
        {
            throw WebError.failed(code: 0)
        }
        let key = ObjectIdentifier(navigation)
        do
        {
            try await withTaskCancellationHandler
            {
                try await withCheckedThrowingContinuation
                {
                    (resume: CheckedContinuation<Void, any Error>) in
                    let watchdog = Task
                    {
                        try? await Task.sleep(for: limit)
                        self.timeout(key, in: web)
                    }
                    waiting[key] = Pending(resume: resume, watchdog: watchdog)
                }
            }
            onCancel:
            {
                Task
                {
                    await self.abandon(key)
                }
            }
        }
        catch
        {
            guard fence.accepts(ticket) else
            {
                throw WebError.superseded
            }
            throw error
        }
        guard fence.accepts(ticket) else
        {
            throw WebError.superseded
        }
        document = ticket
    }

    private func resolve(_ key: ObjectIdentifier, throwing error: (any Error)?)
    {
        guard let pending = waiting.removeValue(forKey: key) else
        {
            return
        }
        pending.watchdog.cancel()
        if let error
        {
            pending.resume.resume(throwing: error)
        }
        else
        {
            pending.resume.resume()
        }
    }

    private func timeout(_ key: ObjectIdentifier, in web: WKWebView)
    {
        guard waiting[key] != nil else
        {
            return
        }
        web.stopLoading()
        resolve(key, throwing: WebError.timedOut)
    }

    private func abandon(_ key: ObjectIdentifier)
    {
        resolve(key, throwing: CancellationError())
    }

    package func webView(
        _ web: WKWebView,
        didFinish navigation: WKNavigation!)
    {
        resolve(ObjectIdentifier(navigation), throwing: nil)
    }

    package func webView(
        _ web: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: any Error)
    {
        let number = error as NSError
        resolve(
            ObjectIdentifier(navigation),
            throwing: WebError.failed(code: number.code))
    }

    package func webView(
        _ web: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: any Error)
    {
        let number = error as NSError
        resolve(
            ObjectIdentifier(navigation),
            throwing: WebError.failed(code: number.code))
    }
}

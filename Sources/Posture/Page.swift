import Foundation
import WebKit

@MainActor
package final class Page: NSObject, WKNavigationDelegate
{
    private var waiter: CheckedContinuation<Verdict, Never>?
    private var settled = false
    private var seenStatus: Int?
    private var keep: Page?

    package static func measure(
        _ address: String,
        within limit: Duration) async -> [Verdict]
    {
        let page = Page()
        return await page.run(address, within: limit)
    }

    private func run(
        _ address: String,
        within limit: Duration) async -> [Verdict]
    {
        var verdicts = [await rules("rules-tmp", store(temporary: true))]
        verdicts.append(await rules("rules-default", store(temporary: false)))
        guard let url = URL(string: address) else
        {
            return verdicts + [Verdict("load", .failed, message: "bad url")]
        }
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        configuration.preferences.inactiveSchedulingPolicy = .none
        let view = WKWebView(
            frame: .init(x: 0, y: 0, width: 320, height: 240),
            configuration: configuration)
        view.navigationDelegate = self
        keep = self
        let load = await withCheckedContinuation
        {
            (continuation: CheckedContinuation<Verdict, Never>) in
            waiter = continuation
            Task
            {
                try? await Task.sleep(for: limit)
                self.finish(Verdict("load", .hung))
            }
            view.load(URLRequest(url: url))
        }
        keep = nil
        verdicts.append(load)
        guard load.answer == .permitted else
        {
            return verdicts
        }
        let world = WKContentWorld.world(name: "manuscript")
        do
        {
            let value = try await view.evaluateJavaScript(
                "document.readyState",
                in: nil,
                contentWorld: world)
            let text = value as? String ?? ""
            verdicts.append(Verdict(
                "world",
                text.isEmpty ? .failed : .permitted,
                message: text))
        }
        catch let error as NSError
        {
            verdicts.append(Verdict(
                "world",
                .failed,
                code: error.code,
                domain: error.domain))
        }
        return verdicts
    }

    private func store(temporary: Bool) -> WKContentRuleListStore?
    {
        guard temporary else
        {
            return WKContentRuleListStore.default()
        }
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("manuscript-rules-" + UUID().uuidString)
        try? FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true)
        return WKContentRuleListStore(url: directory)
    }

    private func rules(_ stage: String, _ store: WKContentRuleListStore?)
        async -> Verdict
    {
        guard let store else
        {
            return Verdict(stage, .failed, message: "no store")
        }
        let rule =
            "[{\"trigger\":{\"url-filter\":\"never-matches\"},"
            + "\"action\":{\"type\":\"block\"}}]"
        do
        {
            _ = try await store.compileContentRuleList(
                forIdentifier: "manuscript-" + stage,
                encodedContentRuleList: rule)
            return Verdict(stage, .permitted)
        }
        catch let error as NSError
        {
            return Verdict(
                stage,
                .denied,
                code: error.code,
                domain: error.domain)
        }
    }

    private func finish(_ verdict: Verdict)
    {
        guard !settled else
        {
            return
        }
        settled = true
        waiter?.resume(returning: verdict)
        waiter = nil
    }

    package func webView(
        _ view: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse)
        async -> WKNavigationResponsePolicy
    {
        if let http = navigationResponse.response as? HTTPURLResponse
        {
            seenStatus = http.statusCode
        }
        return .allow
    }

    package func webView(
        _ view: WKWebView,
        didFinish navigation: WKNavigation!)
    {
        let code = seenStatus ?? 0
        finish(Verdict(
            "load",
            code == 200 ? .permitted : .failed,
            code: code))
    }

    package func webView(
        _ view: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: any Error)
    {
        let number = error as NSError
        finish(Verdict(
            "load",
            .denied,
            code: number.code,
            domain: number.domain))
    }

    package func webView(
        _ view: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: any Error)
    {
        let number = error as NSError
        finish(Verdict(
            "load",
            .denied,
            code: number.code,
            domain: number.domain,
            message: number.localizedDescription))
    }
}

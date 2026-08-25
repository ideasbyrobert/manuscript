import Foundation
import XPC

package enum Rendezvous
{
    private struct Ping: Codable, Sendable
    {
        let ping: Bool
    }

    private struct Pong: Codable, Sendable
    {
        let echo: Bool
    }

    package static func measure(bundleID: String?) -> [Verdict]
    {
        var verdicts = [named("global", service: "com.manuscript.not-mine")]
        verdicts.append(anonymous())
        if let bundleID
        {
            verdicts.append(named("self", service: bundleID))
        }
        return verdicts
    }

    private static func named(_ stage: String, service: String) -> Verdict
    {
        do
        {
            let listener = try XPCListener(service: service)
            {
                request in
                request.accept
                {
                    (_: Ping) -> (any Encodable)? in Pong(echo: true)
                }
            }
            _ = listener
            return Verdict(stage, .permitted)
        }
        catch let error as XPCRichError
        {
            return Verdict(stage, .denied, message: "\(error)")
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

    private static func anonymous() -> Verdict
    {
        do
        {
            let listener = try XPCListener
            {
                request in
                request.accept
                {
                    (_: Ping) -> (any Encodable)? in Pong(echo: true)
                }
            }
            let session = try XPCSession(endpoint: listener.endpoint)
            defer
            {
                session.cancel(reason: "done")
            }
            let reply: Pong = try session.sendSync(Ping(ping: true))
            return Verdict("anonymous", reply.echo ? .permitted : .failed)
        }
        catch let error as XPCRichError
        {
            return Verdict("anonymous", .failed, message: "\(error)")
        }
        catch let error as NSError
        {
            return Verdict(
                "anonymous",
                .failed,
                code: error.code,
                domain: error.domain)
        }
    }
}

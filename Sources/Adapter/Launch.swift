package enum Launch
{
    package static func run(
        on link: any Link,
        _ configuration: Configuration) async -> Outcome
    {
        do
        {
            try await ask(link, "initialize", configuration.initializeArguments)
            async let ready = link.once("initialized")
            try await ask(
                link,
                configuration.startCommand,
                configuration.startArguments)
            guard await ready != nil else
            {
                return .ended
            }
            for request in configuration.breakpointRequests
            {
                try await ask(link, "setBreakpoints", request)
            }
            try await ask(link, "setExceptionBreakpoints", ["filters": []])
            try await ask(link, "configurationDone", nil)
            return .completed
        }
        catch let refusal as Refusal
        {
            return .failed(command: refusal.command, message: refusal.message)
        }
        catch
        {
            return .ended
        }
    }

    private static func ask(
        _ link: any Link,
        _ command: String,
        _ arguments: JSON?) async throws
    {
        let response = try await link.request(command, arguments)
        if let failure = response.failure
        {
            throw Refusal(command: command, message: failure)
        }
    }
}

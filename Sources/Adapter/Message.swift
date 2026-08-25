package struct Message: Hashable, Sendable, Codable
{
    package enum Kind: String, Codable, Sendable
    {
        case request
        case response
        case event
    }

    package let seq: Int
    package let type: Kind
    package let command: String?
    package let arguments: JSON?
    package let requestSeq: Int?
    package let success: Bool?
    package let message: String?
    package let event: String?
    package let body: JSON?

    enum CodingKeys: String, CodingKey
    {
        case seq
        case type
        case command
        case arguments
        case requestSeq = "request_seq"
        case success
        case message
        case event
        case body
    }

    package static func request(
        _ seq: Int,
        _ command: String,
        _ arguments: JSON? = nil) -> Message
    {
        Message(
            seq: seq,
            type: .request,
            command: command,
            arguments: arguments,
            requestSeq: nil,
            success: nil,
            message: nil,
            event: nil,
            body: nil)
    }

    package static func response(
        _ seq: Int,
        to request: Message,
        success: Bool = true,
        body: JSON? = nil,
        message: String? = nil) -> Message
    {
        Message(
            seq: seq,
            type: .response,
            command: request.command,
            arguments: nil,
            requestSeq: request.seq,
            success: success,
            message: message,
            event: nil,
            body: body)
    }

    package static func event(
        _ seq: Int,
        _ name: String,
        body: JSON? = nil) -> Message
    {
        Message(
            seq: seq,
            type: .event,
            command: nil,
            arguments: nil,
            requestSeq: nil,
            success: nil,
            message: nil,
            event: name,
            body: body)
    }

    package var failure: String?
    {
        guard success == false else
        {
            return nil
        }
        return message ?? "(no message)"
    }
}

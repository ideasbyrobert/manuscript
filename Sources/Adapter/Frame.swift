import Foundation

package enum Frame
{
    package enum Parse: Equatable
    {
        case incomplete
        case message(Message, consumed: Int)
        case corrupt
    }

    private static let separator = Data("\r\n\r\n".utf8)
    private static let field = "content-length:"

    package static func parse(_ data: Data) -> Parse
    {
        guard let gap = data.range(of: separator) else
        {
            return data.count > 8_192 ? .corrupt : .incomplete
        }
        let head = data[data.startIndex ..< gap.lowerBound]
        guard let text = String(data: head, encoding: .utf8),
            let length = contentLength(in: text) else
        {
            return .corrupt
        }
        let end = gap.upperBound + length
        guard data.endIndex >= end else
        {
            return .incomplete
        }
        guard let message = try? JSONDecoder().decode(
            Message.self,
            from: data[gap.upperBound ..< end]) else
        {
            return .corrupt
        }
        return .message(message, consumed: end - data.startIndex)
    }

    package static func parts(of message: Message) -> (head: Data, body: Data)
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let body = try! encoder.encode(message)
        let head = Data("Content-Length: \(body.count)\r\n\r\n".utf8)
        return (head, body)
    }

    package static func encode(_ message: Message) -> Data
    {
        let (head, body) = parts(of: message)
        return head + body
    }

    private static func contentLength(in head: String) -> Int?
    {
        for line in head.components(separatedBy: "\r\n")
        {
            guard line.lowercased().hasPrefix(field) else
            {
                continue
            }
            let value = line.dropFirst(field.count)
                .trimmingCharacters(in: .whitespaces)
            guard let length = Int(value), length >= 0 else
            {
                return nil
            }
            return length
        }
        return nil
    }
}

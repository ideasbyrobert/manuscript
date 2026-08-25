import Foundation

package enum Decoding
{
    package static func text(of data: Data) -> String?
    {
        guard let text = decoded(data) else
        {
            return nil
        }
        return normalized(text)
    }

    private static func decoded(_ data: Data) -> String?
    {
        if let mark = byteOrderMark(in: data)
        {
            let payload = Data(data.dropFirst(mark.byteCount))
            guard payload.count.isMultiple(of: mark.codeUnitByteCount) else
            {
                return nil
            }
            guard let text = String(data: payload, encoding: mark.encoding),
                isPlausibleText(text) else
            {
                return nil
            }
            return text
        }

        if let text = bomlessUTF16(data)
        {
            return text
        }

        guard !isProbablyBinary(data) else
        {
            return nil
        }

        if let text = String(data: data, encoding: .utf8)
        {
            return isPlausibleText(text) ? text : nil
        }
        if let text = String(data: data, encoding: .windowsCP1252),
            isPlausibleText(text)
        {
            return text
        }
        return nil
    }

    private static func byteOrderMark(in data: Data) -> (
        byteCount: Int,
        codeUnitByteCount: Int,
        encoding: String.Encoding)?
    {
        if data.starts(with: [0x00, 0x00, 0xFE, 0xFF])
        {
            return (4, 4, .utf32BigEndian)
        }
        if data.starts(with: [0xFF, 0xFE, 0x00, 0x00])
        {
            return (4, 4, .utf32LittleEndian)
        }
        if data.starts(with: [0xEF, 0xBB, 0xBF])
        {
            return (3, 1, .utf8)
        }
        if data.starts(with: [0xFE, 0xFF])
        {
            return (2, 2, .utf16BigEndian)
        }
        if data.starts(with: [0xFF, 0xFE])
        {
            return (2, 2, .utf16LittleEndian)
        }
        return nil
    }

    private static func bomlessUTF16(_ data: Data) -> String?
    {
        guard data.count >= 4, data.count.isMultiple(of: 2) else
        {
            return nil
        }
        let sample = data.prefix(8_192)
        let pairs = sample.count / 2
        guard pairs > 0 else
        {
            return nil
        }
        var evenNulls = 0
        var oddNulls = 0
        for (offset, byte) in sample.enumerated() where byte == 0
        {
            if offset.isMultiple(of: 2)
            {
                evenNulls += 1
            }
            else
            {
                oddNulls += 1
            }
        }
        let dominant = max(2, (pairs + 2) / 3)
        let opposite = max(1, pairs / 20)
        let encoding: String.Encoding
        if oddNulls >= dominant, evenNulls <= opposite
        {
            encoding = .utf16LittleEndian
        }
        else if evenNulls >= dominant, oddNulls <= opposite
        {
            encoding = .utf16BigEndian
        }
        else
        {
            return nil
        }
        guard let text = String(data: data, encoding: encoding),
            text.data(using: encoding) == data,
            isPlausibleText(text) else
        {
            return nil
        }
        return text
    }

    private static func isPlausibleText(_ text: String) -> Bool
    {
        let scalars = text.unicodeScalars
        guard !containsDisallowedControls(text) else
        {
            return false
        }
        guard !scalars.isEmpty else
        {
            return true
        }
        let printable = CharacterSet.alphanumerics
            .union(.punctuationCharacters)
            .union(.symbols)
            .union(.whitespacesAndNewlines)
            .union(.nonBaseCharacters)
        let count = scalars.reduce(into: 0)
        {
            total, scalar in
            if printable.contains(scalar)
            {
                total += 1
            }
        }
        return count * 100 >= scalars.count * 85
    }

    private static func isProbablyBinary(_ data: Data) -> Bool
    {
        guard !data.isEmpty else
        {
            return false
        }
        if binarySignatures.contains(where: data.starts(with:))
        {
            return true
        }
        if data.dropFirst(4).starts(with: [0x66, 0x74, 0x79, 0x70])
        {
            return true
        }
        if data.contains(0)
        {
            return true
        }
        let sample = data.prefix(8_192)
        let controls = sample.reduce(into: 0)
        {
            total, byte in
            if isBinaryControlByte(byte)
            {
                total += 1
            }
        }
        return controls > 0 && controls * 20 > sample.count
    }

    private static func isBinaryControlByte(_ byte: UInt8) -> Bool
    {
        switch byte
        {
        case 0x00...0x08, 0x0B, 0x0E...0x1F, 0x7F:
            true
        default:
            false
        }
    }

    private static func containsDisallowedControls(_ text: String) -> Bool
    {
        text.unicodeScalars.contains
        {
            scalar in
            switch scalar.value
            {
            case 0x00...0x08, 0x0B, 0x0E...0x1F, 0x7F...0x9F:
                true
            default:
                false
            }
        }
    }

    private static let binarySignatures: [[UInt8]] =
    [
        [0x25, 0x50, 0x44, 0x46, 0x2D],
        [0x50, 0x4B, 0x03, 0x04],
        [0x50, 0x4B, 0x05, 0x06],
        [0x50, 0x4B, 0x07, 0x08],
        [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A],
        [0xFF, 0xD8, 0xFF],
        [0x47, 0x49, 0x46, 0x38],
        [0x49, 0x49, 0x2A, 0x00],
        [0x4D, 0x4D, 0x00, 0x2A],
        [0xD0, 0xCF, 0x11, 0xE0],
        [0x1F, 0x8B],
        [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C],
        [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07],
        [0xFE, 0xED, 0xFA, 0xCE],
        [0xCE, 0xFA, 0xED, 0xFE],
        [0xFE, 0xED, 0xFA, 0xCF],
        [0xCF, 0xFA, 0xED, 0xFE],
        [0xCA, 0xFE, 0xBA, 0xBE]
    ]

    private static func normalized(_ text: String) -> String
    {
        var result = text
        if result.hasPrefix("\u{feff}")
        {
            result.removeFirst()
        }
        return result
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
    }
}

package indirect enum JSON: Hashable, Sendable, Codable
{
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([JSON])
    case object([String: JSON])

    package init(from decoder: any Decoder) throws
    {
        let single = try decoder.singleValueContainer()
        if single.decodeNil()
        {
            self = .null
        }
        else if let flag = try? single.decode(Bool.self)
        {
            self = .bool(flag)
        }
        else if let number = try? single.decode(Double.self)
        {
            self = .number(number)
        }
        else if let text = try? single.decode(String.self)
        {
            self = .string(text)
        }
        else if let items = try? single.decode([JSON].self)
        {
            self = .array(items)
        }
        else
        {
            self = .object(try single.decode([String: JSON].self))
        }
    }

    package func encode(to encoder: any Encoder) throws
    {
        var single = encoder.singleValueContainer()
        switch self
        {
        case .null: try single.encodeNil()
        case .bool(let flag): try single.encode(flag)
        case .number(let number): try single.encode(number)
        case .string(let text): try single.encode(text)
        case .array(let items): try single.encode(items)
        case .object(let members): try single.encode(members)
        }
    }

    package subscript(key: String) -> JSON?
    {
        guard case .object(let members) = self else
        {
            return nil
        }
        return members[key]
    }

    package var string: String?
    {
        guard case .string(let text) = self else
        {
            return nil
        }
        return text
    }

    package var int: Int?
    {
        guard case .number(let number) = self else
        {
            return nil
        }
        return Int(exactly: number)
    }

    package var bool: Bool?
    {
        guard case .bool(let flag) = self else
        {
            return nil
        }
        return flag
    }

    package var array: [JSON]?
    {
        guard case .array(let items) = self else
        {
            return nil
        }
        return items
    }
}

extension JSON: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral, ExpressibleByBooleanLiteral,
    ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral,
    ExpressibleByNilLiteral
{
    package init(stringLiteral value: String)
    {
        self = .string(value)
    }

    package init(integerLiteral value: Int)
    {
        self = .number(Double(value))
    }

    package init(floatLiteral value: Double)
    {
        self = .number(value)
    }

    package init(booleanLiteral value: Bool)
    {
        self = .bool(value)
    }

    package init(arrayLiteral elements: JSON...)
    {
        self = .array(elements)
    }

    package init(dictionaryLiteral elements: (String, JSON)...)
    {
        self = .object(Dictionary(uniqueKeysWithValues: elements))
    }

    package init(nilLiteral: ())
    {
        self = .null
    }
}

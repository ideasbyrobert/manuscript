package struct Verdict: Codable, Hashable, Sendable
{
    package enum Answer: String, Codable, Sendable
    {
        case permitted
        case denied
        case failed
        case hung
    }

    package let stage: String
    package let answer: Answer
    package let errno: Int32?
    package let code: Int?
    package let domain: String?
    package let message: String?

    package init(
        _ stage: String,
        _ answer: Answer,
        errno: Int32? = nil,
        code: Int? = nil,
        domain: String? = nil,
        message: String? = nil)
    {
        self.stage = stage
        self.answer = answer
        self.errno = errno
        self.code = code
        self.domain = domain
        self.message = message
    }
}

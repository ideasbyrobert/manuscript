import Testing

@testable import Highlighters
@testable import ThemeDomain

@Suite("Selectors bound to a role")
struct TokenBindingTests
{
    @Test("selectors keep their order and the role is kept")
    func keepsOrderAndRole()
    {
        let binding = TokenBinding([".s", ".s1", ".s2"], .string, .italic)
        #expect(binding.selectors == [".s", ".s1", ".s2"])
        #expect(binding.role == .string)
        #expect(binding.emphasis == .italic)
    }

    @Test("emphasis is none unless stated")
    func emphasisDefaults()
    {
        #expect(TokenBinding([".n"], .number).emphasis == .none)
    }
}

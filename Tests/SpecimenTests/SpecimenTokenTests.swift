import Testing

@testable import Specimen
@testable import ThemeDomain

@Suite("A run of text and the role it is drawn in")
struct SpecimenTokenTests
{
    @Test("two tokens are equal only in text and role together")
    func equality()
    {
        let plain = SpecimenToken("x", role: nil)
        #expect(plain == SpecimenToken("x", role: nil))
        #expect(plain != SpecimenToken("x", role: .member))
        #expect(plain != SpecimenToken("y", role: nil))
    }

    @Test("a plain token has no role")
    func plainHasNoRole()
    {
        #expect(SpecimenToken("x", role: nil).role == nil)
        #expect(SpecimenToken("x", role: .keyword).role == .keyword)
    }
}

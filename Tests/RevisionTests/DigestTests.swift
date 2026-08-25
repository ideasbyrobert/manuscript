import Foundation
import Testing

@testable import Revision

@Suite("SHA-256, in lowercase hex")
struct DigestTests
{
    @Test("the known digests of nothing and of abc")
    func knownAnswers()
    {
        let empty = "e3b0c44298fc1c149afbf4c8996fb924"
            + "27ae41e4649b934ca495991b7852b855"
        let abc = "ba7816bf8f01cfea414140de5dae2223"
            + "b00361a396177a9cb410ff61f20015ad"
        #expect(Digest(of: Data()).hex == empty)
        #expect(Digest(of: Data("abc".utf8)).hex == abc)
    }

    @Test("streaming a file larger than one piece equals hashing it whole")
    func streamedEqualsWhole() throws
    {
        let scratch = try Scratch()
        defer
        {
            scratch.remove()
        }
        let text = String(repeating: "manuscript ", count: 20_000)
        let url = try scratch.file("large.txt", holding: text)
        #expect(text.utf8.count > 2 * 64 * 1_024)
        let streamed = try Digest.of(contentsOf: url)
        #expect(streamed == Digest(of: Data(text.utf8)))
        #expect(streamed.hex.count == 64)
    }
}

import Foundation
import Testing

@testable import Web

@Suite("The ways a load can end badly")
struct WebErrorTests
{
    @Test("the cases are distinct, and carry what they name")
    func distinct()
    {
        let url = URL(string: "https://x/")!
        let all: Set<WebError> =
        [
            .superseded, .timedOut, .failed(code: -1),
            .failed(code: -2), .refused(url), .notText
        ]
        #expect(all.count == 6)
        #expect(WebError.failed(code: -1) != .failed(code: -2))
        #expect(WebError.refused(url) == .refused(url))
    }
}

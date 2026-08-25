import Foundation

package enum WebError: Error, Hashable, Sendable
{
    case superseded
    case timedOut
    case failed(code: Int)
    case refused(URL)
    case notText
}

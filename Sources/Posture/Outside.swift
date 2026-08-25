import Darwin
import Foundation

package enum Outside
{
    package static func measure(_ paths: [String: String]) -> [Verdict]
    {
        paths.keys.sorted().map { stage in read(stage, paths[stage]!) }
    }

    private static func read(_ stage: String, _ path: String) -> Verdict
    {
        let descriptor = open(path, O_RDONLY)
        guard descriptor >= 0 else
        {
            let number = errno
            let denied = number == EPERM || number == EACCES
            return Verdict(
                stage,
                denied ? .denied : .failed,
                errno: number,
                message: String(cString: strerror(number)))
        }
        defer
        {
            close(descriptor)
        }
        var buffer = [UInt8](repeating: 0, count: 16)
        guard Darwin.read(descriptor, &buffer, buffer.count) >= 0 else
        {
            let number = errno
            return Verdict(
                stage,
                .failed,
                errno: number,
                message: String(cString: strerror(number)))
        }
        return Verdict(stage, .permitted)
    }
}

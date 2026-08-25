import Foundation
import Testing

@testable import Decoding

@Suite("Bytes become text, or are refused at the door")
struct DecodingTests
{
    @Test("a UTF-8 mark is stripped and carriage returns are normalised")
    func utf8BomStrippedNewlinesNormalised()
    {
        var bytes: [UInt8] = [0xEF, 0xBB, 0xBF]
        bytes.append(contentsOf: Array("a\r\nb\rc".utf8))
        #expect(Decoding.text(of: Data(bytes)) == "a\nb\nc")
    }

    @Test("a little-endian UTF-16 mark decodes")
    func utf16LittleEndianWithMark()
    {
        let data = Data([0xFF, 0xFE, 0x41, 0x00, 0xA7, 0x00])
        #expect(Decoding.text(of: data) == "A§")
    }

    @Test("a big-endian UTF-16 mark decodes")
    func utf16BigEndianWithMark()
    {
        let data = Data([0xFE, 0xFF, 0x00, 0x41, 0x00, 0xA7])
        #expect(Decoding.text(of: data) == "A§")
    }

    @Test("UTF-16 little endian is recognised by its null pattern")
    func bomlessUTF16LittleEndian()
    {
        let data = Data([
            0x41, 0x00, 0xA7, 0x00, 0x0D, 0x00, 0x0A, 0x00, 0x42, 0x00])
        #expect(Decoding.text(of: data) == "A§\nB")
    }

    @Test("UTF-16 big endian is recognised by its null pattern")
    func bomlessUTF16BigEndian()
    {
        let data = Data([
            0x00, 0x41, 0x00, 0xA7, 0x00, 0x0A, 0x00, 0x42])
        #expect(Decoding.text(of: data) == "A§\nB")
    }

    @Test("UTF-32 little endian begins like UTF-16 and is read first")
    func utf32LittleEndianBeforeUTF16()
    {
        let data = Data([
            0xFF, 0xFE, 0x00, 0x00,
            0x41, 0x00, 0x00, 0x00,
            0xA7, 0x00, 0x00, 0x00])
        #expect(Decoding.text(of: data) == "A§")
    }

    @Test("a big-endian UTF-32 mark decodes")
    func utf32BigEndianWithMark()
    {
        let data = Data([
            0x00, 0x00, 0xFE, 0xFF,
            0x00, 0x00, 0x00, 0x41,
            0x00, 0x00, 0x00, 0xA7])
        #expect(Decoding.text(of: data) == "A§")
    }

    @Test("a mark on a malformed payload refuses rather than guessing")
    func malformedMarkDoesNotFallThrough()
    {
        #expect(Decoding.text(of: Data([0xFF, 0xFE, 0x41])) == nil)
    }

    @Test("a UTF-8 mark does not exempt a binary control byte")
    func utf8MarkDoesNotExemptControls()
    {
        let data = Data([0xEF, 0xBB, 0xBF, 0x41, 0x00, 0x42])
        #expect(Decoding.text(of: data) == nil)
    }

    @Test("a UTF-16 mark does not exempt a binary control byte")
    func utf16MarkDoesNotExemptControls()
    {
        let data = Data([
            0xFF, 0xFE, 0x41, 0x00, 0x01, 0x00, 0x42, 0x00])
        #expect(Decoding.text(of: data) == nil)
    }

    @Test("Windows-1252 renders its legal high bytes")
    func windowsCP1252Legal()
    {
        let data = Data([
            0xA7, 0x20, 0x31, 0x30, 0x31, 0x2C, 0x20,
            0xB6, 0x20, 0x93, 0x71, 0x94])
        #expect(Decoding.text(of: data) == "§ 101, ¶ “q”")
    }

    @Test("valid UTF-8 never falls through to a permissive legacy fallback")
    func validUTF8NeverFallsToCP1252()
    {
        let data = Data("café §".utf8)
        #expect(Decoding.text(of: data) == "café §")
    }

    @Test("a control character encoded in valid UTF-8 is still refused")
    func utf8ControlIsRejected()
    {
        let data = Data("before\u{0085}after".utf8)
        #expect(Decoding.text(of: data) == nil)
    }

    @Test("a lone surrogate byte with nulls is not text")
    func undecodableBinaryIsNil()
    {
        #expect(Decoding.text(of: Data([0xD8, 0x00, 0x00])) == nil)
    }

    @Test("an ASCII PDF header is a container, not legacy text")
    func asciiPDFIsNotText()
    {
        let data = Data("%PDF-1.7\n1 0 obj\n<<>>\nendobj\n".utf8)
        #expect(Decoding.text(of: data) == nil)
    }

    @Test("a container carrying ftyp at offset four is refused")
    func ftypContainerIsRefused()
    {
        var bytes: [UInt8] = [0x00, 0x00, 0x00, 0x18]
        bytes.append(contentsOf: [0x66, 0x74, 0x79, 0x70])
        bytes.append(contentsOf: Array("heic and more text here".utf8))
        #expect(Decoding.text(of: Data(bytes)) == nil)
    }

    @Test("a ZIP container is not legacy text")
    func zipContainerIsNotText()
    {
        let data = Data([
            0x50, 0x4B, 0x03, 0x04,
            0x14, 0x00, 0x00, 0x00,
            0x41, 0x42, 0x43, 0x44])
        #expect(Decoding.text(of: data) == nil)
    }

    @Test("a dense run of control bytes is refused")
    func controlDensityIsRejected()
    {
        let data = Data([
            0x01, 0x02, 0x03, 0x04, 0x41, 0x42, 0x43, 0x44])
        #expect(Decoding.text(of: data) == nil)
    }

    @Test("alternating control bytes are not accepted as UTF-16")
    func alternatingControlsAreNotUTF16()
    {
        let data = Data([
            0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x04, 0x00])
        #expect(Decoding.text(of: data) == nil)
    }
}

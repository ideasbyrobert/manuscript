import AppKit
import Foundation
import ThemeDomain
import UserSheet
import Web

let application = NSApplication.shared
application.setActivationPolicy(.regular)
let arguments = CommandLine.arguments
let pairs = ThemePair.all(in: Theme.catalogue())
let pair = pairs.first { $0.name == "ember" } ?? pairs[0]
let surface = Surface(css: AuthorSheet.text(for: pair))
surface.show()

func write(_ image: NSImage, to path: String)
{
    guard let data = image.tiffRepresentation,
        let rep = NSBitmapImageRep(data: data),
        let png = rep.representation(using: .png, properties: [:]) else
    {
        exit(1)
    }
    try? png.write(to: URL(fileURLWithPath: path))
}

if arguments.count == 3, arguments[1] == "--snapshot"
{
    Task
    {
        try? await surface.present(
            html: Fixture.page,
            base: URL(string: "https://manuscript.test/"))
        try? await Task.sleep(for: .milliseconds(300))
        if let image = try? await surface.snapshot()
        {
            write(image, to: arguments[2])
        }
        exit(0)
    }
}
else
{
    Task
    {
        if arguments.count == 2, let url = URL(string: arguments[1])
        {
            try? await surface.present(url)
        }
        else
        {
            try? await surface.present(
                html: Fixture.page,
                base: URL(string: "https://manuscript.test/"))
        }
    }
}
application.run()

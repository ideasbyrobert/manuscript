import Foundation

package enum Corpus
{
    package struct Page: Sendable
    {
        package let url: URL
        package let family: String
        package let covers: Bool

        package init(_ address: String, _ family: String, covers: Bool)
        {
            url = URL(string: address)!
            self.family = family
            self.covers = covers
        }
    }

    package static let pages: [Page] =
    [
        Page(
            "https://docs.python.org/3/tutorial/introduction.html",
            "pygments",
            covers: true),
        Page(
            "https://gohugo.io/getting-started/quick-start/",
            "chroma",
            covers: true),
        Page(
            "https://prismjs.com/",
            "prism",
            covers: true),
        Page(
            "https://vitepress.dev/guide/what-is-vitepress",
            "shiki",
            covers: false)
    ]
}

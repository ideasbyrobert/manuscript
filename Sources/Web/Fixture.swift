package enum Fixture
{
    package static let page =
    [
        "<!DOCTYPE html>",
        "<html><head><meta charset=\"utf-8\"><title>fixture</title>",
        "<style>",
        "#page .highlight pre",
        "{ background-color: rgb(9, 9, 9) !important; }",
        "</style>",
        "</head><body>",
        "<div class=\"highlight\"><pre id=\"grounded\"><code>",
        "<span class=\"k\">let</span> <span class=\"n\">name</span>",
        "</code></pre></div>",
        "<div id=\"page\"><div class=\"highlight\"><pre id=\"contested\">",
        "<code><span class=\"k\">let</span></code></pre></div></div>",
        "<div class=\"highlight\"><pre id=\"inline\"",
        " style=\"background-color: rgb(1, 2, 3) !important\"><code>",
        "<span class=\"k\">let</span></code></pre></div>",
        "</body></html>"
    ]
    .joined(separator: "\n")

    package static let filled =
    [
        "<!DOCTYPE html><html><head><meta charset=\"utf-8\">",
        "<style>html,body{margin:0;height:100%}",
        ".highlight,.highlight pre{margin:0;height:100%}</style>",
        "</head><body>",
        "<div class=\"highlight\"><pre><code>",
        "<span class=\"k\">let</span> x</code></pre></div>",
        "</body></html>"
    ]
    .joined(separator: "\n")
}

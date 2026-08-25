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
}

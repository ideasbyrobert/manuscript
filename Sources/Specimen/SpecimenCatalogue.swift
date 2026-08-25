import Pigment
import ThemeDomain

package enum SpecimenCatalogue
{
    package static func page(for themes: [Theme]) -> String
    {
        [
            "<style>",
            ":root\n{\n"
                + SpecimenPage.variables(
                    for: themes.first ?? Theme.catalogue()[0])
                + "\n}",
            layout(),
            SpecimenPage.roleClasses(),
            themes.map(scope).joined(separator: "\n"),
            "</style>",
            body(for: themes),
            script(for: themes)
        ].joined(separator: "\n")
    }

    package static func scope(_ theme: Theme) -> String
    {
        "[data-theme=\"\(theme.identifier)\"]\n{\n"
            + SpecimenPage.variables(for: theme)
            + "\n}"
    }

    package static func readings(for themes: [Theme]) -> String
    {
        let entries = themes.map
        {
            theme -> String in
            let roles = PaletteName.allCases.map
            {
                name -> String in
                let found = Readability.between(
                    theme.palette[name],
                    theme.palette[.background]).magnitude
                return "\"\(name.rawValue)\":\((found * 10).rounded() / 10)"
            }
            return "\"\(theme.identifier)\":{\(roles.joined(separator: ","))}"
        }
        return "{\(entries.joined(separator: ","))}"
    }

    package static func swatches() -> String
    {
        PaletteName.allCases.map
        {
            "<button class=\"swatch\" data-role=\"\($0.rawValue)\">"
                + "<span class=\"chip\" style=\"background:"
                + "var(--\($0.rawValue))\"></span>"
                + "<span class=\"who\">\($0.rawValue)</span>"
                + "<span class=\"hex\"></span></button>"
        }
        .joined(separator: "\n")
    }

    package static func layout() -> String
    {
        [
            "* { box-sizing: border-box; }",
            "body { margin: 0; background: var(--background);",
            "color: var(--text); font-family: FAMILY_UI;",
            "font-weight: var(--bodyWeight);",
            "-webkit-font-smoothing: antialiased; }",
            ".bar { position: sticky; top: 0; z-index: 5;",
            "padding: 14px 22px; background: var(--raisedBackground);",
            "border-bottom: 1px solid var(--softBorder); }",
            ".bar h1 { margin: 0 0 10px; font-size: 13px;",
            "letter-spacing: .06em; text-transform: uppercase;",
            "color: var(--dimText); font-weight: var(--emphasisWeight); }",
            ".picks { display: flex; flex-wrap: wrap; gap: 6px; }",
            ".pick { font: inherit; font-size: 12px; padding: 5px 11px;",
            "border-radius: 999px; cursor: pointer;",
            "background: var(--insetBackground); color: var(--dimText);",
            "border: 1px solid var(--softBorder); }",
            ".pick[aria-pressed=\"true\"] { background: var(--selection);",
            "color: var(--text); border-color: var(--cursor); }",
            "main { max-width: 1180px; margin: 0 auto;",
            "padding: 30px 22px 70px; }",
            ".two { display: grid; gap: 30px; grid-template-columns: 1fr; }",
            "@media (min-width: 940px) {",
            ".two { grid-template-columns: 1.05fr .95fr; } }",
            ".card { background: var(--raisedBackground); border-radius: 12px;",
            "border: 1px solid var(--softBorder); padding: 22px 24px; }",
            ".tag { font-size: 11px; letter-spacing: .07em;",
            "text-transform: uppercase; color: var(--faintText);",
            "margin: 0 0 14px; font-weight: var(--emphasisWeight); }",
            "pre { margin: 0; overflow-x: auto; font-family: FAMILY_MONO;",
            "font-size: 13.5px; line-height: 1.62; }",
            "pre .line { display: block; white-space: pre; }",
            "pre span { font-weight: var(--bodyWeight); }",
            "pre .emphasis { font-weight: var(--emphasisWeight); }",
            ".book { font-family: FAMILY_SERIF; font-size: 19px;",
            "line-height: 1.62; max-width: 34em; }",
            ".book p { margin: 0 0 1.05em; }",
            ".book p:first-of-type::first-letter { font-size: 3.1em;",
            "float: left; line-height: .84; padding: .05em .09em 0 0;",
            "font-weight: var(--emphasisWeight); color: var(--keyword); }",
            ".byline { font-family: FAMILY_UI; font-size: 12px;",
            "color: var(--faintText); margin: 0 0 16px; }",
            ".lede { font-family: FAMILY_SERIF; font-size: 21px;",
            "line-height: 1.48; margin: 0 0 18px; color: var(--text); }",
            ".col { columns: 2; column-gap: 30px; font-size: 15px;",
            "line-height: 1.58; }",
            "@media (max-width: 720px) { .col { columns: 1; } }",
            ".col p { margin: 0 0 1em; }",
            ".rule { height: 1px; background: var(--ruler);",
            "margin: 26px 0; border: 0; }",
            ".caps { display: flex; flex-wrap: wrap; gap: 18px;",
            "margin-top: 22px; }",
            ".caps p { flex: 1 1 210px; margin: 0; font-size: 12.5px;",
            "line-height: 1.45; color: var(--dimText); }",
            ".grid { display: grid; gap: 7px; margin-top: 30px;",
            "grid-template-columns: repeat(auto-fill, minmax(184px, 1fr)); }",
            ".swatch { display: flex; align-items: center; gap: 9px;",
            "font: inherit; font-size: 11.5px; text-align: left;",
            "padding: 7px 9px; cursor: default;",
            "background: var(--insetBackground); color: var(--dimText);",
            "border: 1px solid var(--softBorder); border-radius: 8px; }",
            ".chip { width: 20px; height: 20px; border-radius: 5px;",
            "flex: 0 0 auto; border: 1px solid var(--softBorder); }",
            ".who { flex: 1 1 auto; overflow: hidden;",
            "text-overflow: ellipsis; white-space: nowrap;",
            "color: var(--text); }",
            ".hex { font-family: FAMILY_MONO; font-size: 10.5px;",
            "color: var(--faintText); }",
            ".lc { font-family: FAMILY_MONO; font-size: 10px;",
            "color: var(--ghostText); }"
        ]
        .joined(separator: "\n")
        .replacingOccurrences(
            of: "FAMILY_UI",
            with: SpecimenPage.interfaceStack)
        .replacingOccurrences(
            of: "FAMILY_MONO",
            with: SpecimenPage.monoStack)
        .replacingOccurrences(
            of: "FAMILY_SERIF",
            with: SpecimenPage.serifStack)
    }

    package static func picker(for themes: [Theme]) -> String
    {
        themes.map
        {
            "<button class=\"pick\" data-pick=\"\($0.identifier)\" "
                + "aria-pressed=\"false\">\($0.title)</button>"
        }
        .joined(separator: "\n")
    }

    package static func body(for themes: [Theme]) -> String
    {
        [
            "<div class=\"bar\">",
            "<h1>Manuscript &middot; eighteen solved themes</h1>",
            "<div class=\"picks\">",
            picker(for: themes),
            "</div></div>",
            "<main>",
            "<div class=\"two\">",
            "<section class=\"card\">",
            "<p class=\"tag\">Code &middot; SF Mono</p>",
            "<pre>",
            SpecimenPage.codeMarkup(),
            "</pre></section>",
            "<section class=\"card\">",
            "<p class=\"tag\">Prose &middot; New York</p>",
            "<p class=\"byline\">"
                + SpecimenText.bookTitle + " &middot; "
                + SpecimenText.bookAuthor + "</p>",
            "<div class=\"book\">",
            SpecimenPage.paragraphs(SpecimenText.book),
            "</div></section>",
            "</div>",
            "<section class=\"card\" style=\"margin-top:30px\">",
            "<p class=\"tag\">Editorial &middot; SF Pro</p>",
            "<p class=\"lede\">"
                + SpecimenPage.escaped(SpecimenText.editorialLede)
                + "</p>",
            "<div class=\"col\">",
            SpecimenPage.paragraphs(SpecimenText.editorialBody),
            "</div>",
            "<hr class=\"rule\">",
            "<div class=\"caps\">",
            SpecimenPage.paragraphs(SpecimenText.captions),
            "</div></section>",
            "<div class=\"grid\">",
            swatches(),
            "</div>",
            "</main>"
        ]
        .joined(separator: "\n")
    }

    package static func script(for themes: [Theme]) -> String
    {
        [
            "<script>",
            "const lc = " + readings(for: themes) + ";",
            "const root = document.documentElement;",
            "function paint(id)",
            "{",
            "  root.dataset.theme = id;",
            "  document.querySelectorAll('.pick').forEach(b =>",
            "    b.setAttribute('aria-pressed',",
            "      String(b.dataset.pick === id)));",
            "  const seen = getComputedStyle(root);",
            "  document.querySelectorAll('.swatch').forEach(s => {",
            "    const role = s.dataset.role;",
            "    const hex = seen.getPropertyValue('--' + role).trim();",
            "    s.querySelector('.hex').textContent = hex;",
            "    s.title = role + '  ' + hex + '  Lc ' +",
            "      ((lc[id] || {})[role] ?? '-');",
            "  });",
            "}",
            "document.querySelectorAll('.pick').forEach(b =>",
            "  b.addEventListener('click', () => paint(b.dataset.pick)));",
            "paint('" + (themes.first?.identifier ?? "") + "');",
            "</script>"
        ]
        .joined(separator: "\n")
    }
}

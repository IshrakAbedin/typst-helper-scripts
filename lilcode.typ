/*
  lilcode.typ - a lightweight code block formatter

  A small alternative to zebraw or codly for when only the basics
  are needed: a language label, a caption, line numbers, and line
  highlighting, each of them optional. The whole thing is one file
  with no state, so it plays well with the rest of the document.

  Font, size, and line spacing are inherited from the surrounding
  document (your own `show raw: set text(...)` and `set par(leading:
  ...)` rules apply), so the block looks like a regular raw block
  with a frame around it. Requires Typst 0.11 or newer.
*/


/// Format a single code block.
///
/// After import, use as:
/// ```
/// #import "lilcode.typ": lilcode
/// // ...
/// #lilcode(
///   ```rust
///   fn main() {}
///   ```,
///   numbers: true,
///   highlight: (1, (3, 4)),
///   caption: [An empty program.],
/// ) <lst:main>
/// ```
///
/// A caption turns the block into a `figure(kind: raw)`, so it gets
/// "Listing N" numbering and can be referenced with `@lst:main`
/// after attaching a label as above.
///
/// - body (raw, str): A block-level raw element, or a plain string.
/// - lang (auto, none, str): The language label shown in the top right
///   corner. `auto` uses the language of the raw block, `none` hides
///   the label, and a string sets a custom label. For a string `body`,
///   the string is also used as the syntax highlighting language.
/// - caption (none, content, str): A figure caption. `none` gives a
///   bare block with no figure around it.
/// - numbers (bool): Whether to show line numbers.
/// - start (int): The number of the first line.
/// - highlight (array): Lines to highlight, given by their displayed
///   numbers (so `start` is respected). Each entry is either a single
///   integer or an inclusive `(from, to)` pair, e.g. `(2, (5, 7))`.
/// - fill (color): Background of the block.
/// - stroke (stroke): Border of the block.
/// - radius (length): Corner radius of the block.
/// - inset (length): Padding between the border and the code.
/// - font (auto, str, array): Code font. `auto` inherits it from the
///   document, e.g. from `show raw: set text(font: ...)`.
/// - size (auto, length): Code size. `auto` inherits it as above.
/// - number-color (color): Color of the line numbers.
/// - lang-color (color): Color of the language label.
/// - highlight-fill (color): Background of highlighted lines.
/// - breakable (bool): Whether the block may split across pages.
#let lilcode(
  body,
  lang: auto,
  caption: none,
  numbers: false,
  start: 1,
  highlight: (),
  fill: luma(248),
  stroke: 0.5pt + luma(215),
  radius: 4pt,
  inset: 0.8em,
  font: auto,
  size: auto,
  number-color: luma(150),
  lang-color: luma(120),
  highlight-fill: rgb("#fff4c2"),
  breakable: true,
) = {
  // Accept plain strings too.
  let raw-body = if type(body) == str {
    raw(body, block: true, lang: if type(lang) == str { lang } else { none })
  } else {
    body
  }
  assert(
    type(raw-body) == content and raw-body.func() == raw,
    message: "lilcode expects a raw block or a string",
  )

  // Language label.
  let label = if lang == none { none } else if lang == auto { raw-body.lang } else { lang }

  // Normalise highlight specs into a flat list of line numbers.
  let marked = ()
  for h in highlight {
    if type(h) == int { marked.push(h) } else { marked += range(h.at(0), h.at(1) + 1) }
  }

  // `raw.lines` is only available inside a show rule, so render there.
  let render(it) = context {
    let pad = par.leading / 2 // follow the document's line spacing
    let lines = it.lines
    let count = lines.len()
    let cells = ()
    for (i, line) in lines.enumerate() {
      let n = start + i
      let bg = if n in marked { highlight-fill } else { none }
      let top = if i == 0 { inset } else { pad }
      let bottom = if i == count - 1 { inset } else { pad }
      if numbers {
        cells.push(grid.cell(
          fill: bg,
          align: right,
          inset: (left: inset, right: 0.6em, top: top, bottom: bottom),
          stroke: (right: 0.5pt + luma(225)),
          text(fill: number-color, str(n)),
        ))
      }
      cells.push(grid.cell(
        fill: bg,
        align: left,
        inset: (left: if numbers { 0.7em } else { inset }, right: inset, top: top, bottom: bottom),
        line.body,
      ))
    }

    block(
      width: 100%,
      fill: fill,
      stroke: stroke,
      radius: radius,
      clip: true,
      breakable: breakable,
      {
        set par(justify: false)
        let overrides = (:)
        if font != auto { overrides.font = font }
        if size != auto { overrides.size = size }
        set text(hyphenate: false, ..overrides)
        if label != none {
          place(top + right, dx: -0.6em, dy: 0.45em, text(size: 0.8em, fill: lang-color, label))
        }
        grid(columns: if numbers { (auto, 1fr) } else { (1fr,) }, ..cells)
      },
    )
  }

  let rendered = {
    show raw: render
    raw-body
  }

  if caption == none { rendered } else {
    figure(rendered, kind: raw, caption: caption)
  }
}

/// Apply lilcode to every block-level raw element in the document,
/// and let code figures break across pages with the caption on top.
///
/// After import, use as:
/// ```
/// #import "lilcode.typ": lilcode-init
/// // ...
/// #show: doc => lilcode-init(doc, numbers: true)
/// ```
///
/// Plain figures such as are styled as well. The options given here
/// do not carry over to blocks that call `lilcode(...)` directly,
/// so pass them again there.
///
/// - doc (content): A content block/whole document body to parse.
/// - caption-pos (alignment): Where figure captions of code go, `top`
///   or `bottom`.
/// - ..options: Any named option of `lilcode`, e.g. `numbers: true`,
///   `fill: luma(240)`. The per-block ones (`caption`, `start`,
///   `highlight`) make little sense globally.
#let lilcode-init(body, caption-pos: top, ..options) = {
  show figure.where(kind: raw): set block(breakable: true)
  show figure.where(kind: raw): set figure.caption(position: caption-pos)
  show raw.where(block: true): it => lilcode(it, ..options)
  body
}

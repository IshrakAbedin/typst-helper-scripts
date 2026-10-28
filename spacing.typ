/*
  spacing.typ - for the ease of setting up document spacing

  I was personally frustrated with experimenting and setting
  up different parameters for proper line, paragraph, and
  heading spread control. Hence, I wrote this script while
  calibrating against LaTeX's setspace package (to some
  extent), that, in my opinion, looks good.

  It also supplies the elegant-style function that sets the
  paragraph justification and the heading and page numbering
  for a regular technical document look.
*/


/// Set the linespread of the overall document.
///
/// After import, use as:
/// ```
/// #import "spacing.typ": set-space
/// // ...
/// #show: doc => set-space(doc, spread: 2.5, lists: "uniform")
/// // or
/// #show: doc => set-space(doc, spread: 1.5, lists: "grouped")
/// ```
///
/// - spread (float): The linespread multiplier.
/// - lists (str): The list spacing style, either `"grouped"`, `"uniform"`, or `none`. Applies to both `list` and `enum`.
///   - `"grouped"` (default): items sit close together, with
///     slightly more space around the whole list, so it reads
///     as one block(LaTeX-like). Suited for general reading
///     at spreads of about 1.0 to 1.5.
///   - `"uniform"`: items and the surrounding list use the
///     same spacing as paragraphs, following the APA/MLA
///     convention. Use this for double-spaced documents
///     (spreads of about 2.4 to 2.6).
///   - `none`: leaves `list` and `enum` spacing untouched, so
///     Typst's own defaults (or your own `set` rules) apply.
/// - doc (content): A content block/whole document body to parse.
#let set-space(spread: 1.0, lists: "grouped", doc) = {
  // 1 -> 1.25, 1.75
  // 1.5 -> 1.5, 2.25
  // 2.0 -> 1.75, 2.5

  let leading = 0.50em * spread
  let spacing = 1.25em * spread
  let h-below = 0.75em + 0.5em * spread
  let h-above = 1.25em + 0.5em * spread

  set par(
    spacing: spacing,
    leading: leading,
  )

  show heading: set block(
    above: h-above,
    below: h-below,
  )

  // Gap between list items.
  // "grouped": a bit more than line leading, much less than
  // paragraph spacing
  // "uniform": same as paragraph spacing (APA/MLA-style)
  let item-gap = if lists == "uniform" {
    spacing
  } else {
    leading * 1.6
  }

  // Gap before and after the whole list.
  let list-around = if lists == "uniform" {
    spacing
  } else {
    spacing * 0.9
  }

  let doc = if lists == none {
    doc
  } else {
    set list(spacing: item-gap)
    set enum(spacing: item-gap)
    show list: set block(above: list-around, below: list-around)
    show enum: set block(above: list-around, below: list-around)
    doc
  }

  doc
}

/// Set a reasonable minimal styling to the document with
/// justification, three stage heading numbering with spacing
/// afterwards, and simple page numbering in the bottom-middle
/// of the page.
///
/// After import, use as:
/// ```
/// #import "spacing.typ": elegant-style
/// // ...
/// #show: doc => elegant-style(doc)
/// ```
///
/// - doc (content): A content block/whole document body to parse
#let elegant-style(doc) = {
  set par(justify: true)
  set heading(numbering: "1.1.1   ")
  set page(numbering: "1")
  set enum(numbering: "1.a.i.")
  doc
}

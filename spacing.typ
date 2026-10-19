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
/// #show: doc => set-space(doc, spread: 2.25)
/// ```
///
/// - spread (float): The linespread multiplier.
/// - doc (content): A content block/whole document body to parse.
#let set-space(spread: 1.0, doc) = {
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
  doc
}

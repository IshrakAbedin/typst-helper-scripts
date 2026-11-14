// Demonstration document for the lilcode.typ script
// Try toggling numbers, changing the leading, or the raw font and size below.

#import "lilcode.typ": lilcode, lilcode-init

#set page(
  paper: "a4",
  margin: 1in,
)

#set text(
  font: "Libertinus Serif",
  size: 12pt,
)

#set par(justify: true, leading: 0.75em)
#set heading(numbering: "1.1")

// lilcode inherits these, so the code blocks follow them.
#show raw: set text(font: "DejaVu Sans Mono", size: 10pt)

= Single Blocks
The simplest call takes a raw block and shows the language in the top right corner, as an icon when one is available, with nothing else added.

#lilcode(```python
def greet(name):
    return f"Hello, {name}!"
```)

Line numbers, highlighting, and a caption are optional. Highlighted lines are given by their displayed numbers, either one by one or as inclusive ranges, so here lines 2 to 4 are marked. With a caption, the block becomes a figure that can be referenced, as in @lst:sum.

#lilcode(
  ```rust
  fn main() {
      let xs = vec![1, 2, 3];
      let total: i32 = xs.iter().sum();
      println!("{total}");
  }
  ```,
  numbers: true,
  highlight: ((2, 4),),
  caption: [Summing a vector.],
) <lst:sum>

The first line number can be changed, which is handy for excerpts, and the label can be replaced or hidden altogether. A custom label such as "C99" has no icon, so it is shown as text. A plain string works as well, in which case the `lang` option also picks the syntax highlighting.

#lilcode(
  ```c
  int x = 0;
  x += 1;
  ```,
  numbers: true,
  start: 42,
  lang: "C99",
)

#lilcode("echo hello", lang: none)

= Language Icons
Icons are the default. They are looked up from the language of the raw block, and common aliases work too, so `py`, `rs`, `sh`, `yml`, and many other tags all find their icon.

#lilcode(```py
print("py is an alias of python")
```)

#lilcode(```sh
echo "sh and bash share the shell icon"
```)

Languages without an icon fall back to the usual text label, so nothing breaks when an unusual one comes along.

#lilcode(```brainfuck
++++++++[>++++++++<-]>+.
```)

To get the text label instead, pass `icons: false` to a single block. The icon follows `lang-color`, and its height is set by `icon-size`.

#lilcode(
  ```rust
  fn main() { println!("text label"); }
  ```,
  icons: false,
)

#lilcode(
  ```rust
  fn main() { println!("bigger, colored icon"); }
  ```,
  lang-color: rgb("#b7410e"),
  icon-size: 1.8em,
)

An explicit `lang` string is looked up as well, so `lang: "python"` gives the icon on a plain string, while content such as `[Python 3]` is always shown as written.

#lilcode("x = 1", lang: "python")

#lilcode("x = 1", lang: [Python 3])

= Whole Document
== Global Mode
Calling `lilcode-init` on the document body styles every block-level raw element, so no per-block call is needed. Captions then go above the code and the figures may break across pages.

#[
  #show: doc => lilcode-init(doc, numbers: true)

  ```js
  console.log("styled by a show rule");
  ```

  #figure(
    caption: [A plain figure is styled too.],
    ```toml
    [package]
    name = "demo"
    ```,
  )
]

The same call turns the icons off for the whole scope, which is the global switch. Local options still apply to blocks that call `lilcode` directly, since those do not inherit what is given here.

#[
  #show: doc => lilcode-init(doc, icons: false)

  ```js
  console.log("text label, set once for the scope");
  ```
]

#pagebreak()

== Inherited Settings
The code above uses the font, size, and line spacing set at the top of this document. Changing the paragraph leading changes the spacing between code lines as well, as seen below with a deliberately large value.

#[
  #set par(leading: 1.5em)

  #lilcode(
    ```python
    for i in range(3):
        print(i)
    ```,
    numbers: true,
  )
]

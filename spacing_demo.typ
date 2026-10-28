// Demonstration document for the spacing.typ script
// Try different set-space values, such as 1, 1.5, 2.4, etc.

#import "spacing.typ": elegant-style, set-space

#set page(
  paper: "a4",
  margin: 1in,
)

#set text(
  font: "Libertinus Serif",
  size: 12pt,
)

#show: doc => set-space(doc, spread: 1.5, lists: "grouped")
#show: doc => elegant-style(doc)

= A Dummy Section
The digital age has fundamentally transformed how human beings communicate, learn, and build communities across the globe. With instantaneous access to vast repositories of knowledge, individuals can acquire new skills, explore diverse cultures, and connect with like-minded peers regardless of geographical boundaries. However, this unprecedented connectivity also presents unique challenges, such as information overload and the blurring line between virtual interactions and authentic real-world relationships. As technology continues to evolve, finding a balance between digital convenience and physical presence remains a defining task of modern life.

In parallel with technological advances, the natural world continues to demonstrate remarkable resilience and complex adaptability. From dense tropical rainforests to hyper-arid desert ecosystems, organisms have developed intricate behavioral and physiological mechanisms to survive in demanding environments. Understanding these ecological systems is critical, as human activity increasingly impacts global climate patterns and biodiversity. By studying how natural systems maintain balance despite shifting conditions, scientists can better design sustainable practices that protect natural habitats while supporting human development needs.

= Another Dummy Section

== Some Subsection within Another Dummy Section

Ultimately, progress depends on fostering meaningful synthesis between human ingenuity and sustainable stewardship. True advancement requires not only technological innovation, but also ethical reflection on how these tools are deployed within society. When individuals and institutions prioritize empathy, critical thinking, and long-term sustainability, they lay the foundation for resilient communities capable of navigating future challenges. Balancing economic ambition with ecological responsibility and social well-being remains the key to building a prosperous, equitable future for generations to come.

Lists and enums also get spacing between preceding text and their start.
+ This is the first item. It contains a lot of text, so it should move on to the second line. And then we can start a second point.
+ This is the second item, which only serves the purpose of being the indicator of the spacing produced between the previous item and this one.
The digital age has fundamentally transformed how human beings communicate, learn, and build communities across the globe.
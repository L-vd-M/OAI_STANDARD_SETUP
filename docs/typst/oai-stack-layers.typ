// How the OAI Stack Layers Fit Together
// Generated: 2026-07-14

#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2.2cm, left: 2.2cm, right: 2.2cm),
  header: [
    #set text(size: 8pt, fill: rgb("#888888"))
    #grid(columns: (1fr, 1fr),
      [How the OAI Stack Layers Fit Together],
      align(right)[OAI_STANDARD_SETUP · 2026-07-14])
    #line(length: 100%, stroke: 0.5pt + rgb("#cccccc"))
  ],
  footer: [
    #set text(size: 8pt, fill: rgb("#888888"))
    #line(length: 100%, stroke: 0.5pt + rgb("#cccccc"))
    #grid(columns: (1fr, 1fr),
      [Generated: 2026-07-14],
      align(right)[Page #context counter(page).display()])
  ]
)

#set text(font: "Liberation Serif", size: 10.5pt, lang: "en")
// Heading numbers are already embedded literally in the section text (e.g. "1. Overview"),
// carried over from the companion Markdown source -- do not also enable Typst's auto-numbering,
// which would duplicate them.

#show heading.where(level: 1): it => {
  v(1em)
  block(fill: rgb("#003366"), inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%,
    text(fill: white, weight: "bold", size: 12pt, it.body))
  v(0.4em)
}
#show heading.where(level: 2): it => {
  v(0.7em)
  text(weight: "bold", size: 11pt, fill: rgb("#003366"), it.body)
  v(0.2em)
}
#show heading.where(level: 3): it => {
  v(0.5em)
  text(weight: "bold", size: 10.5pt, it.body)
  v(0.1em)
}

#show raw.where(block: false): it => box(
  fill: rgb("#f0f0f0"), inset: (x: 3pt, y: 0pt), outset: (y: 2pt), radius: 2pt,
  text(font: "Liberation Mono", size: 9pt, it)
)

#show figure: it => {
  set align(center)
  block(width: 100%, it.body)
  v(0.3em)
}

// ─── TITLE BLOCK ─────────────────────────────────────────────────────────────
#align(center)[
  #v(0.5em)
  #block(fill: rgb("#003366"), inset: (x: 20pt, y: 14pt), radius: 4pt, width: 100%)[
    #text(fill: white, weight: "bold", size: 18pt)[How the OAI Stack Layers Fit Together]
    #v(0.3em)
    #text(fill: rgb("#aaccff"), size: 11pt)[PHY → MAC → RLC → PDCP → SDAP → RRC, F1AP/E1AP/NGAP, and the 5G Core]
  ]
  #v(0.5em)
]

#text(size: 9pt, fill: rgb("#666666"))[
  Companion to `docs/research/oai-ue-power-saving-implementation.md` and
  `docs/research/oai-power-saving-poc-changelog.md`. Every file path, function, and struct name in
  this document was grep-confirmed live against `OAI_RAN_code/openairinterface5g` and
  `OAI_CN_code/oai-cn5g-*` this session — see `docs/research/oai-stack-layers.md` for the Markdown
  source. Diagrams rendered from embedded Mermaid via mermaid-cli, since Typst has no native
  Mermaid renderer.
]

#v(0.5em)
#outline(indent: auto)
#pagebreak()

#include "oai-stack-layers-body.typ"

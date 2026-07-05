---
title: "<Author><Year> — <Short paper title>"
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
type: paper
status: draft
tags: [type/paper, status/draft, domain/<x>, venue/<x>]
aliases: ["<Full paper title>"]
sources:
  - "doi:10.xxxx/yyyy"
  - "arxiv:xxxx.xxxxx"
authors: ["<First author>", "<Second author>", "..."]
year: <YYYY>
venue: "<Conference / journal>"
---

# <Author><Year> — <Short paper title>

*<One-line takeaway. What is the single sentence I'd quote from this paper?>*

## TL;DR

Three to five sentences. The contribution, the method, the result. No
more.

## Problem

What gap in the literature did the authors address? Why does it matter?

## Method

The technical core. Equations welcome. Use `$$ ... $$` for display math.

$$
\mathcal{L}_{\text{example}} = \mathbb{E}_{x, t}\bigl[\|f_\theta(x, t) - g(x, t)\|_2^2\bigr]
$$

## Results

Headline numbers + the comparisons that matter. Reproduce the key table
inline if it helps.

## Strengths

- ...

## Weaknesses / open questions

- ...

## Relevance to my work

Two to four bullets. Concrete. Where does this slot into projects or
concepts I already have?

- For [[01_Projects/<project-slug>/_README|<Project>]]: <how it applies>
- Connects to [[03_Resources/concepts/<concept>|<Concept>]]: <how>

## Quotes (sparse, ≤15 words each)

Use sparingly. Prefer paraphrase. Cite page or section.

- "<short verbatim>" — § <section>

## Related

- [[03_Resources/papers/<topic>/_MOC|<Topic MOC>]]
- [[<related-paper-1>]]
- [[<related-concept>]]

#type/paper #domain/<x> #venue/<x> #status/draft

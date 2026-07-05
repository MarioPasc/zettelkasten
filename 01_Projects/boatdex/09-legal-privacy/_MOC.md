---
title: "MOC — BoatDex · Legal & privacy"
type: moc
created: 2026-07-05
updated: 2026-07-05
tags: [type/moc, project/boatdex, domain/privacy-gdpr]
---

# MOC — BoatDex · Legal & privacy

*The governance layer — the hard lines that keep BoatDex lawful and clearly
distinct from anything stalking-adjacent. Project context: the developer
operates under EU law, so GDPR is a design constraint, not an afterthought;
the product principles (no owner ID, public info only, no people-tracking,
privacy-by-default) are load-bearing (see [[../_README|README]] and
[[../01-product/_MOC|Product MOC]]).*

## Scope

GDPR obligations concretely mapped to the data model, and the product
guardrails restated as enforceable engineering constraints. This area has
veto power over features: if a capability crosses a guardrail, it is cut.

## Planned notes

- [[gdpr-compliance|GDPR compliance]] — lawful basis for processing; data minimisation (public AIS identity fields only); user rights (access, erasure → the `ON DELETE CASCADE` design); consent for notifications; data retention; processor agreements (AIS provider, push provider, host); privacy policy
- [[product-guardrails|Product guardrails]] — the five hard lines as constraints: (1) sighting is past-tense value, (2) no owner/beneficial-owner identification, (3) public info only, (4) no tracking of individuals, no police/military/non-AIS vessels, (5) privacy by default; what each forbids at the feature level

## Open questions (Q&A agenda)

- Data controller identity — personal name vs. a registered entity; liability implications of publishing an app.
- Photos of vessels in public places: any bystander-in-frame / personal-data concerns?
- Location data on sightings — is storing the spot's GPS point a privacy exposure worth minimising or coarsening?
- Age gating / minimum age for accounts (GDPR Art. 8).
- Terms of Service + Privacy Policy drafting — needed before any public release.

## Sources

- `BoatDex_Product_Brief.md` §Product principles (the non-negotiables).
- `BoatDex_SPECIFICATION.md` §1 (explicit non-goals / product guardrails, GDPR note).

## Parent

- [[../_MOC|BoatDex Project MOC]]
- [[/99_Index|Vault Index]]

#type/moc #project/boatdex #domain/privacy-gdpr

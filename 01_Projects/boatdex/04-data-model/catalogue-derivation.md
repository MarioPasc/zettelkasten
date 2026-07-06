---
title: "Catalogue derivation"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/data-modeling, project/boatdex]
aliases: ["catalogue view", "collection derivation"]
sources: []
---

# Catalogue derivation

*A user's catalogue is not a stored table — it is `sighting` grouped by the
collectible unit `(user, vessel, region)`. Rarities R1 and R2 are joined at
read time through the presence port, never denormalised.*

The collectible unit is a distinct **`(vessel, region)`** pair: the same boat
seen in two regions is two catalogue entries (each with its own regional
rarity). Full entity in [[domain-entities|`CatalogueEntry`]].

## The view

```sql
CREATE VIEW catalogue_entry AS
SELECT user_id, vessel_id, region_id,
       COUNT(*)        AS sighting_count,
       MIN(spotted_at) AS first_seen,
       MAX(spotted_at) AS last_seen
FROM   sighting
GROUP  BY user_id, vessel_id, region_id;
```

Re-sighting the same `(vessel, region)` increments `sighting_count`; it never
adds a catalogue entry and never changes the score (the score is set-additive —
see [[../05-domain-core/collection-score|collection score]]).

## Read path: attaching rarity

For a user's catalogue request, the application layer:

1. reads `catalogue_entry` rows for `user_id`;
2. for each `(vessel_id, region_id)`, asks the
   [[../05-domain-core/regional-presence-port|presence port]] for counts and
   computes two rarities through the **same**
   [[../05-domain-core/rarity-surprisal|rarity function]]:
   - **R1** (encounter difficulty) via `AISPresence` — **stand-in
     `SightingBackedPresence` until milestone MA** — this is what the score sums;
   - **R2** (community frequency) via `SightingBackedPresence` — a shown badge;
3. sums R1 across the user's entries →
   [[../05-domain-core/collection-score|collection score]].

```
GET /me/catalogue  ⇒  { entries: [ {vessel, region, count, first_seen,
                                    last_seen, r1_bits, r2_bits} ... ],
                        collection_score: Σ r1_bits }
```

## Why derived, not stored

- **One source of truth.** Counts, first/last-seen, and the score all fall out
  of `sighting`; there is nothing to keep consistent.
- **Rarity stays swappable.** Because R1 comes through the port, the catalogue's
  numbers upgrade from sighting-backed to AIS ground truth (MA) with no schema
  change — the same reuse seam the [[../11-roadmap/implementation-sequencing|build order]]
  is built around.
- If read latency ever bites, a materialised view or a `presence_stat` cache is
  a transparent optimisation behind the same interface.

## Related

- [[_MOC|Data-model MOC]]
- [[relational-schema|Relational schema]] — the `sighting` rows this groups
- [[domain-entities|Domain entities]] — `CatalogueEntry`
- [[../05-domain-core/collection-score|Collection score]] — Σ R1 over entries
- [[../05-domain-core/rarity-surprisal|Rarity as regional surprisal]] — R1 / R2
- [[../06-features/sightings-and-catalogue|Sightings & catalogue feature]]

#type/concept #status/active #domain/data-modeling #project/boatdex

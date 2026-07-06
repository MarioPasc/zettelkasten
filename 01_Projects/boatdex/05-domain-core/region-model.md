---
title: "Region model — named regions over an H3 grid"
created: 2026-07-06
updated: 2026-07-06
type: concept
status: active
tags: [type/concept, status/active, domain/geospatial, project/boatdex]
aliases: ["region model", "region tree", "H3 grid", "region resolver"]
sources: []
---

# Region model — named regions over an H3 grid

*Rarity and the collectible unit are measured over **named maritime regions**
(seas / oceans / EEZs, identified by Marine Regions **MRGID**). An **H3 grid**
is internal plumbing that (1) resolves a coordinate to its region with an O(1)
dict lookup — no runtime PostGIS — and (2) guarantees the named regions form
the non-overlapping **partition** the rarity math and the presence-port
contract require.*

Decision (2026-07-06 Q&A): collectible/rarity unit = **named region**; grid =
**H3 v4**, chosen for its first-class polygon-fill and its de-facto-standard
status in AIS/vessel-density work (which also serves the future heatmap).

## Two layers

**Domain view (pure).** A tree of `Region` value objects keyed by
`RegionId` (= MRGID; see [[value-objects|value objects]]), each with a
`parent_id` and `level`: e.g. *Alborán Sea → Mediterranean Sea → Atlantic
Ocean → global root*. Rarity ([[rarity-surprisal|surprisal]]), the catalogue,
and the [[regional-presence-port|presence port]] operate **only** over this
tree. **The domain never imports H3.**

**Infrastructure plumbing.** A second port, `RegionResolver`
(`Coordinate → RegionId | None`), whose adapter is H3-backed:

- **Offline build** — rasterise each Marine Regions polygon (IHO Sea Areas +
  World EEZ v12) to H3 cells with `h3.polygon_to_cells(..., res=4)`
  (**centroid containment** ⇒ each cell falls in exactly one region ⇒ automatic
  tie-break, zero ambiguity). Emit a `cell → MRGID` table (Parquet/SQLite).
- **Runtime** — `h3.latlng_to_cell(lat, lon, 4)` (~µs) → `dict[cell, MRGID]`
  lookup. No geometry, no PostGIS, at request time.

Because every cell maps to exactly one MRGID, named regions are unions of
disjoint cells ⇒ a **guaranteed partition**. That is what makes the presence
port's contract (child regions tile the parent, no overlap) *true by
construction* rather than assumed.

## Backoff & gaps

Rarity shrinks up the tree: `region → parent → … → global root`. Marine Regions
does **not** tile the high seas; a coordinate whose cell has no MRGID resolves
to `None` → treated as **open ocean → global root** at the top of the backoff
(never k-ring-snapped to a nearby named region, which would conflate distinct
seas).

## Standards, data & licence

- **Named regions:** Marine Regions gazetteer — MRGID stable ids, hierarchical
  relations; **IHO Sea Areas (S-23)** + **World EEZ v12**. Licence **CC-BY 4.0**
  → attribution required (VLIZ) — recorded as a [[../09-legal-privacy/_MOC|legal]] obligation.
- **Grid:** **H3 v4** (`h3-py ≥ 4`, Apache 2.0).
- **Offline geo libs:** `shapely` (antimeridian split), H3 polyfill. `pyproj`
  only if reprojection is needed. None of these are runtime dependencies.

## Implementation gotchas (encode in the build script)

1. **Pin `h3-py ≥ 4`.** The v4 API renamed everything (`geo_to_h3 →
   latlng_to_cell`, `polyfill → polygon_to_cells`); most online examples are v3.
2. **Base resolution = 4** (~1 770 km²/cell; ~288 k ocean cells → a trivial
   dict). **Micro-EEZs** (Nauru, Tuvalu) get 0–1 cells at res 4 → rasterise
   those at **res 5** and merge (mixed-resolution keys are fine).
3. **Antimeridian:** split polygons on the 180° line (`shapely.ops.split`)
   **before** `polygon_to_cells`; several Pacific/Russia EEZ polygons cross it.
4. **Do not use `CONTAINMENT_OVERLAPPING`** — it duplicates cells across
   regions and breaks the partition. Centroid containment is the whole point.
5. **Pentagons** (12 per resolution) all sit in ocean; they resolve normally,
   just don't hard-code "6 neighbours" downstream.

## Config

Base resolution and the dataset version live in a **versioned `RegionConfig`**
(sibling of `RarityConfig`), so a resolution change or a dataset refresh is
traceable — the same reproducibility discipline as
[[../10-quality-and-ops/coding-standards|coding standards §5]].

## Consequence for earlier decisions

- **PostGIS is demoted** from a runtime dependency to an **offline data-prep
  tool**; the [[../04-data-model/relational-schema|schema]]'s runtime region
  resolution no longer needs `ST_Covers`.
- `sighting.region_id` is an **MRGID**, resolved via the H3 adapter at write
  time; precise coordinates are still discarded.

## Sources

- Marine Regions: https://www.marineregions.org (MRGID, EEZ v12, IHO Sea Areas; CC-BY 4.0)
- H3: https://h3geo.org/docs/api/regions · `h3-py` (Apache 2.0)
- H3 vs S2: https://h3geo.org/docs/comparisons/s2

## Related

- [[_MOC|Domain-core MOC]]
- [[regional-presence-port|Regional presence port]] — the partition this guarantees
- [[rarity-surprisal|Rarity as regional surprisal]] — backs off up this tree
- [[value-objects|Value objects]] — `RegionId` (MRGID), `Coordinate`
- [[../04-data-model/relational-schema|Relational schema]] — the `region` table + cell→MRGID lookup
- [[../03-tech-stack/_MOC|Tech stack]] — h3-py, Marine Regions dataset

#type/concept #status/active #domain/geospatial #project/boatdex

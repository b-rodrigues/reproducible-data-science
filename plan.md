# Plan — T Language: Gaps & Enrichment

A plan for the T-language material the book does not yet cover, plus ways to
enrich how the language itself is presented.

**Method.** Cross-referenced the T source (`../tlang`, v0.55.0 — OCaml, Menhir
grammar in `src/parser.mly`, evaluator in `src/eval.ml`, builtins in
`src/packages/*`) against all 16 chapters to build a gap analysis.

**Scope decision.** Focus on the *defining ideas* of T plus core presentation
enrichment — not the exhaustive feature inventory. All new material is **folded
into existing chapters**; no new chapters are added.

---

## What is already covered (do not duplicate)

- Two pipes + errors-as-values — ch. 4, ch. 6
- `colcraft` core verbs (`select`/`filter`/`mutate`/`arrange`/`group_by`/
  `summarize`), reshaping, missing values, `str_*`, `chrono` dates, factors +
  `fct_*`, NDArray + `matmul`, formulas `~` + `lm()` — ch. 14
- Lenses, metaprogramming (`quo`/`to_expr`/`!!`/`!!!`/`enquo`/NSE/`$param`),
  serializers in depth, plotting, `nix_options`, T packages, Propcraft, REPL
  magic, shell escape `?{ }>`, functions — ch. 15
- Patterns (`map`/`cross`/`slice`/`head`/`tail`/`sample_pattern`),
  `node_when`/`node_fork` — ch. 9
- `t check` (3 tiers), `t diff`, `t fix`, `t test`, `t init`, `t update` —
  ch. 4/5/7
- NDJSON streaming (`t run --json`) — ch. 5
- `explain()` — **lightly** (ch. 5:291, node-only, one line)
- `match` — **only** for error-catching (ch. 10:156)
- Type annotations — **incidental only** (ch. 9, 10, 15)

---

## Part A — New features to add (the gaps)

### A1. `explain()` — from node-summary to "introspect anything"
- **Where:** ch. 15 (new/expanded section); cross-reference from ch. 5:291.
- **Current state:** ch. 5 shows `explain(p.model)` as a one-line node summary.
- **Add:**
  - `explain()` works on *any* value, not just nodes: DataFrames, dicts,
    vectors, errors, formulas, lenses, pipelines.
  - `explain_json()` for machine-readable introspection.
  - The design idea: **introspection is first-class** — you can always ask T
    "what is this?" and get a structured answer.
  - Tie it to the LLM-pairing story: `explain`/`explain_json` + `AGENTS.md` are
    what let an agent query build artifacts without reading Nix internals.

### A2. `intent { }` blocks
- **Where:** ch. 15 (new section, next to `explain`).
- **Current state:** absent entirely.
- **Add:**
  - `intent { key: value }` attaches declarative metadata to a node — the
    *why*, not just the *what*.
  - `intent_get` / `intent_fields` to query it.
  - How intent + explain together make a pipeline self-documenting and
    agent-readable.

### A3. The type system
- **Where:** ch. 15 (new section); a one-paragraph pointer in ch. 4.
- **Current state:** annotations appear incidentally (`\(x: Int -> Int)`) but
  are never explained.
- **Add:**
  - Parameter and return annotations: `: Int`, `: DataFrame`, `-> T`.
  - **Strict vs repl mode** — `t check` / scripts default to strict (full
    annotations required on top-level lambdas); the REPL is permissive.
  - Semantic types and their aliases (`int|integer`, `string|text`,
    `float|double|number|numeric`, `to_dataframe|table`).
  - `DataFrame[schema]` — typed columns, the basis of `t check --schema`.

### A4. The stats package
- **Where:** ch. 14 (new section, right after "Formulas and models").
- **Current state:** only `lm()` is covered.
- **Add:** a "quick stats in T" section: `cor`/`cov`, `anova`, `fivenum`,
  `cut`, `cumsum`/`cummean`, `dense_rank`, `conf_int`. Position it as the
  fast "does this variable matter / what's the shape" check without leaving the
  language.

### A5. Pattern matching, taught as a feature
- **Where:** ch. 10 (elevate the existing error-catch example at 10:156 into a
  proper treatment).
- **Current state:** `match` is only shown catching `Error { }`.
- **Add:**
  - List patterns, the `_` wildcard, constructor patterns, nested patterns.
  - When to reach for `match` vs `if/else` (and the overlap with
    errors-as-values).

### A6. Missing core operators
- **Where:** ch. 4 operator reference (Part B1) + ch. 14 in context.
- **Current state:** none of these are covered.
- **Add:**
  - `in` — membership test.
  - `..` — range operator (the book only shows `seq()`).
  - `%name%` — R-style percent infix custom operators.
  - The **broadcast family** (`.+` `.-` `.*` `./` `.%` `.==` `.!=` `.<` `.>`
    `.&` `.|` `~>`) and the scalar-vs-broadcast distinction (the ch. 14
    `&`/`|` vs `&&`/`||` warning is the seed of this).

### A7. Key missing `colcraft` verbs
- **Where:** ch. 14.
- **Current state:** core verbs covered; these are not.
- **Add:** the join family (`inner_join`/`left_join`/`anti_join`/`full_join`),
  `distinct`, `count`, and `case_when`/`ifelse`.
  - (Deliberately deferred: `window_*`, `t_complete`/`t_crossing` — see
    "Out of scope".)

---

## Part B — Enrich the presentation of the language

### B1. Consolidated operator reference
- **Where:** ch. 4, "A Quick Tour of T Syntax".
- **Why:** operator knowledge is currently scattered across ch. 4, 10, 14, 15.
- **Add:** a single at-a-glance table — pipes (`|>`/`?|>`), formula (`~`),
  arithmetic (scalar + broadcast), comparison (scalar + broadcast), logical
  (`&&`/`||`/`!`), percent (`%…%`), range (`..`), membership (`in`),
  unquote (`!!`/`!!!`), assignment (`=`/`:=`). Precedence + one-line meaning
  each.

### B2. Value-types overview
- **Where:** ch. 4.
- **Why:** the set of things a T value can be is never stated.
- **Add:** a "what can a T value be?" table — `Int`, `Float`, `Bool`,
  `String`, `NA`, `Error`, `Symbol`, `List`, `Dict`, `Vector`, `NDArray`,
  `DataFrame`, `Factor`, `Date`/`Datetime`, `Formula`, `Lens`, `Lambda`,
  `Pipeline`/`Node`. One line each; link to the chapter that covers each.

### B3. How T evaluates — a mental model
- **Where:** ch. 4 (short section); reinforces ch. 14/15.
- **Add:** a compact "how evaluation works" note — the **data mask** (why
  `$col` resolves to a column inside a verb), **non-standard evaluation** (when
  a bare name is captured as a symbol vs evaluated), and **errors-as-values**
  (why a failing expression is a value you can branch on). This is the thread
  that ch. 14 and ch. 15 currently assume rather than state.

### B4. First-class treatment of annotations + pattern matching
- Promote type annotations (A3) and pattern matching (A5) from incidental
  examples to named, taught features, each with a "when you'll reach for this"
  framing.

---

## Chapter map

| Chapter | New / enriched content |
|:--------|:-----------------------|
| **ch. 4** | Operator reference (B1), value-types table (B2), evaluation mental model (B3), one-paragraph type-annotation pointer (A3) |
| **ch. 10** | Pattern matching elevated to a feature (A5) |
| **ch. 14** | Operators in context (A6), missing `colcraft` verbs (A7), stats package (A4) |
| **ch. 15** | `explain()` in depth (A1), `intent { }` blocks (A2), type system (A3) |

---

## Suggested sequencing

1. **ch. 4 enrichment** — operator reference, value-types table, evaluation
   model. Foundational and low-risk; everything else can cross-reference it.
2. **ch. 14 additions** — operators in context, missing verbs, stats package.
3. **ch. 15 additions** — `explain()`, `intent {}`, type system.
4. **ch. 10** — pattern matching.
5. **Cross-reference + de-duplication pass** — point ch. 5's `explain` at the
   ch. 15 deep-dive; ensure the ch. 4 reference doesn't restate ch. 14/15
   detail.

---

## Out of scope (noted for a future pass)

- `window_*` functions, `t_complete`/`t_crossing`
- Full pipeline-introspection functions (`inspect_pipeline`/`inspect_node`/
  `inspect_artifacts`, `build_log`, `errored_nodes`, `downstream_of`,
  `trace_nodes`, `which_nodes`, `read_past_node`)
- `fetchurl` as a node constructor
- `t export_artifacts` / `t import_artifacts`
- The LSP server (editor integration)
- The `t explain` CLI command

---

## Open questions

- None blocking. Scope (defining ideas + core enrichment) and structure (fold
  into existing chapters, no new chapters) are settled.

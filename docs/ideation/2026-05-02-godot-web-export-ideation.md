---
date: 2026-05-02
topic: godot-web-export
focus: browser-playable build (Godot → WASM / static host)
mode: repo-grounded
---

# Ideation: Ship Noah’s Game in the browser

## Grounding context

**Repository:** Godot **4.3+** project (`project.godot`), **GDScript**, **Forward+** listed in features — **web export requires Compatibility renderer** at runtime (handled via **Web export preset**, not necessarily changing desktop preset). Entry: `scenes/ui/main_menu.tscn`. Autoloads: `SaveManager`, `PlayerProfile`, `GameFlow`, input setup. Saves under `user://` (JSON slots + settings).

**Hosting today:** `vercel.json` runs `npm run build` and ships **`public/index.html`** — a **landing page**, not the game. True browser play needs **Godot Web export** artifacts (`index.html`, `.wasm`, `.pck`, etc.).

**External (web research):** Godot 4 web uses **WebAssembly + WebGL 2**; **single-threaded export is the practical default** (fewer **SharedArrayBuffer / COOP/COEP** issues; better on Safari than threaded). **Threaded** builds need **HTTPS** plus **`Cross-Origin-Opener-Policy: same-origin`** and **`Cross-Origin-Embedder-Policy: require-corp`** (or **PWA / service worker** workarounds in engine). **CLI:** `godot --headless --export-release "<preset>" <output.html> --path .`. Serve **`.wasm`** with correct MIME; enable **gzip/brotli** for `.wasm`/`.pck`. **Safari** is weaker on WebGL2 — expect extra QA. **Mobile web** is thermally limited vs native.

**Past learnings:** No `docs/solutions/` entries in this repo.

---

## Ranked ideas

### 1. CI headless Web export + point Vercel at the build folder

**Description:** Add a **`Web`** export preset** in Godot (saved as `export_presets.cfg`), pin **export template version** to editor version, and run **`godot --headless --export-release "Web" ...`** in CI (GitHub Actions). Publish the generated folder (e.g. `dist/web/` or `public/game/`) as **Vercel `outputDirectory`** or copy into `public/` post-build. Replace or augment the stub `npm run build` so production serves **`index.html` + WASM + PCK**.

**Rationale:** End-to-end path from this repo to a URL that runs the actual Godot runtime — matches “run in the browser” directly and builds on existing Vercel wiring.

**Downsides:** Requires **Godot CLI + export templates** in CI (Docker image or cached download); build minutes and artifact size; must verify **preset name** matches CLI.

**Confidence:** 88%

**Complexity:** Medium

**Status:** Unexplored

---

### 2. Commit `export_presets.cfg` + Web preset tuned for this project

**Description:** Version-control **`export_presets.cfg`** after configuring **Project → Export → Web**: **Compatibility** renderer for web, **single-threaded** default unless you explicitly need threads + COOP headers, **filename `index.html`**, optional **custom HTML shell** for branding / loading bar. Document editor version in `README` / `docs/tech-stack.md`.

**Rationale:** Reproducible exports for every contributor and CI; avoids “works on my machine” export drift.

**Downsides:** Merge conflicts if multiple people tweak presets; template version must stay aligned with Godot version.

**Confidence:** 92%

**Complexity:** Low

**Status:** Unexplored

---

### 3. `vercel.json` headers: MIME, caching, and optional COOP/COEP

**Description:** Extend **`vercel.json`** with **`headers`**: correct **`Content-Type`** for `.wasm`, long-cache **immutable** for hashed assets if you add fingerprinting later, and — **only if** you enable **threads / SharedArrayBuffer** — **`Cross-Origin-Opener-Policy`** + **`Cross-Origin-Embedder-Policy`** on HTML/WASM routes. If **single-threaded**, skip isolation headers to avoid breaking embeds and third-party scripts.

**Rationale:** Threaded WASM fails silently without isolation; wrong MIME breaks startup; this is high leverage for production stability.

**Downsides:** COOP/COEP tightens cross-origin rules (ads, analytics, some embeds need extra config).

**Confidence:** 85%

**Complexity:** Low–Medium

**Status:** Unexplored

---

### 4. Browser UX pass: load time, audio unlock, pointer lock

**Description:** Add an explicit **“Tap to play”** / **focus canvas** step so **audio** and **mouse capture** behave under browser autoplay policies; consider **export splash / progress** for large `.pck`. Test **Esc** freeing mouse vs menu (**M**) as already documented.

**Rationale:** Desktop-first controls often feel broken on web until this is intentional.

**Downsides:** Extra UI state; mobile Safari still harder than desktop Chrome.

**Confidence:** 80%

**Complexity:** Medium

**Status:** Unexplored

---

### 5. Audit persistence on web (`user://` → IndexedDB)

**Description:** Validate **`SaveManager`** / **`PlayerProfile`** paths on HTML5 — **`user://`** maps to browser storage with **quota** and **Safari private mode** quirks. Add graceful degradation (export/import JSON string, “storage full” message) if needed.

**Rationale:** Silent save failure kills the fork/gallery loop that’s core to the design.

**Downsides:** Requires device testing; may need UX for permission failures.

**Confidence:** 78%

**Complexity:** Medium

**Status:** Unexplored

---

### 6. Payload size pipeline (gzip/brotli, asset diet)

**Description:** Enable host **compression** for `.wasm` / `.pck`; optionally add a **Web-only** feature tag or export preset options that reduce **texture sizes**, **MSAA**, shadow quality. Monitor total download size for mobile data.

**Rationale:** First-load time dominates perceived “does it work”; official docs emphasize compression.

**Downsides:** Visual downgrade vs desktop; needs discipline to avoid divergent art paths.

**Confidence:** 75%

**Complexity:** Medium

**Status:** Unexplored

---

## Rejection summary

| Idea | Reason rejected |
|------|------------------|
| Full rewrite (Three.js / Babylon) | Collapses Godot investment; huge scope vs shipping web export |
| Host WASM only on itch.io / R2 | Valid fallback for **size**, not required to satisfy “browser”; defer |
| PWA-only COOP simulation | Useful fallback when headers unavailable; secondary to explicit `vercel.json` headers |
| “Enable threads for perf” by default | Often breaks Safari/hosting until COOP/COEP proven — keep single-thread until measured need |

---

## Agent cost note

Full `ce-ideate` multi-agent fan-out was **streamlined** here: one **web-research** pass plus repo scan (~**2** agent-equivalent steps). For exhaustive parallel ideation, say **raise the bar** or **go deep** on the next run.

# Tech stack

| Piece | Choice | Notes |
|-------|--------|------|
| Engine | **Godot 4.3+** | Scene-based template fork, GDScript, open-source |
| Language | **GDScript** | Matches rapid iteration for vertical slice |
| Alternatives considered | **Unity** | Strong asset pipeline; heavier install for contributors |

World templates ship as JSON under `worlds/templates/` so designers can diff biome layouts without re-exporting scenes.

## Web export (HTML5)

- **Preset:** `export_presets.cfg` — preset name **`Web`**, export path **`dist/web/index.html`**, **thread support off** (no SharedArrayBuffer / COOP/COEP by default).
- **Renderer:** Web builds use **Compatibility** (WebGL 2); Forward+/Mobile are not supported in browser ([Godot docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html)).
- **CI / Vercel:** `scripts/export-web.sh` downloads **`Godot_v4.3-stable_*`** and **`export_templates.tpz`** from the **`4.3-stable`** GitHub release, installs templates under `~/.local/share/godot/export_templates/<version>/`, runs `godot --headless --export-release "Web"`.
- **Pin:** `scripts/godot-version.env` — bump **`GODOT_VERSION`** / **`GODOT_RELEASE_CHANNEL`** together when upgrading.

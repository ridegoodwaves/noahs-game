# Tech stack

| Piece | Choice | Notes |
|-------|--------|------|
| Engine | **Godot 4.3+** | Scene-based template fork, GDScript, open-source |
| Language | **GDScript** | Matches rapid iteration for vertical slice |
| Alternatives considered | **Unity** | Strong asset pipeline; heavier install for contributors |

World templates ship as JSON under `worlds/templates/` so designers can diff biome layouts without re-exporting scenes.

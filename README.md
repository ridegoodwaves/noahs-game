# Noah's Game

Creative **LEGO-like** sandbox **vertical slice** (solo): seven biome templates, forked saves, gallery visits, place/break blocks, **TNT** that only removes **voxels**, optional **food buffs**, **wealth tier** + **instruction shop** backed by `resources/instructions/catalog.json`.

## Prerequisites

- [Godot **4.3+**](https://godotengine.org/download) on your PATH as `godot` or `godot4`.

## Run

```bash
godot --path .
```

Or open **`project.godot`** in the Godot editor and press **F5**. Main scene: `scenes/ui/main_menu.tscn`.

### Controls (in-game)

| Input | Action |
|-------|--------|
| WASD | Move |
| Space | Jump |
| Mouse | Look (capture on play; **Esc** frees cursor) |
| LMB | Break block |
| RMB | Place dirt block (uses inventory) |
| T | Place TNT (explodes after ~1s; blocks only) |
| F | Snack (speed buff) |
| M | Main menu |

### Flow

1. **Main menu** — pick a biome, **New game (fork)** or **Visit gallery** (read-only template).
2. **Fork save** — autosaves to `user://saves/slot_default.json` every ~2s (not in gallery mode).
3. **Settings** — poor / average / rich tier (owned instructions + studs kept).
4. **Shop** — buy instruction entries; tier gates catalog rows.

## Tests

Headless catalog/tier sanity (requires Godot):

```bash
godot --headless --path . -s tests/test_shop_tier_rules.gd
```

## Docs

- Plan: `docs/plans/2026-05-02-001-feat-lego-sandbox-vertical-slice-plan.md`
- Requirements: `docs/brainstorms/lego-creative-worlds-game-requirements.md`
- Stack: `docs/tech-stack.md`
- TNT QA notes: `docs/verification/tnt-entity-safety.md`

## License

See repository root (add `LICENSE` when you choose one).

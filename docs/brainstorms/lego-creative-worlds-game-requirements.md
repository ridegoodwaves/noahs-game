---
date: 2026-05-02
topic: lego-creative-worlds-game
---

# Creative LEGO-like Worlds Game — Requirements Brief

## Problem Frame

Players want a **calm, creative sandbox** that feels like having **every LEGO piece**, making **cool builds** and **their own worlds**, while **exploring fixed showcase worlds**, **collecting pieces**, and optionally following **purchasable build instructions** — **without combat against creatures** or **lethal consequences** from destructive tools.

---

## Requirements

**Worlds and templates**

- R1. The game offers **seven premade worlds** (visit anytime as pristine originals): **forest**, **underwater**, **mountains**, **desert**, **cave**, **city**, **rural town**.
- R2. When **creating a new player world**, the player **chooses one premade world as the starting template**; that save is a **fork**, not a destructive edit to the original.
- R3. The **seven originals remain unchanged** and remain **playable as clean gallery visits** separate from forked saves.

**Conflict and destruction**

- R4. There is **no killing** (player cannot kill creatures or characters).
- R5. The player **may break** blocks / terrain / props as part of creative play.
- R6. **TNT** (or equivalent) affects **blocks and destructible environment only** — **not** the player avatar **nor** animals/creatures.

**Food and pacing**

- R7. **Eating** provides **optional bonus perks** (e.g. speed, glow, faster build); the player is **never punished** for not eating (no forced hunger / starvation loop).

**Progression and economy**

- R8. The player **collects pieces** over time.
- R9. The player can **purchase in-game instructions** for **guided builds of specific worlds**; **wealth tier** affects which instruction options are available or how purchase rules apply (exact storefront rules TBD in planning).
- R10. At character creation, the player sets **wealth tier**: **poor**, **average**, or **rich** (gates starting materials / instruction access per design intent).
- R11. The player may **change wealth tier in settings** at any time; **already earned builds, collected pieces, and purchased instructions are retained** — only **future** unlocks and purchase behavior follow the new tier.

**Session shape**

- R12. **Solo play** is in scope for the **first** delivery; **multiplayer** is **explicitly optional / later** (not required for v1).
- R13. The player **creates a character**; **full customization exists beyond** the default starter look.

**Starter avatar**

- R14. **Default starter appearance**: **red shirt**, **blue pants**, **two dot eyes**, **soft closed smile** (no teeth visible); this is the **classic default before** broader customization options.

---

## Success Criteria

- A reader can explain **how premade worlds, forks, and pristine originals** relate without ambiguity.
- Destruction rules are clear: **environment breaks; living things do not take harm** from TNT or comparable tools.
- The **wealth tier** and **instruction purchase** model can be implemented without inventing “what players wanted” from scratch.

---

## Scope Boundaries

- **Non-goals for this brief:** Specific engine, monetization beyond “purchase instructions” framing, exact UI for world pick / settings, detailed perk tables for food.
- **Deferred:** Multiplayer, voice chat, narrative campaign length, exact currency names and instruction catalog.
- **Outside identity (for this concept):** Combat-focused gameplay, permadeath tied to creatures, gore, or lethal player-vs-creature loops.

---

## Key Decisions

| Decision | Choice |
|----------|--------|
| Premade count & themes | Seven: forest, underwater, mountains, desert, cave, city, rural town |
| New world creation | Start from **one chosen premade** as template |
| Originals vs saves | **Fork model** — originals stay pristine |
| Violence | No killing; breaking allowed; TNT **environment-only** harm |
| Food | **Bonuses only**, no punishment |
| Wealth tier | Set at start; **changeable in settings**; **inventory of earned stuff retained** on change |
| Instructions | **Purchasable**; tier affects options |
| Mode | **Solo first**; multiplayer later |
| Default avatar | Red shirt, blue pants, dot eyes, soft smile; **starter** before full customization |

---

## Dependencies / Assumptions

- **Assumption:** “Instructions” are a **player-positive** guidance product (step-by-step or in-game blueprint), not mandatory to enjoy sandbox play.
- **Assumption:** Creature safety alongside **block destruction** is technically feasible in-engine (e.g. creatures not damaged by area effects that damage voxels).

---

## Outstanding Questions

- Exact rules for **which instructions** each wealth tier can buy first-run vs after progression.
- Whether **multiplayer** shares the same fork model or only visits friends’ forked worlds (when tackled).

---

## Next Steps

- Run **`/ce-plan`** (or equivalent) when ready to break down **systems**: saves/forks, inventory, shop/instructions, avatar customization pipeline, and world catalog.
- Prototype **one biome fork + TNT + creature non-damage** early to validate feel.

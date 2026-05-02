# Graphics / Web export smoke checklist

Quick manual pass before tagging a release that touches rendering or export.

1. **Desktop run:** Start from main menu → fork a biome → place/break blocks; studs render on bricks; glass blocks show transparency (see-through ordering may vary by angle).
2. **Biome identity:** Load gallery or fork once per biome (forest, underwater, mountains, desert, cave, city, rural town) — ambient tint and underwater fog should read clearly different at first glance.
3. **Web build:** Run `npm run build` (or `bash scripts/export-web.sh`), open `dist/web/index.html` via a local static server — scene loads, mouse look works, FPS acceptable on a typical laptop.
4. **Regression:** TNT removes blocks only; inventory counts match after place/break; save slot restores blocks and player position.

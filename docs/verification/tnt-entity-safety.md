# TNT and creature safety (manual QA)

Explosions only modify **block voxels** via `BlockWorld.explode_sphere`. The player (`PlayerController`, group `player`) and gallery creature (`TestCreature`, group `creature`) use **CharacterBody3D** on **physics layer 2** and are **not** referenced by the explosion path.

**In-editor checks**

1. Place blocks and **T** to arm TNT; wait for detonation.
2. Stand inside blast radius — **HP / position**: player should remain controllable; no damage pipeline exists.
3. Stand **TestCreature** inside radius — mesh remains; no removal.

**Note:** This slice does not implement HP; “no damage” means **no gameplay reaction** and **no removal** of entities.

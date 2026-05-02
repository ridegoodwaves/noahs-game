extends SceneTree

## Headless sanity checks for catalog / tier rules. Run with:
##   godot --headless --path . -s tests/test_shop_tier_rules.gd

func _init() -> void:
	var catalog := InstructionCatalog.load_catalog("res://resources/instructions/catalog.json")
	assert(catalog.size() >= 1)
	var entry: Dictionary = catalog[0]
	var flags := {}
	assert(InstructionCatalog.can_purchase(entry, 0, flags) or InstructionCatalog.can_purchase(entry, 2, flags))
	var locked := {"id": "x", "price": 1, "min_wealth_tier": 2}
	assert(not InstructionCatalog.can_purchase(locked, 0, flags))
	print("test_shop_tier_rules: OK")
	quit(0)

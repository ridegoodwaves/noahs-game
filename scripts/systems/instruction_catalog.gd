extends RefCounted
class_name InstructionCatalog


static func load_catalog(path: String = "res://resources/instructions/catalog.json") -> Array:
	if not FileAccess.file_exists(path):
		return []
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return []
	var j := JSON.new()
	if j.parse(f.get_as_text()) != OK:
		return []
	var data: Variant = j.get_data()
	if data is Array:
		return data as Array
	return []


static func can_purchase(entry: Dictionary, tier: PlayerProfile.WealthTier, progression_flags: Dictionary) -> bool:
	var min_t := int(entry.get("min_wealth_tier", 0))
	var req_flag := str(entry.get("requires_flag", ""))
	var tier_ok := int(tier) >= min_t
	var flag_ok := true
	if req_flag != "":
		flag_ok = bool(progression_flags.get(req_flag, false))
	return tier_ok or flag_ok


static func visible_in_shop(entry: Dictionary, tier: PlayerProfile.WealthTier, progression_flags: Dictionary) -> bool:
	return can_purchase(entry, tier, progression_flags)

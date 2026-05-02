extends Node

enum WealthTier { POOR = 0, AVERAGE = 1, RICH = 2 }

signal wealth_tier_changed(new_tier: WealthTier)

const SETTINGS_PATH := "user://settings.cfg"

var wealth_tier: WealthTier = WealthTier.AVERAGE
var owned_instruction_ids: PackedStringArray = []
var studs: int = 0


func _ready() -> void:
	_load_settings()


func set_wealth_tier(tier: WealthTier) -> void:
	if wealth_tier == tier:
		return
	wealth_tier = tier
	_save_settings()
	wealth_tier_changed.emit(tier)


func own_instruction(id: String) -> void:
	if id in owned_instruction_ids:
		return
	owned_instruction_ids.append(id)
	_save_settings()


func has_instruction(id: String) -> bool:
	return id in owned_instruction_ids


func add_studs(amount: int) -> void:
	studs += maxi(0, amount)
	_save_settings()


func spend_studs(amount: int) -> bool:
	if studs < amount:
		return false
	studs -= amount
	_save_settings()
	return true

func _load_settings() -> void:
	var cf := ConfigFile.new()
	var err := cf.load(SETTINGS_PATH)
	if err != OK:
		studs = 40
		return
	wealth_tier = cf.get_value("profile", "wealth_tier", WealthTier.AVERAGE) as int
	studs = int(cf.get_value("profile", "studs", 0))
	var owned: Variant = cf.get_value("profile", "owned_instructions", [])
	if owned is Array:
		owned_instruction_ids.clear()
		for x in owned:
			if x is String:
				owned_instruction_ids.append(x)


func _save_settings() -> void:
	var cf := ConfigFile.new()
	cf.set_value("profile", "wealth_tier", wealth_tier)
	cf.set_value("profile", "studs", studs)
	var arr: Array = []
	for id in owned_instruction_ids:
		arr.append(id)
	cf.set_value("profile", "owned_instructions", arr)
	cf.save(SETTINGS_PATH)

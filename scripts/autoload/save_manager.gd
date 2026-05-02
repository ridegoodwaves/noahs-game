extends Node

const SAVES_DIR := "user://saves"

signal save_failed(reason: String)
signal save_loaded(slot_id: String)


func ensure_saves_dir() -> void:
	var err := DirAccess.make_dir_recursive_absolute(OS.get_user_data_dir() + "/saves")
	if err != OK and err != ERR_ALREADY_EXISTS:
		push_warning("SaveManager: could not create saves dir: ", err)


func template_path_for_biome(biome: GameFlow.BiomeId) -> String:
	return "res://worlds/templates/%s.json" % GameFlow.BIOME_NAMES[biome]


func load_template_state(biome: GameFlow.BiomeId) -> Dictionary:
	var path := template_path_for_biome(biome)
	if not FileAccess.file_exists(path):
		return _default_state(biome)
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return _default_state(biome)
	var text := f.get_as_text()
	var j := JSON.new()
	var err := j.parse(text)
	if err != OK:
		return _default_state(biome)
	var data: Variant = j.get_data()
	if data is Dictionary:
		return (data as Dictionary).duplicate(true)
	return _default_state(biome)


func _default_state(biome: GameFlow.BiomeId) -> Dictionary:
	return {
		"version": 1,
		"biome": GameFlow.BIOME_NAMES[biome],
		"blocks": {},
		"inventory": {"0": 0, "1": 0, "2": 0},
		"studs": 0,
		"player": {"x": 0.0, "y": 2.0, "z": 0.0},
	}


func new_game_from_template(biome: GameFlow.BiomeId) -> Dictionary:
	## Returns a deep copy of template data for a new forked world (does not write res://).
	return load_template_state(biome).duplicate(true)


func save_path_for_slot(slot_id: String) -> String:
	return SAVES_DIR.path_join("slot_%s.json" % slot_id)


func write_save(slot_id: String, state: Dictionary) -> bool:
	ensure_saves_dir()
	var path := save_path_for_slot(slot_id)
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		save_failed.emit("Cannot open for write: " + path)
		return false
	f.store_string(JSON.stringify(state, "  "))
	return true


func read_save(slot_id: String) -> Dictionary:
	var path := save_path_for_slot(slot_id)
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var text := f.get_as_text()
	var j := JSON.new()
	if j.parse(text) != OK:
		save_failed.emit("Corrupt save JSON")
		return {}
	var data: Variant = j.get_data()
	if data is Dictionary:
		save_loaded.emit(slot_id)
		return (data as Dictionary).duplicate(true)
	return {}

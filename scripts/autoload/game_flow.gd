extends Node

var pending_biome: BiomeId = BiomeId.FOREST
var gallery_mode: bool = false

const PLAY_SCENE := "res://scenes/play_world.tscn"
const MENU_SCENE := "res://scenes/ui/main_menu.tscn"

enum BiomeId {
	FOREST,
	UNDERWATER,
	MOUNTAINS,
	DESERT,
	CAVE,
	CITY,
	RURAL_TOWN,
}

const BIOME_NAMES: Dictionary = {
	BiomeId.FOREST: "forest",
	BiomeId.UNDERWATER: "underwater",
	BiomeId.MOUNTAINS: "mountains",
	BiomeId.DESERT: "desert",
	BiomeId.CAVE: "cave",
	BiomeId.CITY: "city",
	BiomeId.RURAL_TOWN: "rural_town",
}


func biome_name(id: BiomeId) -> String:
	return BIOME_NAMES.get(id, "unknown")


func biome_from_name(s: String) -> BiomeId:
	for k in BIOME_NAMES:
		if BIOME_NAMES[k] == s:
			return k
	return BiomeId.FOREST


func go_main_menu() -> void:
	get_tree().change_scene_to_file(MENU_SCENE)


func start_fork(biome: BiomeId) -> void:
	pending_biome = biome
	gallery_mode = false
	get_tree().change_scene_to_file(PLAY_SCENE)


func visit_gallery(biome: BiomeId) -> void:
	pending_biome = biome
	gallery_mode = true
	get_tree().change_scene_to_file(PLAY_SCENE)

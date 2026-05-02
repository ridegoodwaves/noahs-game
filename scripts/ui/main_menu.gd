extends Control


func _ready() -> void:
	var biome_list: ItemList = $VBox/BiomeList
	var order := [
		GameFlow.BiomeId.FOREST,
		GameFlow.BiomeId.UNDERWATER,
		GameFlow.BiomeId.MOUNTAINS,
		GameFlow.BiomeId.DESERT,
		GameFlow.BiomeId.CAVE,
		GameFlow.BiomeId.CITY,
		GameFlow.BiomeId.RURAL_TOWN,
	]
	for biome in order:
		var name := GameFlow.biome_name(biome)
		biome_list.add_item(name.capitalize() + " (%s)" % name)
	biome_list.select(0)


func _on_fork_pressed() -> void:
	var biome_list: ItemList = $VBox/BiomeList
	var idx := biome_list.get_selected_items()
	if idx.is_empty():
		return
	var biome := GameFlow.biome_from_name(_selected_biome_name(idx[0]))
	GameFlow.start_fork(biome)


func _on_gallery_pressed() -> void:
	var biome_list: ItemList = $VBox/BiomeList
	var idx := biome_list.get_selected_items()
	if idx.is_empty():
		return
	var biome := GameFlow.biome_from_name(_selected_biome_name(idx[0]))
	GameFlow.visit_gallery(biome)


func _selected_biome_name(row: int) -> String:
	var biome_list: ItemList = $VBox/BiomeList
	var text := str(biome_list.get_item_text(row))
	var parts := text.split(" (")
	if parts.size() >= 2:
		return parts[1].trim_suffix(")")
	return "forest"


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")


func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/shop_ui.tscn")

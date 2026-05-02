extends Control


func _ready() -> void:
	_refresh()


func _refresh() -> void:
	var list: ItemList = $VBox/Catalog as ItemList
	list.clear()
	var catalog := InstructionCatalog.load_catalog()
	var tier := PlayerProfile.wealth_tier
	var flags := {}
	for entry in catalog:
		if entry is Dictionary:
			var d := entry as Dictionary
			var id := str(d.get("id", ""))
			var title := str(d.get("title", id))
			var price := int(d.get("price", 0))
			var buy := InstructionCatalog.can_purchase(d, tier, flags)
			var owned := PlayerProfile.has_instruction(id)
			var suffix := " [owned]" if owned else (" (%d studs)" % price if buy else " [locked]")
			list.add_item(title + suffix)


func _on_buy_pressed() -> void:
	var list: ItemList = $VBox/Catalog as ItemList
	var idx := list.get_selected_items()
	if idx.is_empty():
		return
	var selected_idx := idx[0]
	var catalog := InstructionCatalog.load_catalog()
	if selected_idx < 0 or selected_idx >= catalog.size():
		return
	var entry: Variant = catalog[selected_idx]
	if entry is Dictionary:
		if ShopSystem.try_purchase(entry as Dictionary, PlayerProfile):
			pass
	_refresh()


func _on_back_pressed() -> void:
	GameFlow.go_main_menu()

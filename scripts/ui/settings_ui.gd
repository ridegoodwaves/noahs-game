extends Control


func _ready() -> void:
	var opts := $VBox/TierOption as OptionButton
	opts.clear()
	opts.add_item("Poor", PlayerProfile.WealthTier.POOR)
	opts.add_item("Average", PlayerProfile.WealthTier.AVERAGE)
	opts.add_item("Rich", PlayerProfile.WealthTier.RICH)
	for i in range(opts.item_count):
		if opts.get_item_id(i) == PlayerProfile.wealth_tier:
			opts.select(i)
			break


func _on_apply_pressed() -> void:
	var opts := $VBox/TierOption as OptionButton
	var tier: PlayerProfile.WealthTier = opts.get_selected_id()
	PlayerProfile.set_wealth_tier(tier)
	GameFlow.go_main_menu()


func _on_back_pressed() -> void:
	GameFlow.go_main_menu()

extends Node
## Registers default input actions if missing (avoids hand-editing binary InputEvents in project.godot).


func _ready() -> void:
	_add_key_action("move_forward", KEY_W)
	_add_key_action("move_back", KEY_S)
	_add_key_action("move_left", KEY_A)
	_add_key_action("move_right", KEY_D)
	_add_key_action("jump", KEY_SPACE)
	_add_mouse_action("break_block", MOUSE_BUTTON_LEFT)
	_add_mouse_action("place_block", MOUSE_BUTTON_RIGHT)
	_add_key_action("place_tnt", KEY_T)
	_add_key_action("open_menu", KEY_M)


func _add_key_action(action: String, keycode: Key) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	var ev := InputEventKey.new()
	ev.physical_keycode = keycode
	InputMap.action_add_event(action, ev)


func _add_mouse_action(action: String, button: MouseButton) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	var ev := InputEventMouseButton.new()
	ev.button_index = button
	InputMap.action_add_event(action, ev)

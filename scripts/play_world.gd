extends Node3D
## Play session: voxel grid, player, TNT (environment-only), autosave, HUD.

var block_world: BlockWorld = BlockWorld.new()
var inventory := Inventory.new()

var _slot_id := "default"
var _biome: GameFlow.BiomeId = GameFlow.BiomeId.FOREST
var _gallery := false

var _save_accum := 0.0

@onready var _player: PlayerController = $Player
@onready var _blocks_root: Node3D = $BlocksRoot
@onready var _creature: Node3D = $TestCreature
@onready var _hud: CanvasLayer = $HUD

var _multimesh_instance: MultiMeshInstance3D


func _ready() -> void:
	_biome = GameFlow.pending_biome
	_gallery = GameFlow.gallery_mode
	_load_world_state()
	if _creature:
		_creature.global_position = Vector3(3, 1, 3)
		_creature.add_to_group("creature")
	_setup_multimesh()
	_player.global_position = _read_player_spawn()
	_rebuild_blocks_visual()


func _load_world_state() -> void:
	var state: Dictionary
	if _gallery:
		state = SaveManager.load_template_state(_biome)
	else:
		state = SaveManager.read_save(_slot_id)
		if state.is_empty():
			state = SaveManager.new_game_from_template(_biome)
	_apply_state(state)


func _apply_state(state: Dictionary) -> void:
	var blocks: Variant = state.get("blocks", {})
	if blocks is Dictionary:
		block_world.load_from_serializable(blocks)
	var inv: Variant = state.get("inventory", {})
	if inv is Dictionary:
		inventory = Inventory.new(inv)


func _serialize_state() -> Dictionary:
	return {
		"version": 1,
		"biome": GameFlow.biome_name(_biome),
		"blocks": block_world.to_serializable(),
		"inventory": inventory.to_serializable(),
		"player": {
			"x": _player.global_position.x,
			"y": _player.global_position.y,
			"z": _player.global_position.z,
		},
	}


func _read_player_spawn() -> Vector3:
	if _gallery:
		return Vector3(0, 2, 4)
	var state := SaveManager.read_save(_slot_id)
	if state.is_empty():
		return Vector3(0, 2, 4)
	var p: Variant = state.get("player", {})
	if p is Dictionary:
		return Vector3(float(p.get("x", 0)), float(p.get("y", 2)), float(p.get("z", 4)))
	return Vector3(0, 2, 4)


func _setup_multimesh() -> void:
	var cube := BoxMesh.new()
	cube.size = Vector3.ONE * BlockWorld.CELL_SIZE * 0.98
	_multimesh_instance = MultiMeshInstance3D.new()
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = cube
	_multimesh_instance.multimesh = mm
	_blocks_root.add_child(_multimesh_instance)


func _biome_base_color() -> Color:
	match _biome:
		GameFlow.BiomeId.FOREST:
			return Color(0.22, 0.46, 0.22)
		GameFlow.BiomeId.UNDERWATER:
			return Color(0.25, 0.55, 0.72)
		GameFlow.BiomeId.MOUNTAINS:
			return Color(0.55, 0.55, 0.58)
		GameFlow.BiomeId.DESERT:
			return Color(0.85, 0.72, 0.45)
		GameFlow.BiomeId.CAVE:
			return Color(0.35, 0.28, 0.22)
		GameFlow.BiomeId.CITY:
			return Color(0.45, 0.45, 0.48)
		GameFlow.BiomeId.RURAL_TOWN:
			return Color(0.55, 0.62, 0.42)
	return Color(0.5, 0.5, 0.5)


func _rebuild_blocks_visual() -> void:
	var cells := block_world.all_cells()
	var mm := _multimesh_instance.multimesh
	mm.instance_count = cells.size()
	for i in range(cells.size()):
		var c: Vector3i = cells[i]
		var xf := Transform3D(Basis(), Vector3(c) + Vector3.ONE * 0.5 * BlockWorld.CELL_SIZE)
		mm.set_instance_transform(i, xf)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = _biome_base_color()
	_multimesh_instance.material_override = mat


func _process(delta: float) -> void:
	_save_accum += delta
	if not _gallery and _save_accum >= 2.0:
		_save_accum = 0.0
		SaveManager.write_save(_slot_id, _serialize_state())
	_update_hud()


func _update_hud() -> void:
	if _hud == null:
		return
	var l: Label = _hud.get_node_or_null("VBox/Status") as Label
	if l == null:
		return
	var tier_names: PackedStringArray = ["poor", "average", "rich"]
	var tier: String = tier_names[clampi(PlayerProfile.wealth_tier, 0, 2)]
	l.text = "Biome: %s | Mode: %s\nStuds: %s | Blocks (dirt/brick/glass): %d/%d/%d\nTier: %s | Move speed x%.2f\nLMB break | RMB place (dirt) | T TNT | F snack | M menu | Esc mouse" % [
		GameFlow.biome_name(_biome),
		"gallery" if _gallery else "fork save",
		str(PlayerProfile.studs),
		inventory.get_count(0), inventory.get_count(1), inventory.get_count(2),
		tier,
		_player.food_buffs.speed_multiplier,
	]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_menu"):
		GameFlow.go_main_menu()
		return
	if _gallery:
		return
	if event.is_action_pressed("break_block"):
		_try_break()
	if event.is_action_pressed("place_block"):
		_try_place(0)
	if event.is_action_pressed("place_tnt"):
		_try_place_tnt()
	if event.is_action_pressed("eat_food"):
		_player.eat_snack()


func _camera_ray() -> Dictionary:
	return _player.camera_ray()


func _try_break() -> void:
	var ray: Dictionary = _camera_ray()
	var hit := block_world.ray_cast_blocks(ray.origin, ray.normal, 14.0)
	if not hit.get("hit", false):
		return
	var cell: Vector3i = hit.break_cell
	var t := block_world.get_block(cell)
	block_world.set_block(cell, -1)
	inventory.add(t, 1)
	PlayerProfile.add_studs(1)
	_rebuild_blocks_visual()


func _try_place(block_type: int) -> void:
	var ray: Dictionary = _camera_ray()
	var hit := block_world.ray_cast_blocks(ray.origin, ray.normal, 14.0)
	if not hit.get("hit", false):
		return
	var place_cell: Vector3i = hit.place_cell
	if block_world.has_block(place_cell):
		return
	if not inventory.remove(block_type, 1):
		return
	block_world.set_block(place_cell, block_type)
	_rebuild_blocks_visual()


func _try_place_tnt() -> void:
	var ray: Dictionary = _camera_ray()
	var hit := block_world.ray_cast_blocks(ray.origin, ray.normal, 14.0)
	if not hit.get("hit", false):
		return
	var place_cell: Vector3i = hit.place_cell
	if block_world.has_block(place_cell):
		return
	var tnt := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.45, 0.45, 0.45)
	tnt.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.9, 0.35, 0.15)
	tnt.material_override = mat
	tnt.global_position = Vector3(place_cell) + Vector3.ONE * 0.5
	add_child(tnt)
	var timer := get_tree().create_timer(1.0)
	timer.timeout.connect(func(): _explode_tnt(tnt))


func _explode_tnt(node: Node3D) -> void:
	if not is_instance_valid(node):
		return
	var center := node.global_position
	var removed := block_world.explode_sphere(center, 3.5)
	for _c in removed:
		PlayerProfile.add_studs(2)
	node.queue_free()
	_rebuild_blocks_visual()

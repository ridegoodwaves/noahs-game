extends CharacterBody3D
class_name PlayerController
## Solo avatar: starter colors red shirt / blue pants (material zones), dot eyes on placeholder head.

const SPEED := 6.0
const JUMP_VELOCITY := 4.5

@export var camera_y_offset := 1.6
@export var camera_distance := 4.0

var food_buffs: FoodBuffs = FoodBuffs.new()

@onready var _camera: Camera3D = $CameraPivot/Camera3D
@onready var _pivot: Node3D = $CameraPivot


func _ready() -> void:
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * 0.003)
		_pivot.rotate_x(-event.relative.y * 0.003)
		_pivot.rotation.x = clampf(_pivot.rotation.x, -1.2, 1.2)
	if event.is_action_pressed("pause_menu"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	food_buffs.process_delta(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var spd := SPEED * food_buffs.speed_multiplier
	if direction:
		velocity.x = direction.x * spd
		velocity.z = direction.z * spd
	else:
		velocity.x = move_toward(velocity.x, 0, spd)
		velocity.z = move_toward(velocity.z, 0, spd)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	move_and_slide()


func camera_ray() -> Dictionary:
	var viewport := get_viewport()
	var center := viewport.get_visible_rect().get_center()
	return {
		"origin": _camera.project_ray_origin(center),
		"normal": _camera.project_ray_normal(center),
	}


func eat_snack() -> void:
	food_buffs.consume_snack(8.0, 1.25, 0.5)

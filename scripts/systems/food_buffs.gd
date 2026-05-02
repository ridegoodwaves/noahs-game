extends RefCounted
class_name FoodBuffs

var speed_multiplier: float = 1.0
var build_speed_bonus: float = 0.0
var _timer: float = 0.0


func consume_snack(duration_sec: float, speed_mult: float = 1.25, build_bonus: float = 0.5) -> void:
	speed_multiplier = speed_mult
	build_speed_bonus = build_bonus
	_timer = duration_sec


func process_delta(delta: float) -> void:
	if _timer <= 0.0:
		return
	_timer -= delta
	if _timer <= 0.0:
		speed_multiplier = 1.0
		build_speed_bonus = 0.0

extends RefCounted
class_name Inventory

## Piece counts keyed by block type id (string keys for JSON stability).

var counts: Dictionary = {}


func _init(initial: Dictionary = {}) -> void:
	counts.clear()
	for k in initial.keys():
		counts[str(k)] = int(initial[k])


func add(kind: int, amount: int = 1) -> void:
	var key := str(kind)
	counts[key] = int(counts.get(key, 0)) + amount


func remove(kind: int, amount: int = 1) -> bool:
	var key := str(kind)
	var n := int(counts.get(key, 0))
	if n < amount:
		return false
	counts[key] = n - amount
	if counts[key] <= 0:
		counts.erase(key)
	return true


func get_count(kind: int) -> int:
	return int(counts.get(str(kind), 0))


func to_serializable() -> Dictionary:
	return counts.duplicate(true)


func load_from_serializable(data: Dictionary) -> void:
	counts.clear()
	for k in data.keys():
		counts[str(k)] = int(data[k])

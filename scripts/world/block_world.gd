extends RefCounted
class_name BlockWorld

## Finite grid of cubic blocks in integer coordinates. Single authority for mutations.

const CELL_SIZE := 1.0

var blocks: Dictionary = {} ## Vector3i serialized as "x,y,z" -> block_type (int)


func cell_key(cell: Vector3i) -> String:
	return "%d,%d,%d" % [cell.x, cell.y, cell.z]


func key_to_cell(key: String) -> Vector3i:
	var p := key.split(",")
	if p.size() != 3:
		return Vector3i.ZERO
	return Vector3i(int(p[0]), int(p[1]), int(p[2]))


func get_block(cell: Vector3i) -> int:
	var k := cell_key(cell)
	return blocks.get(k, -1)


func set_block(cell: Vector3i, block_type: int) -> void:
	var k := cell_key(cell)
	if block_type < 0:
		blocks.erase(k)
	else:
		blocks[k] = block_type


func has_block(cell: Vector3i) -> bool:
	return cell_key(cell) in blocks


func all_cells() -> Array:
	var out: Array = []
	for k in blocks.keys():
		out.append(key_to_cell(k))
	return out


func to_serializable() -> Dictionary:
	return blocks.duplicate(true)


func load_from_serializable(data: Dictionary) -> void:
	blocks.clear()
	for k in data.keys():
		blocks[k] = data[k]


func explode_sphere(center: Vector3, radius: float) -> Array[Vector3i]:
	var removed: Array[Vector3i] = []
	var r_cells := int(ceil(radius / CELL_SIZE)) + 1
	var ci := Vector3i(int(floor(center.x)), int(floor(center.y)), int(floor(center.z)))
	for dx in range(-r_cells, r_cells + 1):
		for dy in range(-r_cells, r_cells + 1):
			for dz in range(-r_cells, r_cells + 1):
				var cell := ci + Vector3i(dx, dy, dz)
				var wp := Vector3(cell) + Vector3.ONE * 0.5 * CELL_SIZE
				if wp.distance_to(center) <= radius and has_block(cell):
					removed.append(cell)
					set_block(cell, -1)
	return removed


func ray_cast_blocks(origin: Vector3, dir: Vector3, max_distance: float) -> Dictionary:
	dir = dir.normalized()
	var step := 0.04
	var t := 0.0
	var prev_empty: Variant = null
	while t < max_distance:
		var p := origin + dir * t
		var cell := Vector3i(int(floor(p.x)), int(floor(p.y)), int(floor(p.z)))
		if has_block(cell):
			var place_cell: Vector3i = cell
			if prev_empty != null:
				place_cell = prev_empty as Vector3i
			else:
				## Camera inside block — step outward against ray.
				place_cell = cell + Vector3i(
					-signi(dir.x) if absf(dir.x) > 0.01 else 0,
					-signi(dir.y) if absf(dir.y) > 0.01 else 0,
					-signi(dir.z) if absf(dir.z) > 0.01 else 0,
				)
			return {"hit": true, "break_cell": cell, "place_cell": place_cell}
		prev_empty = cell
		t += step
	return {"hit": false}


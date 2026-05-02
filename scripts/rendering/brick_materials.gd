extends RefCounted
class_name BrickMaterials
## Plastic toy palette per logical block type (0 dirt, 1 brick, 2 glass).


static func make_opaque_dirt(biome_accent: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0.52, 0.38, 0.22).lerp(biome_accent, 0.22)
	m.roughness = 0.55
	m.metallic = 0.0
	m.specular = 0.55
	m.clearcoat_enabled = true
	m.clearcoat = 0.12
	m.clearcoat_roughness = 0.35
	return m


static func make_opaque_brick(biome_accent: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0.82, 0.28, 0.22).lerp(biome_accent, 0.12)
	m.roughness = 0.42
	m.metallic = 0.0
	m.specular = 0.65
	m.clearcoat_enabled = true
	m.clearcoat = 0.25
	m.clearcoat_roughness = 0.28
	return m


static func make_glass(biome_accent: Color) -> ShaderMaterial:
	var sh := load("res://resources/shaders/stylized_glass.gdshader") as Shader
	var m := ShaderMaterial.new()
	m.shader = sh
	m.set_shader_parameter("base_color", Color(0.55, 0.78, 0.92, 1.0).lerp(biome_accent, 0.18))
	m.set_shader_parameter("alpha", 0.42)
	m.set_shader_parameter("fresnel_power", 3.2)
	return m


static func biome_accent(biome: GameFlow.BiomeId) -> Color:
	match biome:
		GameFlow.BiomeId.FOREST:
			return Color(0.35, 0.62, 0.38)
		GameFlow.BiomeId.UNDERWATER:
			return Color(0.28, 0.55, 0.72)
		GameFlow.BiomeId.MOUNTAINS:
			return Color(0.62, 0.65, 0.72)
		GameFlow.BiomeId.DESERT:
			return Color(0.92, 0.72, 0.42)
		GameFlow.BiomeId.CAVE:
			return Color(0.48, 0.38, 0.32)
		GameFlow.BiomeId.CITY:
			return Color(0.55, 0.58, 0.68)
		GameFlow.BiomeId.RURAL_TOWN:
			return Color(0.42, 0.58, 0.38)
	return Color(0.55, 0.58, 0.62)

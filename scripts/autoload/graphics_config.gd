extends Node
## Desktop vs Web rendering toggles.


func is_web() -> bool:
	return OS.get_name() == "Web"


func tune_environment(env: Environment) -> void:
	if env == null:
		return
	if is_web():
		env.ssao_enabled = false
		env.glow_enabled = false
	else:
		env.ssao_enabled = true
		env.ssao_radius = 1.2
		env.ssao_intensity = 2.0
		env.glow_enabled = true
		env.glow_intensity = 0.32
		env.glow_hdr_threshold = 0.9


func tune_directional_light(light: DirectionalLight3D) -> void:
	if light == null:
		return
	if is_web():
		light.shadow_opacity = 0.85
		light.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
	else:
		light.shadow_enabled = true
		light.light_energy = 1.15
		light.shadow_blur = 1.2


func tune_biome_ambient(env: Environment, biome: GameFlow.BiomeId) -> void:
	if env == null:
		return
	var col := Color(0.78, 0.82, 0.9)
	var energy := 0.38
	match biome:
		GameFlow.BiomeId.FOREST:
			col = Color(0.72, 0.82, 0.68)
			energy = 0.36
		GameFlow.BiomeId.UNDERWATER:
			col = Color(0.42, 0.62, 0.82)
			energy = 0.52
		GameFlow.BiomeId.MOUNTAINS:
			col = Color(0.74, 0.78, 0.86)
			energy = 0.36
		GameFlow.BiomeId.DESERT:
			col = Color(0.95, 0.88, 0.72)
			energy = 0.45
		GameFlow.BiomeId.CAVE:
			col = Color(0.38, 0.36, 0.42)
			energy = 0.26
		GameFlow.BiomeId.CITY:
			col = Color(0.78, 0.8, 0.88)
			energy = 0.34
		GameFlow.BiomeId.RURAL_TOWN:
			col = Color(0.8, 0.82, 0.72)
			energy = 0.37
	env.ambient_light_color = col
	env.ambient_light_energy = energy
	if biome == GameFlow.BiomeId.UNDERWATER:
		env.fog_enabled = true
		env.fog_mode = Environment.FOG_MODE_EXPONENTIAL
		env.fog_density = 0.022 if is_web() else 0.028
		env.fog_light_color = Color(0.42, 0.62, 0.82)
	else:
		env.fog_enabled = false


func tune_fill_light(light: OmniLight3D) -> void:
	if light == null:
		return
	if is_web():
		light.light_energy = 0.12
		light.omni_range = 26.0
	else:
		light.light_energy = 0.22
		light.omni_range = 42.0


func tune_player_camera(cam: Camera3D) -> void:
	if cam == null:
		return
	if is_web():
		cam.fov = 58.0
	else:
		cam.fov = 52.0

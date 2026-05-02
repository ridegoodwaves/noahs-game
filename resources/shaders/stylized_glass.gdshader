shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 base_color : source_color = vec4(0.55, 0.78, 0.92, 1.0);
uniform float alpha : hint_range(0.0, 1.0) = 0.42;
uniform float fresnel_power = 3.0;

void fragment() {
	vec3 N = normalize(NORMAL);
	vec3 V = normalize(VIEW);
	float fresnel = pow(clamp(1.0 - dot(N, V), 0.0, 1.0), fresnel_power);
	vec3 col = base_color.rgb * (0.72 + 0.28 * fresnel);
	ALBEDO = col;
	ALPHA = alpha + fresnel * (1.0 - alpha) * 0.35;
	ROUGHNESS = mix(0.18, 0.42, fresnel);
	SPECULAR = 0.55;
	METALLIC = 0.0;
}

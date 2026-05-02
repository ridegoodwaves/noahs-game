extends RefCounted
class_name BrickMeshBuilder
## Procedural toy brick: beveled box + four studs for MultiMesh (single draw mesh).


static func build_toy_brick(cell_scale: float = 1.0) -> ArrayMesh:
	var body := BoxMesh.new()
	var s := cell_scale * 0.90
	body.size = Vector3(s, s, s)

	var stud := CylinderMesh.new()
	stud.top_radius = cell_scale * 0.14
	stud.bottom_radius = cell_scale * 0.14
	stud.height = cell_scale * 0.12
	stud.radial_segments = 12

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.append_from(body, 0, Transform3D.IDENTITY)

	var half := s * 0.5
	var y_stud := half + stud.height * 0.5
	var off := cell_scale * 0.28
	var positions := [
		Vector3(-off, y_stud, -off),
		Vector3(off, y_stud, -off),
		Vector3(-off, y_stud, off),
		Vector3(off, y_stud, off),
	]
	for p in positions:
		st.append_from(stud, 0, Transform3D(Basis(), p))

	st.generate_normals()
	st.generate_tangents()
	return st.commit()

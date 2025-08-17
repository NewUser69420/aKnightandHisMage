extends Node

class Aabb:
	var min: Vector2
	var max: Vector2

var room_list: Array[Aabb]

func generate_rooms():
	room_list = []
	
	for i in 5:
		var seed = 696969
		seed(seed)
		
		var random = RandomNumberGenerator.new()
		var rp = getRandomPointInEllipse(50.0, 70, random)
		var size = Vector2(2.5, 2.5)
		
		var aabb = Aabb
		aabb.min = Vector2(rp.x, rp.y)
		aabb.max = aabb.min + size
		room_list.push_back(aabb)
	
	#work room_list
	var mesh = ArrayMesh.new()
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	#fill array's
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

func getRandomPointInEllipse(width: float, height: float, random: RandomNumberGenerator) -> Vector2:
	var t: float = 2.0 * PI * random.randf()
	var u: float = random.randf() + random.randf()
	var r: float
	
	#init r
	if u > 1:
		r = 2.0 - u
	else:
		r = u
	
	var grid_size = 2.5
	var x = round_to_mult(width * r * cos(t) / 2.0, grid_size)
	var y = round_to_mult(height * r * sin(t) / 2.0, grid_size)
	
	return Vector2(x, y)

func round_to_mult(v: float, step: float):
	return round(v / step) * step

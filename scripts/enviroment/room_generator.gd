extends Node

const ROOM_NUM: int = 0
const DISP_SPEED: float = 5.0

var room_list: Array[Aabb]

@onready var grid_map: GridMap = $GridMap

func _ready():
	if multiplayer.is_server():
		generate_rooms()

func generate_rooms():
	if ROOM_NUM <= 0:
		return
	
	room_list = []
	room_list.resize(ROOM_NUM)
	
	var nseed = 696969
	seed(nseed)
	
	var random = RandomNumberGenerator.new()
	var rx: float = random.randf_range(4.0, 20.0)
	var ry: float = random.randf_range(4.0, 20.0)
	var size = Vector2(rx, ry)
	for i in ROOM_NUM:
		var rp = getRandomPointInEllipse(15.0, 25, random)
		
		var amin = Vector2(rp.x, rp.y)
		var amax = amin + size
		var aabb = Aabb.new(amin, amax)
		room_list[i] = aabb
	
	disperse_rooms()
	spawn_rooms(room_list)

func getRandomPointInEllipse(width: float, height: float, random: RandomNumberGenerator) -> Vector2:
	var t: float = 2.0 * PI * random.randf()
	var u: float = random.randf() + random.randf()
	var r: float
	
	#init r
	if u > 1:
		r = 2.0 - u
	else:
		r = u
	
	var x = round_to_mult(width * r * cos(t) / 2.0, grid_map.cell_size.x)
	var y = round_to_mult(height * r * sin(t) / 2.0, grid_map.cell_size.z)
	
	return Vector2(x, y)

func round_to_mult(v: float, step: float):
	return round(v / step) * step

func disperse_rooms():
	var intersection = Intersection.new(0, Vector2(0, 0))
	var intersections: Array[Intersection] = [intersection]
	
	while intersections.size() > 0:
		for intr in intersections:
			room_list[intr.id].move(intr.dir, DISP_SPEED)
		
		intersections.clear()
		
		for id in room_list.size():
			for idd in room_list.size():
				if id == idd:
					break
				var room = room_list[id]
				var room2 = room_list[idd]
				if aabb_coll(room, room2):
					var dir = (room2.min - room.min).normalized()
					intersections.push_back(Intersection.new(idd, dir))

func aabb_coll(a: Aabb, b: Aabb) -> bool:
	return (a.min.x <= b.max.x
		&& a.max.x >= b.min.x
		&& a.min.y <= b.max.y
		&& a.max.y >= b.min.y)

func spawn_rooms(rm_list: Array[Aabb]):
	for room in rm_list:
		var width: int = int(room.max.x - room.min.x)
		var height: int = int(room.max.y - room.min.y)
		for x in width:
			for y in height:
				var x_pos: int = int(room.min.x + x)
				var y_pos: int = int(room.min.y + y)
				var pos = Vector3i(x_pos, 0, y_pos)
				grid_map.set_cell_item(pos, 0)

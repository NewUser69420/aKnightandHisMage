extends Node
class_name Room

@warning_ignore("shadowed_global_identifier")
var min: Vector2
@warning_ignore("shadowed_global_identifier")
var max: Vector2

var kind: RoomKind

enum RoomKind{
	Empty,
	Pillared,
}

func _init(a: Vector2, b: Vector2, c: RoomKind):
	min = a
	max = b
	kind = c

func move(dir: Vector2, speed: float):
	min += dir * speed
	max += dir * speed

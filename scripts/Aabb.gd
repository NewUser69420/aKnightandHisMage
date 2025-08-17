extends Node
class_name Aabb

@warning_ignore("shadowed_global_identifier")
var min: Vector2
@warning_ignore("shadowed_global_identifier")
var max: Vector2

func _init(a: Vector2, b: Vector2):
	min = a
	max = b

func move(dir: Vector2, speed: float):
	min += dir * speed
	max += dir * speed

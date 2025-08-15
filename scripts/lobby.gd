extends Node3D

var player = preload("res://scenes/player.tscn")

func _ready():
	if not multiplayer.is_server():
		return
	
	var character: CharacterBody3D = player.instantiate()
	character.position.x = -2.5
	$Players.add_child(character, true)

extends Node

const MAX_CONNECTIONS: int = 2

var lobby_scene = "res://scenes/lobby.tscn"
var player = preload("res://scenes/player.tscn")

var _players: Node3D
var _room_generator: Node3D

func start_host(port: int):
	print("Starting host on port %s ..." % port)
	
	var server_peer = ENetMultiplayerPeer.new()
	var err = server_peer.create_server(port, MAX_CONNECTIONS)
	if err:
		return err
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	get_tree().change_scene_to_file(lobby_scene)

func start_client(server_ip: String, port: int):
	print("Starting client...")
	
	var client_peer = ENetMultiplayerPeer.new()
	var err = client_peer.create_client(server_ip, port)
	if err:
		return err
	
	multiplayer.multiplayer_peer = client_peer
	
	get_tree().change_scene_to_file(lobby_scene)

func _add_player_to_game(id: int):
	print("Player %s joined the game!" % id)
	
	if _players == null:
		_players = get_tree().get_current_scene().get_node("Players")
	
	if _room_generator == null:
		_room_generator = get_tree().get_current_scene().get_node("Enviroment")
	
	var character: CharacterBody3D = player.instantiate()
	character.player_id = id
	character.position.x = 2.5
	
	_players.add_child(character, true)
	
	var serialized_list: Array = []
	for room in _room_generator.room_list:
		serialized_list.push_back([room.min, room.max])
	load_map.rpc_id(id, serialized_list)

func _del_player(id: int):
	print("Player %s left the game!" % id )
	
	if _players == null:
		_players = get_tree().get_current_scene().get_node("Players")
	
	for character in _players.get_children():
		if character.player_id == id:
			character.queue_free()
			break

@rpc("call_remote", "reliable")
func load_map(vec_list: Array):
	var room_list: Array[Aabb] = []
	for pair in vec_list:
		room_list.push_back(Aabb.new(pair[0], pair[1]))
	
	var room_generator = get_tree().get_current_scene().get_node("Enviroment")
	room_generator.spawn_rooms(room_list)

func _exit_tree():
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_connected.disconnect(_add_player_to_game)
	multiplayer.peer_disconnected.disconnect(_del_player)

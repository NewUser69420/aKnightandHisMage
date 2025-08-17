extends Control

var ip: String = "127.0.0.1" # IPv4 localhost
var port: int = 7777

func set_ip(n_ip: String):
	if n_ip != "":
		ip = n_ip

func set_port(n_port: String):
	port = int(n_port)

func start_host():
	print("Pressed host")
	MultiplayerManager.start_host(port)

func start_client():
	print("Pressed client")
	MultiplayerManager.start_client(ip, port)

func _unhandled_input(_event: InputEvent):
	if Input.is_action_just_pressed("esc"):
			get_tree().quit()

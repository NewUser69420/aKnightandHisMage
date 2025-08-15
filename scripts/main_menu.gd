extends Control

const DEFAULT_SERVER_IP: String = "127.0.0.1" # IPv4 localhost
var port: int = 7000

func set_port(n_port: String):
	port = int(n_port)

func start_host():
	print("Pressed host")
	MultiplayerManager.start_host(port)

func start_client():
	print("Pressed client")
	MultiplayerManager.start_client(DEFAULT_SERVER_IP, port)

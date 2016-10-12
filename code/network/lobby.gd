extends Node

var ip = "localhost"
var port = 7777
var max_peers = 1
var host
var info = {name = "Generic Scientist", version = "0"}
var player_list = {}
var started_networking = false

func _ready():
	host = NetworkedMultiplayerENet.new()
	host.connect("connection_succeeded", self, "_connected_ok")
	host.connect("connection_failed", self, "_connected_fail")
	host.connect("server_disconnected", self, "_server_disconnected")
	host.connect("peer_connected", self, "_player_connected")
	host.connect("peer_disconnected", self, "_player_disconnected")


func host(port, max_peers):
	if not started_networking:
		host.create_server(port, max_peers)
		get_tree().set_network_peer(host)
		started_networking = true
		prepare_map()

func join(ip, port):
	if not started_networking:
		host.create_client(ip, port)
		get_tree().set_network_peer(host)
		started_networking = true
		
func prepare_map():
	get_node("/root/Menu").queue_free()
	var game = preload("res://scenes/game/game.tscn")
	get_tree().get_root().add_child(game.instance())

func close_connection():
	get_tree().set_network_peer(null)
	started_networking = false

func _player_connected(id):
	print("new memer", id)
	rpc("register_player", get_tree().get_network_unique_id(), info)

func _player_disconnected(id):
	pass

remote func register_player(id, info):
	if not player_list.has(id):
		player_list[id] = info
		print("ohh new", id, "btw i am ", get_tree().get_network_unique_id())
		
	
func _connected_ok():
	print("Connected successfully!")
	rpc("register_player", get_tree().get_network_unique_id(), info)
	prepare_map()

func _connected_fail():
	print("WOOPS! Looks like the cat ate the wires.")
	started_networking = false

func _server_disconnected():
	print("Server died of a heart attack.")
	close_connection()

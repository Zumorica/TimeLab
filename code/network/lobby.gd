extends Node

var ip = "localhost"
var port = 7777
var max_peers = 1
var host
var info = {name = "Generic Scientist", version = "0"}
var player_list = {}

func _ready():
	host = NetworkedMultiplayerENet.new()

func host(port, max_peers):
	host.create_server(port, max_peers)
	get_tree().set_network_peer(host)

func join(ip, port):
	host.create_client(ip, port)
	get_tree().set_network_peer(host)

func close_connection():
	get_tree().set_network_peer(null)

func _player_connected(id):
	pass

func _player_disconnected(id):
	pass

func _connected_ok():
	pass

func _connected_fail():
	pass

func _server_disconnected():
	pass

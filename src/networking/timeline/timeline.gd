extends Node

var is_busy = false # When connecting/creating a server, this will be true.
var is_online = false # When connected to/hosting a server, this will be true.
var map_handler = preload("res://src/map/map.gd").MapHandler.new()
onready var network_handler = NetworkedMultiplayerENet.new()

func _ready():
	pass
	
func host_server(port, max_players):
	is_busy = true
	network_handler.create_server(port, max_players)

func connect_to_server(ip, port):
	is_busy = true
	network_handler.create_client(ip, port)
	get_tree().set_network_peer(network_handler)
	if get_tree().get_network_unique_id():
		is_busy = false
		is_online = true
		

func connect_handlers():
	get_tree().connect("network_peer_connected", self, "client_connected")
	get_tree().connect("network_peer_disconnected", self, "client_diconnected")
	get_tree().connect("connected_to_server", self, "_connection_successful")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func client_connected(id):
	pass
	
func client_disconnected(id):
	pass
	
func _connection_sucessful():
	get_tree().set_network_peer(network_handler)
	is_busy = false
	is_online = true
	
	
func _connection_failed():
		get_tree().set_network_peer(null)
	
func _server_disconnected():
	pass
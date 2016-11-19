extends Node

var map
var own_info = {}
var client_list = {}
var is_busy = false # When connecting/creating a server, this will be true.
var is_online = false # When connected to/hosting a server, this will be true.
onready var map_handler = load("res://src/map/map.gd").MapHandler.new()
onready var network_handler = NetworkedMultiplayerENet.new()
onready var client_base = preload("res://src/client/client.tscn")
onready var own_client = client_base.instance()

func _ready():
	connect_handlers()
	
func host_server(port, max_players):
	if not is_busy or not is_online:
		is_busy = true
		network_handler.create_server(port, max_players)
		get_tree().set_network_peer(network_handler)
		own_client.set_name(str(get_tree().get_network_unique_id()))
		is_busy = false
		is_online = true
		prepare_map()
		get_tree().get_root().add_child(own_client)
		own_client.set_pos(map.map_pos_to_px(Vector2(0, 0), true))
		own_client.set_ID(get_tree().get_network_unique_id())
		get_node("/root/Menu").queue_free()

func connect_to_server(ip, port):
	if not is_busy or not is_online:
		is_busy = true
		network_handler.create_client(ip, port)
		get_tree().set_network_peer(network_handler)
		if get_tree().get_network_unique_id():
			is_busy = false
			is_online = true

remote func set_map(new_map):
	map = map_handler.get_map(new_map)
	if map:
		get_tree().get_root().add_child(map)
	
remote func prepare_map():
	if map:
		map.create_map()

func connect_handlers():
	get_tree().connect("network_peer_connected", self, "client_connected")
	get_tree().connect("network_peer_disconnected", self, "client_disconnected")
	get_tree().connect("connected_to_server", self, "_connection_successful")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func client_connected(id):
	print("A new client (", id, ") has connected.")
	rpc_id(id, "register_client", get_tree().get_network_unique_id(), own_info)
	if get_tree().get_network_unique_id() == 1:
		rpc_id(id, "set_map", map.get_data(true))
		rpc_id(id, "prepare_map")

func client_disconnected(id):
	pass
	
remote func register_client(id, info):
	if not client_list.has(id):
		client_list[id] = info
		var c = client_base.instance()
		c.set_pos(Vector2(16, 16))
		c.set_name(str(id))
		c.set_ID(id)
		get_tree().get_root().add_child(c)
	
func _connection_successful():
	get_tree().set_network_peer(network_handler)
	own_client.set_name(str(get_tree().get_network_unique_id()))
	own_client.set_ID(get_tree().get_network_unique_id())
	get_node("/root/Menu").queue_free()
	rpc("register_client", get_tree().get_network_unique_id(), own_info)
	own_client.set_pos(Vector2(16, 16))
	get_tree().get_root().add_child(own_client)
	is_busy = false
	is_online = true
	
func _connection_failed():
	get_tree().set_network_peer(null)
	own_client.set_name("Client")
	
func _server_disconnected():
	get_tree().set_network_peer(null)
	own_client.set_name("Client")
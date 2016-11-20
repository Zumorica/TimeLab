extends Node

var chosen_map
var map
var own_info = {}
var client_list = {}
var is_busy = false # When connecting/creating a server, this will be true.
var is_online = false # When connected to/hosting a server, this will be true.
var clients_ready = []
var lobby_client_list
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
		is_busy = false
		is_online = true
		var lobby = load("res://src/menu/Lobby.tscn").instance()
		get_node("/root").add_child(lobby)
		get_node("/root/Lobby/Panel/startButton").show()
		get_node("/root/Menu").free()
		lobby_client_list = get_node("/root/Lobby/Panel/LobbyClientList")

func connect_to_server(ip, port):
	if not is_busy or not is_online:
		is_busy = true
		network_handler.create_client(ip, port)
		get_tree().set_network_peer(network_handler)
		if get_tree().get_network_unique_id():
			is_busy = false
			is_online = true

sync func set_map(new_map):
	map = map_handler.get_map(new_map)
	if map:
		get_tree().get_root().add_child(map)
	
sync func prepare_map():
	if map:
		map.create_map()

func connect_handlers():
	get_tree().connect("network_peer_connected", self, "client_connected")
	get_tree().connect("network_peer_disconnected", self, "client_disconnected")
	get_tree().connect("connected_to_server", self, "_connection_successful")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func client_connected(id):
	pass

func client_disconnected(id):
	pass
	
func _connection_successful():
	rpc("register_client", get_tree().get_network_unique_id(), own_info)
	is_busy = false
	is_online = true
	var lobby = load("res://src/menu/Lobby.tscn").instance()
	get_node("/root").add_child(lobby)
	get_node("/root/Menu").free()
	lobby_client_list = get_node("/root/Lobby/Panel/LobbyClientList")
	own_client.set_ID(get_tree().get_network_unique_id())
	
func _connection_failed():
	get_tree().set_network_peer(null)
	own_client.set_name("Client")
	
func _server_disconnected():
	get_tree().set_network_peer(null)
	own_client.set_name("Client")

remote func register_client(id, info):
	if (get_tree().is_network_server()):
		rpc_id(id, "register_client", 1, own_info)
		for client_id in client_list:
			rpc_id(id, "register_client", client_id, client_list[client_id])
			rpc_id(client_id, "register_client", id, info)
	client_list[id] = info
	refresh_lobby()

func refresh_lobby():
	lobby_client_list.clear()
	if own_client.get_ID() in clients_ready:
		lobby_client_list.add_item(str(own_client.get_ID()) + " (You): Ready")
	else:
		lobby_client_list.add_item(str(own_client.get_ID()) + " (You)")
	for client_id in client_list:
		if client_id in clients_ready:
			lobby_client_list.add_item(str(client_id) + ": Ready")
		else:
			lobby_client_list.add_item(str(client_id))

func set_client_ready():
	rpc("add_to_ready", own_client.get_ID())

sync func add_to_ready(id):
	clients_ready.append(id)
	refresh_lobby()

func begin_game():
	set_map(chosen_map)
	prepare_map()
	rpc("pre_configure_game", map.get_data(true))

sync func pre_configure_game(host_map):
	get_node("/root/Lobby").free()
	own_client.set_name(str(own_client.get_ID()))
	if not get_tree().is_network_server():
		set_map(host_map)
		prepare_map()
	get_tree().get_root().add_child(own_client)
	own_client.set_pos(map.map_pos_to_px(Vector2(0, 0), true))
	own_client.set_network_mode(NETWORK_MODE_MASTER)
	var client_scene = load("res://src/client/client.tscn")
	for client_id in client_list:
		var client = client_scene.instance()
		client.set_name(str(client_id))
		get_tree().get_root().add_child(client)
		client.set_pos(map.map_pos_to_px(Vector2(1, 1), true))
		client.set_network_mode(NETWORK_MODE_SLAVE)
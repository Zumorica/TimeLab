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
		get_node("/root/Menu").queue_free()
		lobby_client_list = get_node("/root/Lobby/Panel/LobbyClientList")
		refresh_lobby()

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
		map.set_pos(Vector2(0, 0))
 
func connect_handlers():
	get_tree().connect("network_peer_connected", self, "client_connected")
	get_tree().connect("network_peer_disconnected", self, "client_disconnected")
	get_tree().connect("connected_to_server", self, "_connection_successful")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func client_connected(id):
	rpc_id(id, "register_client", get_tree().get_network_unique_id(), own_info)

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
	print("Connection failed!")
	
func _server_disconnected():
	get_tree().set_network_peer(null)
	own_client.set_name("Client")
	print("Server disconnected.")

remote func register_client(id, info):
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

func set_client_ready(is_remove=false):
	rpc("modify_ready", own_client.get_ID(), is_remove)

sync func modify_ready(id, is_remove):
	if not is_remove:
		clients_ready.append(id)
	else:
		if clients_ready.has(id):
			clients_ready.erase(id)
	refresh_lobby()

func set_spawn_points(clients):
	var spawn_points = {}
	var x = 1
	var y = 1
	spawn_points[own_client.get_ID()] = Vector2(x, y)
	for client_id in clients:
		x += 2
		y += 2
		spawn_points[client_id] = Vector2(x, y)
	return spawn_points

func begin_game():
	if clients_ready.size() != (client_list.size() + 1):#+1 because the client list doesn't have the host in it
		print("Not everybody is ready!")
		return
	set_map(chosen_map)
	prepare_map()
	var spawn_points = set_spawn_points(client_list)
	rpc("pre_configure_game", map.get_data(true), spawn_points)

sync func pre_configure_game(host_map, spawn_points):
	get_node("/root/Lobby").queue_free()
	own_client.set_name(str(own_client.get_ID()))
	if not get_tree().is_network_server():
		set_map(host_map)
		prepare_map()
	get_tree().get_root().add_child(own_client)
	own_client.configure_network_mode(NETWORK_MODE_MASTER)
	own_client.set_pos(map.map_pos_to_px(spawn_points[own_client.get_ID()], true))
	for client_id in client_list:
		var client = client_base.instance()
		client.set_name(str(client_id))
		client.set_ID(int(client_id))
		get_tree().get_root().add_child(client)
		client.set_pos(map.map_pos_to_px(spawn_points[client_id], true))
		client.configure_network_mode(NETWORK_MODE_SLAVE)
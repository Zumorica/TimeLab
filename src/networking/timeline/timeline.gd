extends Node

var own_info = {}
var client_list = {}
var is_busy = false # When connecting/creating a server, this will be true.
var is_online = false # When connected to/hosting a server, this will be true.
var is_server = false
var clients_ready = []
var clients_prepared = []
var lobby_client_list
onready var network_handler = NetworkedMultiplayerENet.new()
onready var client_base = preload("res://src/client/client.tscn")
onready var client_code_base = preload("res://src/client/client.gd")
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
		is_server = true
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
 
func connect_handlers():
	get_tree().connect("network_peer_connected", self, "client_connected")
	get_tree().connect("network_peer_disconnected", self, "client_disconnected")
	get_tree().connect("connected_to_server", self, "_connection_successful")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func client_connected(id):
	rpc_id(id, "register_client", get_tree().get_network_unique_id(), own_info)
	if get_tree().is_network_server():
		for client in clients_ready:
			rpc_id(id, "modify_ready", client, false)

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
	var spawn_points = set_spawn_points(client_list)
	rpc("pre_configure_game", spawn_points)

sync func pre_configure_game(spawn_points):
	get_node("/root/Lobby").queue_free()
	own_client.set_name(str(own_client.get_ID()))
	get_tree().get_root().add_child(own_client)
	get_tree().get_root().add_child(load("res://src/map/maps/test_lab.tscn").instance())
	get_tree().get_root().add_child(load("res://src/GUI/UserInterface.tscn").instance())
	own_client.configure_network_mode(NETWORK_MODE_MASTER)
	own_client.get_node("Mob").set_pos(spawn_points[own_client.get_ID()] * Vector2(32, 32) + Vector2(16, 16))
	for client_id in client_list:
		var client = client_base.instance()
		client.set_name(str(client_id))
		client.set_ID(int(client_id))
		get_tree().get_root().add_child(client)
		client.get_node("Mob").set_pos(spawn_points[client_id] * Vector2(32, 32) + Vector2(16, 16))
		client.configure_network_mode(NETWORK_MODE_SLAVE)
	if get_tree().is_network_server():
		post_configure_game(own_client.get_ID())
	else:
		rpc_id(1, "post_configure_game", own_client.get_ID())
		get_tree().set_pause(true)

remote func post_configure_game(id):
	clients_prepared.append(id)
	if clients_prepared.size() == clients_ready.size():
		for client_id in clients_prepared:
			if client_id != 1:
				rpc_id(client_id, "done_preconfig")
remote func done_preconfig():
	get_tree().set_pause(false)
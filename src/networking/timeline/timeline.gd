extends Node

var client_list = {}
var is_busy = false # When connecting/creating a server, this will be true.
var is_online = false # When connected to/hosting a server, this will be true.
var is_server = false
var clients_ready = []
var clients_prepared = []
var lobby_client_list
remote var gamemode = null
var gamemode_list = {"Sandbox" : "res://src/gamemode/sandbox.gd", "Mystery" : "res://src/gamemode/mystery.gd"}
onready var network_handler = NetworkedMultiplayerENet.new()
onready var client = s_base.client_scene.instance() setget get_current_client
onready var right_click_menu = PopupMenu.new()
onready var user_interface = s_base.user_interface_scene.instance()
var right_click_menu_pointer = null
var random_seed

func _ready():
	right_click_menu.hide()
	randomize()
	random_seed = randi()
	rand_seed(random_seed)
	var clients_node = Node2D.new()
	clients_node.set_name("Clients")
	add_child(clients_node)
	clients_node.add_child(client)
	connect_handlers()
	
func get_current_client():
	return client
	
func host_server(port, max_players):
	if not is_busy or not is_online:
		is_busy = true
		network_handler.create_server(port, max_players)
		get_tree().set_network_peer(network_handler)
		is_busy = false
		is_online = true
		is_server = true
		get_current_client().set_ID(get_tree().get_network_unique_id())
		get_current_client().configure_network_mode(NETWORK_MODE_MASTER)
		var lobby = load("res://src/menu/Lobby.tscn").instance()
		get_node("/root").add_child(lobby)
		get_node("/root/Lobby/Panel/startButton").show()
		get_node("/root/Lobby/Panel/gamemodeSelection").show()
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
	
remote func create_new_client(id):
	var new_client = s_base.client_scene.instance()
	new_client.set_ID(id)
	get_node("Clients").add_child(new_client)
	#new_client.request_info()
	new_client.configure_network_mode(NETWORK_MODE_SLAVE)
	
func client_connected(id):
	create_new_client(id)
	refresh_lobby()

func client_disconnected(id):
	for child in get_node("Clients").get_children():
		if child.get_name() == str(id):
			child.queue_free()

func _connection_successful():
	is_busy = false
	is_online = true
	get_current_client().set_ID(get_tree().get_network_unique_id())
	get_current_client().configure_network_mode(NETWORK_MODE_MASTER)
	var lobby = load("res://src/menu/Lobby.tscn").instance()
	get_node("/root").add_child(lobby)
	get_node("/root/Menu").free()
	lobby_client_list = get_node("/root/Lobby/Panel/LobbyClientList")
	refresh_lobby()
	
func _connection_failed():
	get_tree().set_network_peer(null)
	get_current_client().set_name("Client")
	print("Connection failed!")
	
func _server_disconnected():
	get_tree().set_network_peer(null)
	get_current_client().set_name("Client")
	print("Server disconnected.")

func refresh_lobby():
	if has_node("/root/Lobby/Panel/LobbyClientList"):
		lobby_client_list = get_node("/root/Lobby/Panel/LobbyClientList")
		lobby_client_list.clear()
		for client in get_node("Clients").get_children():
			if client.is_client():
				if client.get_ID() in clients_ready:
					lobby_client_list.add_item(str(client.get_ID()) + " (You): Ready to party!")
				else:
					lobby_client_list.add_item(str(client.get_ID()) + " (You)")
			else:
				if client.get_ID() in clients_ready:
					lobby_client_list.add_item(str(client.get_ID()) + ": Ready to party!")
				else:
					lobby_client_list.add_item(str(client.get_ID()))

func set_client_ready(is_remove=false):
	rpc("modify_ready", get_current_client().get_ID(), is_remove)

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
	spawn_points[get_current_client().get_ID()] = Vector2(x, y)
	for client in get_node("Clients").get_children():
		x += 2
		y += 2
		spawn_points[client.get_ID()] = Vector2(x, y)
	return spawn_points

func begin_game():
	if clients_ready.size() != (get_node("Clients").get_children().size()):
		print("Not everybody is ready!")
		return
	var spawn_points = set_spawn_points(client_list)
	rpc("pre_configure_game", spawn_points)

sync func pre_configure_game(spawn_points):
	var map
	var map_scene = load("res://src/map/maps/test_lab.tscn")
	map = map_scene.instance()
	if is_server:
		rpc("set_gamemode", gamemode_list.values()[get_node("/root/Lobby/Panel/gamemodeSelection").get_selected()])
	get_node("/root/Lobby").queue_free()
	get_tree().get_root().add_child(map)
	get_current_client().add_child(user_interface)
	#get_current_client().get_node("UserInterface/Layer").add_child(right_click_menu)
	get_current_client().get_node("UserInterface").add_child(right_click_menu)
	for client in get_node("Clients").get_children():
		print(client)
		var human = s_base.human_scene.instance()
		get_node("/root/Map").add_child(human)
		client.set_mob(human)
		client.get_mob().set_pos(spawn_points[client.get_ID()] * Vector2(32, 32) + Vector2(16, 16))

	if get_tree().is_network_server():
		post_configure_game(get_current_client().get_ID())
	else:
		rpc_id(1, "post_configure_game", get_current_client().get_ID())
		get_tree().set_pause(true)

sync func set_gamemode(path):
	var new_gamemode = load(path).new()
	assert new_gamemode extends s_base.gamemode
	gamemode = new_gamemode

remote func post_configure_game(id):
	clients_prepared.append(id)
	if clients_prepared.size() == clients_ready.size():
		gamemode.emit_signal("on_game_start")
		gamemode.emit_signal("gamemode_prepare")
		for element in get_tree().get_nodes_in_group("elements"):
			element.emit_signal("on_game_start")
		for client_id in clients_prepared:
			if client_id != 1:
				rpc_id(client_id, "done_preconfig")

remote func done_preconfig():
	get_tree().set_pause(false)
	gamemode.emit_signal("on_game_start")
	gamemode.emit_signal("gamemode_prepare")
	for element in get_tree().get_nodes_in_group("elements"):
		element.emit_signal("on_game_start")
	
	
func send_global_message(msg):
	get_current_client().update_chat(msg)
	for client in get_node("Clients").get_children():
		client.rpc("update_chat", msg)

sync func _sync_adding(item_path):
	var item = get_node(item_path)
	item.get_parent().remove_child(item)

sync func _sync_drop(item_path, mob):
	var item = get_node(item_path)
	get_node("/root/Map").add_child(item)
	item.set_pos(mob.get_pos())
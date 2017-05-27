extends Node

signal game_start()
signal game_end()

sync var game_started = false setget has_game_started, set_game_started	# Whether the game has started or not. Should not be changed manually.
sync var map = null setget ,set_current_map	# Map instance
onready var network = NetworkedMultiplayerENet.new()

func _ready():
	rpc_config("emit_signal", RPC_MODE_SYNC)
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_success")
	network.connect("server_disconnected", self, "_on_server_disconnect")
	network.connect("peer_connected", self, "_on_peer_connect")
	network.connect("peer_disconnected", self, "_on_peer_disconnect")

func has_game_started():
	return game_started

func set_current_map(new_map):
	rset("map", new_map)
	
func set_game_started(value):
	rset("game_started", value)
	if value:
		rpc("emit_signal", "game_start")
	else:
		rpc("emit_signal", "game_end")
		
func get_client(ID):
	for client in get_tree().get_nodes_in_group("clients"):
		if client.ID == ID:
			return client
	return false
	
func get_current_client():
	return get_client(get_tree().get_network_unique_id())
	
sync func instance(object, parent_path, variables={}, call_functions=[], name=""):
	assert typeof(parent_path) == TYPE_NODE_PATH
	assert typeof(variables) == TYPE_DICTIONARY
	if typeof(object) == TYPE_STRING:
		object = load(object)
		print(typeof(object))
		assert typeof(object) == TYPE_OBJECT
		if object.has_method("instance"):
			object = object.instance()
		elif object.has_method("new"):
			object = object.new()
		else:
			raise()
	elif typeof(object) == TYPE_OBJECT:
		if object.has_method("instance"):
			object = object.instance()
		elif object.has_method("new"):
			object = object.new()
		else:
			raise()
	assert typeof(object) == TYPE_OBJECT and object extends Node
	for variable in variables.keys():
		if variable != "script":
			object.set(variable, variables[variable])
	for method in call_functions:
		object.call(method)
	assert typeof(name) == TYPE_STRING
	if name.strip_edges().length() > 0:
		object.set_name(name)
	get_node(parent_path).add_child(object, true)

func create_server(port=7777, max_players=32):
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	get_tree().change_scene("res://src/game.tscn")
	var server = load("res://src/client.gd").new()
	server.ID = get_tree().get_network_unique_id()
	server.set_name("Host")
	add_child(server)
	
func join_game(ip="127.0.0.1", port=7777):
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
func _on_connection_failed():
	print("Connection failed.")
	print(network.get_packet_error())
	get_tree().change_scene("res://src/menu/title/title.tscn")
	
func _on_connection_success():
	get_tree().change_scene("res://src/game.tscn")
	
func _on_server_disconnect():
	print("Server disconnected!")
	get_tree().quit()
	
func _on_peer_connect(ID):
	prints(ID, "connected.")
	if get_tree().is_network_server():
		for client in get_tree().get_nodes_in_group("clients"):
			var variables = {}
			for i in client.get_property_list():
				variables[i["name"]] = client.get(i["name"])
			rpc_id(ID, "instance", "res://src/client.gd", get_path(), variables, [], client.get_name())
		rpc("instance", "res://src/client.gd", get_path(), {"ID" : ID}, [], "Scientist")

func _on_peer_disconnect(ID):
	prints(ID, "disconnected.")
	get_client(ID).rset("is_alive", false)
	
sync func rename(path, name):
	assert typeof(path) == TYPE_NODE_PATH
	get_node(path).set_name(name)
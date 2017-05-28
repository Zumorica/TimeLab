extends CenterContainer

export(NodePath) var join_port
export(NodePath) var join_address
export(NodePath) var join_button
export(NodePath) var host_port
export(NodePath) var host_maxplayers
export(NodePath) var host_button

func _ready():
	assert get_node(join_port) extends LineEdit
	assert get_node(join_address) extends LineEdit
	assert get_node(join_button) extends Button
	assert get_node(host_port) extends LineEdit
	assert get_node(host_maxplayers) extends LineEdit
	assert get_node(host_button) extends Button
	get_node(join_button).connect("pressed", self, "_on_join_button_pressed")
	get_node(host_button).connect("pressed", self, "_on_host_button_pressed")
	
func _on_join_button_pressed():
	var port_node = get_node(join_port)
	var address_node = get_node(join_address)
	var port
	var address
	if not (port_node.text.is_valid_integer()):
		return
	if not address_node.text.is_valid_ip_address():
		address = IP.resolve_hostname(address_node.text, IP.TYPE_IPV4)
	else:
		address = address_node.text
	port = int(port_node.text)
	timelab.join_game(address, port)
	
func _on_host_button_pressed():
	var port_node = get_node(host_port)
	var maxplayers_node = get_node(host_maxplayers)
	if not (port_node.text.is_valid_integer() and maxplayers_node.text.is_valid_integer()):
		return
	var port = int(port_node.text)
	var maxplayers = int(maxplayers_node.text)
	timelab.create_server(port, maxplayers)
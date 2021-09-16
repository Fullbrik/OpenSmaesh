extends Node

@export var lobby_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_module_list()

func setup_module_list():
	var module_list : ItemList = $Modules/VBoxContainer/ModuleList
	var items = ModuleManager.find_modules()
	
	for item in items:
		module_list.add_item(item)


func _on_HostButton_pressed():
	var port_edit : LineEdit = $Host/VBoxContainer/PortBox/PortEdit
	var port_text : String = port_edit.text
	var port : int = port_text.to_int()
	
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(port)
	get_tree().multiplayer.multiplayer_peer = peer
	
	print_debug("Started lobby on port: ", port_text)
	
	get_tree().change_scene_to(lobby_scene)


func _on_JoinButton_pressed():
	var ip_edit : LineEdit = $Join/VBoxContainer/IPBox/IPEdit
	var ip : String = ip_edit.text
	
	var port_edit : LineEdit = $Join/VBoxContainer/PortBox/PortEdit
	var port_text : String = port_edit.text
	var port : int = port_text.to_int()
	
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	get_tree().multiplayer.multiplayer_peer = peer
	
	print_debug("Joined server on: ", ip, ":", port)
	
	get_tree().change_scene_to(lobby_scene)

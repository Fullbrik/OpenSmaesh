extends Node

@onready var player_list : ItemList = $Players/VBoxContainer/PlayerList

# Called when the node enters the scene tree for the first time.
func _ready():
	bind()
	
	# Add ourselves to list
	peer_connected(get_tree().multiplayer.get_unique_id())

func bind():
	# Bind multiplayer events
	get_tree().multiplayer.connect("peer_connected", peer_connected)

func setup_characters():
	var characters = ModuleManager.get_characters() as Array[CharacterData]
	
	for character in characters:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func peer_connected(id: int):
	# Add player to list
	player_list.add_item("Player-" + str(id))

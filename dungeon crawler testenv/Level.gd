extends Node
class_name Level
#@onready var player = $Player
#@onready var ui = %ui
# Called when the node enters the scene tree for the first time.
func _ready():
	var levelPlayer:Player = get_tree().get_nodes_in_group("Player").back()
	
	assert(levelPlayer != null, "Level must have a Player!")
	MovementServer.player = levelPlayer
	MovementServer.connect_to_player()
	pass
	#player.get_node("Input").set("inventory", ui.get_node("Control/Inventory"))

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

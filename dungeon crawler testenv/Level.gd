extends Node
class_name Level
#@onready var player = $Player
#@onready var ui = %ui
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#player.get_node("Input").set("inventory", ui.get_node("Control/Inventory"))

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

extends Node

@export var movement:Movement
# Called when the node enters the scene tree for the first time.
func _ready():
	MovementServer.player_moved.connect(on_player_move)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func on_player_move(dir):
	var oppositeDir = dir * -1
	if movement.check_move(oppositeDir):
		movement.move(oppositeDir,0.1)

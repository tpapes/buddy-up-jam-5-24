extends Node

signal player_moved(direction:Vector2)

var player:Player:
	set(v):
		player = v
	get:
		return player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
func on_player_moved():
	player_moved.emit(player.movement.target_position.normalized())
	pass

func connect_to_player():
	if player.movement.movement_finished.is_connected(on_player_moved):
		player.movement.movement_finished.disconnect(on_player_moved)
	player.movement.movement_finished.connect(on_player_moved)


extends RayCast2D
class_name Movement

signal movement_finished
@export var parent:Node2D
var moving:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#checks for collision at movement target
func check_move(movement:Vector2)->bool:
	target_position = movement * Sizes.tileSize
	force_raycast_update()
	return !is_colliding()

func move(dir:Vector2,time:float):
	moving = true
	var tween = create_tween()
	var targetPosition = dir * Sizes.tileSize
	tween.tween_property(parent,"position",
		parent.position + targetPosition,
		time)
	await  tween.finished
	moving = false
	movement_finished.emit()

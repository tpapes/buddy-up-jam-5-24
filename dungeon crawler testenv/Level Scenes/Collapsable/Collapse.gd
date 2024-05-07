extends Area2D

@export var collisionBody:StaticBody2D
@export var colorBox:Polygon2D
# Called when the node enters the scene tree for the first time.
func _ready():
	collisionBody.collision_layer = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_area_exited(area):
	collisionBody.collision_layer = 16
	var newTween = create_tween()
	newTween.tween_property(colorBox,"scale",Vector2.ZERO,0.5);
	pass # Replace with function body.

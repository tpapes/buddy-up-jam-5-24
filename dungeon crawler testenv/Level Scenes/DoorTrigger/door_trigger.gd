extends Node2D
class_name DoorTrigger

signal triggered
var beenTriggered:bool = false
@export var polygon:Polygon2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_area_2d_area_entered(area):
	if area is Bullet:
		polygon.color = Color.GREEN
		beenTriggered = true
		triggered.emit()
	pass # Replace with function body.

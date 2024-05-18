extends Node

@onready var drill_obj : Node2D
@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	drill_obj = get_node("/root/TileStuff/Player_CTX/Drill")
	if (drill_obj != null):
		drill_obj.drill.connect(_on_drill_break)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_drill_break(frac_area):
	if (frac_area == area):
		queue_free()

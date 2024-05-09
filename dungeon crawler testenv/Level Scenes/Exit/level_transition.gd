extends Node2D

@export var currentLevel:Level
@export_file("*.tscn") var targetLevelPath:String
var targetLevel:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	targetLevel = load(targetLevelPath)
	pass # Replace with function body.


func _on_area_2d_area_entered(area:Area2D):
	if area.get_parent() is Player:
		var newLevel = targetLevel.instantiate()
		currentLevel.call_deferred("add_sibling",newLevel)
		
		currentLevel.queue_free()
	pass # Replace with function body.

extends Node2D

@export var triggers:Array[DoorTrigger]

# Called when the node enters the scene tree for the first time.
func _ready():
	for trigger in triggers:
		trigger.triggered.connect(check_triggers)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_triggers():
	var allClear:bool = true
	for trigger in triggers:
		if !trigger.beenTriggered:allClear = false
	if allClear: queue_free()

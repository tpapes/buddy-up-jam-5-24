extends Node

@onready var coll = $Area2D
@onready var stepped = $bool
@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	coll = null
	stepped = false
	area = self
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var found = false
	if (coll != null): stepped = true
	
	for n in area.get_overlapping_areas():
		if (n.is_in_group("player")):
			if (coll == null): coll = n
			if (coll == n): found = true
			
	if (stepped and !found):
		queue_free()
		
	pass

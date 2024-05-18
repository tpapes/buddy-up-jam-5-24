extends Node

@onready var coll : Area2D
@onready var stepped : bool
@onready var area = $Area2D
@onready var shape
@onready var collShape = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	coll = null
	stepped = false
	shape = self
	
	var s = RectangleShape2D.new()
	s.set_size(shape.size - Vector2(0,32))

	collShape.shape = s
	collShape.get_node(".").position = s.size / 2

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

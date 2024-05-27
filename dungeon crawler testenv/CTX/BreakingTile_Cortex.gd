extends NinePatchRect

@onready var coll : Area2D
@onready var stepped : bool
@onready var falling : float
@onready var area = $Area2D
@onready var shape
@onready var collShape = $Area2D/CollisionShape2D

const TEXTURE:= preload("res://CTX/tileSet.png")

var is_broken:= false
var original_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	coll = null
	stepped = false
	shape = self
	falling = -1
	original_position = position
	
	var s = RectangleShape2D.new()
	s.set_size(shape.size - Vector2(0,32))

	collShape.shape = s
	collShape.get_node(".").position = s.size / 2

func attempt_undo(was_broken: bool):
	if was_broken == false and is_broken == true:
		unbreak_tile()
	elif was_broken == true and is_broken == false:
		break_tile()

func break_tile():
	texture = null
	area.monitoring = false
	area.monitorable = false
	is_broken = true

func unbreak_tile():
	texture = TEXTURE
	area.monitoring = true
	area.monitorable = true
	position = original_position
	modulate = Color(1,1,1,1)
	is_broken = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var found = false
	if (coll != null): stepped = true
	
	if (falling == -1):
		for n in area.get_overlapping_areas():
			if (n.is_in_group("player")):
				if (coll == null): coll = n
				if (coll == n): found = true
				
		if (stepped and !found):
			#queue_free()
			falling = 0
			area.collision_layer = 0
	else:
		if (falling >= 0):
			self.position.y += 256 * (2 * falling + delta) * delta
			falling += delta
			
			var c:CanvasItem = shape
			var f = 1 - falling / 0.45
			c.modulate = Color(f,pow(f,0.82),pow(f,0.70),pow(f,0.1))
			
		if (falling > 0.45): break_tile()

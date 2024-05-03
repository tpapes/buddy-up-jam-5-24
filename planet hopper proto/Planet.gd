extends AnimatableBody2D
class_name Planet

@export var SIZE = 10.0
@export var MOVE_SPEED = 100.0

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

var anchor_y = 100
var playing:bool:
	set(value):
		playing = value 

func _ready():
	
	add_to_group("planet")
	
	#move_and_collide() doesn't work for 
	#animatable bodies unless we do this:
	sync_to_physics = false 

func _physics_process(delta):
	
	var collisionObject
	if playing: #if game is running
		#slide planet down
		collisionObject = move_and_collide(Vector2.DOWN * MOVE_SPEED * delta)
	if collisionObject:
		#planets can only collide with the Planet Deletor wall
		#because of how the collision layers are set up.
		#because of that, we can just delete a planet once it hits
		queue_free()
	
func update_scale(value):
	SIZE *= value
	collision_shape.scale *= value
	sprite.scale *= value
	anchor_y *= value

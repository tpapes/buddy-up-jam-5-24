extends AnimatableBody2D
class_name Planet

@export var TURN_SPEED = 5.0
@export var SLOW_RATE = 1.0
@export var SIZE = 10
@export var MOVE_SPEED = 100.0

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

var anchor_y = 100
var rot_velo = 0.0
var playing:bool:
	set(value):
		playing = value 

func _ready():
	
	add_to_group("planet")
	
	#move_and_collide() doesn't work for 
	#animatable bodies unless we do this:
	sync_to_physics = false 

func turn(dir):#called when Player node sends input
	#set how fast and what direction to turn in
	rot_velo = TURN_SPEED * dir

func _physics_process(delta):
	rotation += rot_velo * delta #turn with rot_velo as velocity
	rot_velo = lerp(rot_velo, 0.0, SLOW_RATE) #slow down rot_velo if no input is given
	
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
	collision_shape.scale *= value
	sprite.scale *= value
	anchor_y *= value

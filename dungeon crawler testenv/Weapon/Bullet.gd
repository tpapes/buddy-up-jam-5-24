extends Area2D
class_name Bullet

const SCREEN_SIZE:= Vector2(1152, 648)
const SCREEN_BORDER:= 40
@export var SPEED:= 500
var direction:Vector2
var spawnPosition:Vector2

func init(_position: Vector2, _direction:Vector2):
	global_position = _position
	spawnPosition = global_position
	direction = _direction

func _ready():
	assert(direction != null, "direction must be set by init()")

func _physics_process(delta):
	global_position += direction * SPEED * delta
	if global_position.x < -SCREEN_BORDER or \
			global_position.x > SCREEN_SIZE.x + SCREEN_BORDER or \
			global_position.y < -SCREEN_BORDER or \
			global_position.y > SCREEN_SIZE.y + SCREEN_BORDER:
		queue_free()
	if global_position.distance_to(spawnPosition) > Sizes.tileSize:
		queue_free()

func _on_body_entered(_body):
	queue_free()
	pass # Replace with function body.

func _on_area_entered(_area):
	#print("Entered " + area.name)
	pass # Replace with function body.

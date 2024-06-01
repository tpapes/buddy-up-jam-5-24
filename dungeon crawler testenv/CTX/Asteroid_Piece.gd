extends Sprite2D

#@onready var timer = null
var velocity = Vector2.ZERO
var speed = 350
var angle = 45
var ang_velocity = 0
var go = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_node("/root/EndingCutscene/Camera2D")
	if (timer != null):
		timer.explode.connect(_on_explode)
	speed += pow(randf_range(-1,1), 3) * 90
	angle += pow(randf_range(-1,1), 3) * 125
	ang_velocity = pow(randf_range(-1,1), 3) * 10
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (go):
		self.position += speed * Vector2.from_angle(deg_to_rad(angle)) * delta
		self.rotate(ang_velocity * delta)

func _on_explode():
	go = true

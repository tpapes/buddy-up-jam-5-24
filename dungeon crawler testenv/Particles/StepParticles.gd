extends CPUParticles2D

func init(_global_position: Vector2):
	global_position = _global_position

func _ready():
	one_shot = true
	emitting = true
	finished.connect(queue_free)


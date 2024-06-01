extends FracturePoint

const SHAKE_LENGTH:= 2
const SHAKE_SPEED:= 0.5
const SCALE_DIMINISH_FACTOR:= 0.96

var shake_lerp:= 0.0
var shaking:= false
var original_scale: Vector2

func _ready():
	super()
	health = 3
	original_scale = scale

func break_frac():
	super()
	if health > 0:
		diminish_health()
		return
	shaking = 0
	shake_lerp = 0
	offset.x = 0
	scale = original_scale
	collision.scale = Vector2.ONE

func diminish_health():
	shaking = true
	shake_lerp = 0.0
	scale *= SCALE_DIMINISH_FACTOR
	collision.scale /= SCALE_DIMINISH_FACTOR

func attempt_undo(prev_health: int):
	if prev_health > 1 and prev_health == health + 1:
		scale /= SCALE_DIMINISH_FACTOR
		collision.scale *= SCALE_DIMINISH_FACTOR
	super(prev_health)

func shake_process(delta):
	if not shaking:
		return
	offset.x = sin(shake_lerp * 2 * PI)
	if (shake_lerp == 1):
		shaking = false
		shake_lerp = 0.0
	shake_lerp += SHAKE_SPEED * delta
	print(shake_lerp, " ", offset.x)
	shake_lerp = clamp(shake_lerp, 0, 1)

func _process(delta):
	var spr:Sprite2D = self
	spr.frame = 3 - health
	shake_process(delta)
	if (shake_lerp > 0): spr.frame = 3

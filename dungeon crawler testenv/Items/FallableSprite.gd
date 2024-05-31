extends Sprite2D
class_name FallableSprite

signal starting_fall
signal finished_fall

var original_modulate: Color
var original_y: float
var is_falling:= false
var is_fallen:= false
var falling:= 0.0

func _ready():
	original_modulate = modulate
	original_y = position.y

func start_fall():
	falling = 0.0
	is_fallen = true
	is_falling = true
	starting_fall.emit()

func finish_fall():
	hide()
	is_falling = false
	is_fallen = true
	finished_fall.emit()

func unfall():
	position.y = original_y
	modulate = original_modulate
	is_falling = false
	is_fallen = false
	show()

func _process(delta):
	if !is_falling:
		return
	position.y += 256 * (2 * falling + delta) * delta
	falling += delta
	var f = 1 - falling / 0.45
	modulate = Color(f,pow(f,0.82),pow(f,0.70),pow(f,0.5))
	#modulate = Color(f,pow(f,0.82),pow(f,0.70),pow(f,0.1))
	if falling > 0.45:
		finish_fall()



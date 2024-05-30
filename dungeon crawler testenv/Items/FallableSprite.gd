extends Sprite2D
class_name FallableSprite

signal starting_fall
signal finished_fall

var original_position: Vector2
var is_falling:= false
var is_fallen:= false
var falling:= 0.0

func _ready():
	original_position = position

func start_break():
	falling = 0.0
	is_fallen = true
	is_falling = true
	starting_fall.emit()

func finish_break():
	hide()
	is_falling = false
	is_fallen = true
	finished_fall.emit()

func unbreak():
	position = original_position
	modulate = Color(1,1,1,1)
	show()
	is_falling = false
	is_fallen = false

func _process(delta):
	if !is_falling:
		return
	position.y += 256 * (2 * falling + delta) * delta
	falling += delta
	var f = 1 - falling / 0.45
	modulate = Color(f,pow(f,0.82),pow(f,0.70),pow(f,0.1))
	if falling > 0.45:
		finish_break()



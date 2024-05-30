extends Area2D

@onready var sprite:= $Sprite2D

var is_breaking:= false
var is_broken:= false
var original_position: Vector2
var falling:= 0.0

signal starting_break

func _ready():
	collision_mask = 0b1000
	body_exited.connect(attempt_break)

func attempt_break(body):
	if body.is_in_group("player") and body.is_moving:
		collision_mask = 0b0
		collision_layer = 0b0
		falling = 0.0
		is_broken = true
		is_breaking = true
		starting_break.emit()

func attempt_undo(was_broken: bool):
	if was_broken == false and is_broken == true:
		unbreak_tile()
	elif was_broken == true and is_broken == false:
		finish_break()

func finish_break():
	sprite.hide()
	is_breaking = false
	is_broken = true

func unbreak_tile():
	sprite.position = original_position
	sprite.modulate = Color(1,1,1,1)
	sprite.show()
	is_breaking = false
	is_broken = false
	collision_layer = 0b1
	collision_mask = 0b1000

func _process(delta):
	if !is_breaking:
		return
	sprite.position.y += 256 * (2 * falling + delta) * delta
	falling += delta
	var f = 1 - falling / 0.45
	sprite.modulate = Color(f,pow(f,0.82),pow(f,0.70),pow(f,0.1))
	if falling > 0.45:
		finish_break()


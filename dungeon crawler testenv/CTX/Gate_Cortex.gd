extends Sprite2D

@onready var area = $Area2D

signal opened

var is_open:= false
var all_frac_points:= []

func _ready():
	for child in get_children():
		if child.is_in_group("frac_point"):
			all_frac_points.append(child)
			child.just_broke.connect(attempt_open)

func attempt_undo(was_open: bool):
	if was_open and !is_open:
		open_gate()
	elif !was_open and is_open:
		close_gate()

func set_collision(toggle: bool):
	area.collision_layer = 2 if toggle else 0

func open_gate():
	set_collision(false)
	region_rect.position.x += 96
	z_index = 0
	is_open = true
	opened.emit()

func close_gate():
	set_collision(true)
	region_rect.position.x -= 96
	z_index = 3
	is_open = false

func attempt_open():
	if is_open:
		return
	var all_broken:= true
	for frac_point in all_frac_points:
		if !frac_point.is_broken:
			all_broken = false
			break
	if all_broken:
		open_gate()



extends Area2D

const SLERP_SPEED:= 16

var is_moving:= false
var slerp_weight:= 0.0
var start_position: Vector2
var goal_position: Vector2

signal drill(frac_area)
signal drilled_frac
signal move_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = position

func start_move(move_direction: Vector2):
	start_position = position
	goal_position = move_direction * Sizes.newTileSize
	slerp_weight = 0.0
	is_moving = true

func end_move():
	is_moving = false
	move_finished.emit()

func attempt_drill():
	var drill_used = false
	for n in get_overlapping_areas():
		if (n.is_in_group("frac_point")):
			drill_used = true
			drill.emit(n)
	if drill_used:
		drilled_frac.emit()

func _unhandled_input(event):
	if event.is_action_pressed("use"):
		attempt_drill()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_moving:
		return
	self.position = start_position.slerp(goal_position, slerp_weight)
	if slerp_weight == 1:
		end_move()
	slerp_weight += SLERP_SPEED * delta
	slerp_weight = clamp(slerp_weight, 0.0, 1.0)


extends Area2D

enum States {IDLE = 0, MOVING, ROTATING}

const SLERP_SPEED:= 16

var current_state:= 0
var slerp_weight:= 0.0
var start_position: Vector2
var goal_position: Vector2
var previous_direction: Vector2

signal drill(frac_area)
signal drilled_frac
signal move_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = position
	previous_direction = Vector2.RIGHT * Sizes.newTileSize

func change_state(new_state):
	current_state = new_state

func start_move(move_direction: Vector2):
	if move_direction == previous_direction:
		change_state(States.MOVING)
		return
	previous_direction = move_direction
	start_position = position
	goal_position = move_direction
	slerp_weight = 0.0
	change_state(States.ROTATING)

func end_move():
	change_state(States.IDLE)
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
	if current_state == States.IDLE:
		return
	if current_state == States.MOVING and \
			get_parent().sprite.offset.length() < 3:
		change_state(States.IDLE)
	if current_state == States.MOVING:
		global_position = get_parent().sprite.global_position + \
				get_parent().sprite.offset + \
				previous_direction
		return
	self.position = start_position.slerp(goal_position, slerp_weight)
	if slerp_weight == 1:
		end_move()
	slerp_weight += SLERP_SPEED * delta
	slerp_weight = clamp(slerp_weight, 0.0, 1.0)


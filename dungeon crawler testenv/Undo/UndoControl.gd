extends Node
class_name UndoControl

signal starting_undo

@onready var timer = 0
@onready var undoing = false
@onready var curr_max_time = 0
var max_time = 0.5
var time_falloff = 2

var all_items:= []
var all_breakable_tiles:= []
var item_states:= []

class EnemyState:
	var glob_pos: Vector2
	var active: bool
	var is_fallen: bool
	var move_pattern: Array
	var offset: Vector2
	
	func init(_glob_pos: Vector2, _active: bool, _is_fallen: bool, \
			_move_pattern: Array, _offset: Vector2):
		glob_pos = _glob_pos
		active = _active
		is_fallen = _is_fallen
		move_pattern = _move_pattern
		offset = _offset

func init(_all_items: Array):
	all_items = _all_items

func _ready():
	for item in all_items:
		if item.is_in_group("breaking_tile"):
			all_breakable_tiles.append(item)
	update_states()

func update_states():
	var current_state:= {}
	for item in all_items:
		if item.is_in_group("player"):
			current_state[item] = item.global_position
		elif item.is_in_group("drill"):
			current_state[item] = item.position
		elif item.is_in_group("breaking_tile"):
			current_state[item] = item.is_broken
		elif item.is_in_group("enemy"):
			var enemy_state = EnemyState.new()
			enemy_state.init(item.global_position, item.active, item.is_fallen,\
					item.movePattern.duplicate(), item.offset)
			current_state[item] = enemy_state
		elif item.is_in_group("gate"):
			current_state[item] = item.is_open
		elif item.is_in_group("frac_point"):
			current_state[item] = item.is_broken
		elif item.is_in_group("pressure_plate"):
			current_state[item] = item.is_triggered
	item_states.append(current_state)

func _process(delta):
	if (undoing):
		curr_max_time -= (curr_max_time * time_falloff) * delta
		if (timer <= 0):
			undo()
			timer = curr_max_time
		else:
			timer -= delta
	else:
		timer = 0

func undo():
	if len(item_states) < 2:
		return
	item_states.pop_back()
	var previous_state: Dictionary = item_states[-1]
	for item in all_items:
		if item.is_in_group("player"):
			item.global_position = previous_state[item]
		elif item.is_in_group("drill"):
			item.position = previous_state[item]
		elif item.is_in_group("breaking_tile"):
			item.attempt_undo(previous_state[item])
		elif item.is_in_group("enemy"):
			var enemy_state = previous_state[item]
			item.global_position = enemy_state.glob_pos
			item.toggle_activation(enemy_state.active)
			item.movePattern = enemy_state.move_pattern.duplicate()
			item.offset = Vector2.ZERO
			if item.is_fallen and not enemy_state.is_fallen:
				item.unfall()
		elif item.is_in_group("gate"):
			item.attempt_undo(previous_state[item])
		elif item.is_in_group("frac_point"):
			item.attempt_undo(previous_state[item])
		elif item.is_in_group("pressure_plate"):
			if item.is_triggered and not previous_state[item]:
				item.is_triggered = false
	starting_undo.emit()

func _input(event):
	if event.is_action_pressed("undo"):
		undoing = true
		curr_max_time = max_time
	if event.is_action_released("undo"):
		undoing = false


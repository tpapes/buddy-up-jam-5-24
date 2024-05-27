extends Node
class_name UndoControl


var all_items:= []
var item_states:= []

func init(_all_items: Array):
	all_items = _all_items

func _ready():
	update_states()

func update_states():
	var current_state:= {}
	for item in all_items:
		if item.is_in_group("player"):
			current_state[item] = item.global_position
		elif item.is_in_group("drill"):
			current_state[item] = item.global_position
		elif item.is_in_group("breakable_tile"):
			current_state[item] = item.is_broken
		elif item.is_in_group("enemy"):
			current_state[item] = item.global_position
		elif item.is_in_group("gate"):
			current_state[item] = item.is_open
		elif item.is_in_group("frac_point"):
			current_state[item] = item.is_broken
	item_states.append(current_state)

func undo():
	if len(item_states) < 2:
		return
	var previous_state: Dictionary = item_states.pop_back()
	for item in all_items:
		if item.is_in_group("player"):
			item.global_position = previous_state[item]
		elif item.is_in_group("drill"):
			item.global_position = previous_state[item]
		elif item.is_in_group("breakable_tile"):
			item.attempt_undo(previous_state[item])
		elif item.is_in_group("enemy"):
			item.global_position = previous_state[item]
		elif item.is_in_group("gate"):
			item.attempt_undo(previous_state[item])
		elif item.is_in_group("frac_point"):
			item.attempt_undo(previous_state[item])

func _input(event):
	if event.is_action_pressed("undo"):
		undo()


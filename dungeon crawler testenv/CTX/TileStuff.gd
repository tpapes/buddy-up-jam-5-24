extends Node2D

@export var player: Node

var undo_control_pl:= preload("res://Undo/UndoControl.tscn")
var undo_control: UndoControl

func _ready():
	assert(player != null, "player variable must be set in Inspector.")
	prep_undo_control()
	player.move_finished.connect(undo_control.update_states)
	player.drill.drilled_frac.connect(undo_control.update_states)

func prep_undo_control():
	undo_control = undo_control_pl.instantiate()
	var items = get_items(self)
	undo_control.init(items)
	add_child(undo_control)

func get_items(parent_node: Node) -> Array:
	var items:= []
	for child in parent_node.get_children():
		if child.is_in_group("undoable"):
			items.append(child)
		items.append_array(get_items(child))
	return items



extends Node2D

@export var player: Node

var undo_control_pl:= preload("res://Undo/UndoControl.tscn")
var undo_control: UndoControl
var sound_component_pl:= preload("res://SoundComponent/SoundComponent.tscn")
var sound_component: SoundComponent

func _ready():
	assert(player != null, "player variable must be set in Inspector.")
	prep_undo_control()
	prep_sound_component()
	sound_component.play_sound(sound_component.SoundEnum.MENU_CLICK)
	player.move_finished.connect(undo_control.update_states)
	player.drill.drilled_frac.connect(undo_control.update_states)

func prep_undo_control():
	undo_control = undo_control_pl.instantiate()
	var items = get_items(self, "undoable")
	undo_control.init(items)
	add_child(undo_control)

func prep_sound_component():
	sound_component = sound_component_pl.instantiate()
	add_child(sound_component)
	var players = get_items(self, "player")
	for player in players:
		if not player is CharacterBody2D:
			continue
		player.move.connect(func(direction): \
				play_sound(sound_component.SoundEnum.PLAYER_FOOTSTEP))
	var drill = get_items(self, "drill")[0]
	drill.used_drill.connect(play_sound.bind(sound_component.SoundEnum.DRILL))
	drill.drilled_frac.connect(play_sound.bind(sound_component.SoundEnum.FRACTURE_BREAK))
	var gates = get_items(self, "gate")
	for gate in gates:
		gate.opened.connect(play_sound.bind(sound_component.SoundEnum.GATE_OPEN))
	var plates = get_items(self, "pressure_plate")
	for plate in plates:
		plate.triggered.connect(play_sound.bind(sound_component.SoundEnum.PLATE_ON))
	var enemies = get_items(self, "enemy")
	for enemy in enemies:
		enemy.visible_move.connect(play_sound.bind(sound_component.SoundEnum.ENEMY_FOOTSTEP))
	var tiles = get_items(self, "breaking_tile")
	for tile in tiles:
		tile.starting_break.connect(play_sound.bind(sound_component.SoundEnum.FLOOR_FALL))
	undo_control.starting_undo.connect(play_sound.bind(sound_component.SoundEnum.UNDO))

func play_sound(sound_index: int):
	sound_component.play_sound(sound_index)

func get_items(parent_node: Node, group: String) -> Array:
	var items:= []
	for child in parent_node.get_children():
		if child.is_in_group(group):
			items.append(child)
		items.append_array(get_items(child, group))
	return items



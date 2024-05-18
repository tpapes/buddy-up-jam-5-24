extends Node

@onready var player : Node2D
@onready var curr_direction : Vector2
@onready var targ_direction : Vector2
@onready var area = $DrillArea

signal drill(frac_area)

# Called when the node enters the scene tree for the first time.
func _ready():
	curr_direction = Vector2.RIGHT * 32
	targ_direction = curr_direction
	
	player = get_parent()
	if (player != null):
		player.move.connect(_on_player_move)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Ignore if you can't find the player
	if (player == null): pass
	
	# Rotate curr_direction towards targ_direction
	var angle = curr_direction.angle_to(targ_direction)
	curr_direction = curr_direction.rotated(20 * angle * delta)
	curr_direction = curr_direction.normalized() * 32
	targ_direction = targ_direction.normalized() * 32
	
	# Move sprite's position and area's position
	var base_position = player.global_position
	self.global_position = base_position + curr_direction
	area.global_position = base_position + targ_direction
	area.force_update_transform()
	
	# Find and destroy fracture points on input
	if (Input.is_action_just_pressed("use")):
		for n in area.get_overlapping_areas():
			if (n.is_in_group("frac_point")):
				drill.emit(n)

func _on_player_move(dir):
	curr_direction = targ_direction
	targ_direction = dir * 32

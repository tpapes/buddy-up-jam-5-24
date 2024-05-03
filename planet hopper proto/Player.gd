extends CharacterBody2D

signal turn #emitted constantly with directional input
signal new_planet #emitted when colliding with a planet after jumping
signal jump #emitted when ui_accept is pressed

@export var JUMP_SPEED = 100.0
@export var FALL_SPEED = 500.0
@export var TURN_SPEED = 60.0

@onready var player_collision = $CollisionShape2D

var jumping = false #player starts jumping when on a planet and they hit space
var falling = false #player starts falling if they hit a wall
var planet_size:float: #size of active planet, set by Game node
	set(value):
		planet_size = value
		
var target_rotation:float: #rotation value to lerp to
	set(value):
		target_rotation = value


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#stores and sends input
	var turn_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	emit_signal("turn", turn_dir)
	
	#updates rotation every frame
	rotation = lerp_angle(rotation, rotation - (turn_dir * TURN_SPEED), delta) 
	#I don't know why, but the calculation here needs a minus for it 
	#to work correctly, otherwise the directions are flipped -- tpapes
	
	
	var collision_object
	
	if falling and jumping: #if not on planet and wall has been hit, start moving down
		#(falling can only be true when jumping is already true 
		#unless there's an edge case i've missed but i highkey 
		#dont wanna handle it rn)
		global_position.x = lerp(global_position.x, get_viewport_rect().size.x/2, 1 * delta * FALL_SPEED / JUMP_SPEED)
		up_direction = Vector2.UP
		target_rotation = 0
		collision_object = move_and_collide(Vector2.DOWN * delta * FALL_SPEED)
	elif jumping: #if not on planet, move and collide
		collision_object = move_and_collide(up_direction * delta * JUMP_SPEED)		
		
	if collision_object: #if player has collided while in midair
		var collider = collision_object.get_collider()
		if collider is Planet: 
			jumping = false
			falling = false
			#for Game node to use
			emit_signal("new_planet", collider)
			update_offset_from_planet()
			position = Vector2.ZERO
		
		#only called when player hits floor
		elif collider is Floor:
			game_over()
		#if player hits something other than planet or floor (e.g wall)
		else: 
			falling = true

	
func _unhandled_input(event):
	#handle jump input
	if event.is_action_pressed("ui_accept") and jumping == false:
		#adjust trajectory base on where the planet is aiming
		up_direction = Vector2.UP.rotated(global_rotation)
		emit_signal("jump")
		
		#change state so _physics_process can handle the movement
		jumping = true

func game_over():
	get_tree().get_current_scene().free()

func update_offset_from_planet():
	player_collision.position.y = -planet_size*10 - 35 
	# the 35 here comes from the size in px of the 
	# first planet (200px) + the size in px of the player's
	# collision box (60px) - the SIZE value of the first planet
	# times the 10 in the equation
	#
	# -- steps to replace the b in the y=mx+b for this function: --
	# planet_px = size in px of first planet
	# player_px = size of player's collision box
	# planet_default_size = SIZE value of first planet
	# (idk how to get this and store as vars so that's why im making this comment)
	# 
	# equation:
	# b = planet_size*10 - (planet_px/2 + player_px/2 +)
	# add a bit of buffer so that the player isn't riding too close on the planet


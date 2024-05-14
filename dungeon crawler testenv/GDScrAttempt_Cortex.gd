extends Node

@onready var targetPos : Vector2
@onready var inputLog : Vector2
@onready var move_ready : bool
@onready var move_timer : float
@onready var move_fire : bool
@onready var groundCheck = $GroundCheck
@onready var wallCheck = $WallCheck
@onready var foot = $Foot
signal move

# Called when the node enters the scene tree for the first time.
func _ready():
	targetPos = self.position
	inputLog = Vector2.ZERO
	move_ready = true
	move_timer = 0.0
	move_fire = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Get inputs
	if (Input.is_action_just_pressed("left")):
		inputLog.x = -1
	if (Input.is_action_just_pressed("right")):
		inputLog.x = 1
	if (Input.is_action_just_pressed("up")):
		inputLog.y = -1
	if (Input.is_action_just_pressed("down")):
		inputLog.y = 1
	
	# When the player is ready to move, determine the move direction for this step
	if (move_ready):
		
		var direction = Vector2.ZERO
		# The point of this breakdown is so that inputs aren't dropped due to my arbitrary choice in
		# which direction is checked first
		# Start with X direction
		if (inputLog.x != 0 and check_direction(targetPos, Vector2.RIGHT * sign(inputLog.x) * 32)):
			self.position = targetPos
			direction.x += sign(inputLog.x) * 32
			inputLog.x -= sign(inputLog.x)
			move_ready = false
			move_timer = 0.0
			move_fire = false
		# Then check Y direction
		elif (inputLog.y != 0 and check_direction(targetPos, Vector2.DOWN * sign(inputLog.y) * 32)):
			self.position = targetPos
			direction.y += sign(inputLog.y) * 32
			inputLog.y -= sign(inputLog.y)
			move_ready = false
			move_timer = 0.0
			move_fire = false
		# Only forget inputs if neither direction passes
		else:
			inputLog = Vector2.ZERO
		targetPos += direction
	
	# Slide player into target position
	self.position = lerp(self.position, targetPos, 16 * delta)
	
	# Determine if the player is ready to move on next update
	move_ready = move_timer <= 0.0
	
	# Move foot onto target position
	foot.global_position = targetPos
	foot.force_update_transform()
	
	# Signal Elements to move
	if (move_timer <= 0.0 / 2.0 and !move_fire):
		move.emit()
		move_fire = true
	
	# move_fire is basically a timer
	if (move_timer > 0.0): move_timer -= delta

func check_direction(from, direction):
	# Check if there is ground
	groundCheck.global_position = from + direction
	groundCheck.target_position = -direction
	groundCheck.force_raycast_update()
	# Check if the spot is taken
	wallCheck.global_position = from + direction
	wallCheck.target_position = -direction
	wallCheck.force_raycast_update()
	# Return true if there is ground and spot is not taken
	return groundCheck.is_colliding() && !wallCheck.is_colliding()

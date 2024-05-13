extends Node

@onready var targetPos = $Vector2
@onready var inputLog = $Vector2
@onready var move_ready = $bool
@onready var ray = $RayCast2D
@onready var foot = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	targetPos = self.position
	inputLog = Vector2.ZERO
	move_ready = true

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
		# Then check Y direction
		elif (inputLog.y != 0 and check_direction(targetPos, Vector2.DOWN * sign(inputLog.y) * 32)):
			self.position = targetPos
			direction.y += sign(inputLog.y) * 32
			inputLog.y -= sign(inputLog.y)
			move_ready = false
		# Only forget inputs if neither direction passes
		else:
			inputLog = Vector2.ZERO
		targetPos += direction
	
	# Slide player into target position
	self.position = lerp(self.position, targetPos, 16 * delta)
	
	# Determine if the player is ready to move on next update
	move_ready = self.position.distance_to(targetPos) < 4
	
	# Move foot onto target position
	foot.global_position = targetPos

func check_direction(from, direction):
	ray.global_position = from + direction
	ray.target_position = -direction
	ray.force_raycast_update()
	return ray.is_colliding()

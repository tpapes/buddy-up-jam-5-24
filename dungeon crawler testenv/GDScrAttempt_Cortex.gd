extends Node

@onready var targetPos = $Vector2
@onready var inputLog = $Vector2
@onready var move_ready = $bool
@onready var ray = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	targetPos = self.position
	inputLog = Vector2.ZERO
	move_ready = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# get inputs
	if (Input.is_action_just_pressed("left")):
		inputLog += Vector2.LEFT
	if (Input.is_action_just_pressed("right")):
		inputLog += Vector2.RIGHT
	if (Input.is_action_just_pressed("up")):
		inputLog += Vector2.UP
	if (Input.is_action_just_pressed("down")):
		inputLog += Vector2.DOWN
	
	inputLog.x = clampf(inputLog.x, -1, 1)
	inputLog.y = clampf(inputLog.y, -1, 1)
	
	# move target position, if there is a tile in the new position
	if (move_ready):
		var direction = Vector2.ZERO
		if (inputLog.x != 0 and check_direction(targetPos, Vector2.RIGHT * sign(inputLog.x) * 32)):
			direction.x += sign(inputLog.x) * 32
			inputLog.x -= sign(inputLog.x)
		elif (inputLog.y != 0 and check_direction(targetPos, Vector2.DOWN * sign(inputLog.y) * 32)):
			direction.y += sign(inputLog.y) * 32
			inputLog.y -= sign(inputLog.y)
		else:
			direction = Vector2.ZERO
			inputLog = Vector2.ZERO
		targetPos += direction
	
	move_ready = self.position.distance_to(targetPos) < 5
	
	# slide player into target position
	self.position = lerp(self.position, targetPos, 16 * delta)
	
	pass

func check_direction(from, direction):
	ray.global_position = from + direction
	ray.target_position = -direction
	ray.force_raycast_update()
	return ray.is_colliding()

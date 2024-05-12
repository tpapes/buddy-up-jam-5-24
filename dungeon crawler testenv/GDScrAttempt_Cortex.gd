extends Node

@onready var targetPos = $Vector2
@onready var inputLog = $Vector2
@onready var move_ready = $bool

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
		if (inputLog.x != 0):
			targetPos.x += sign(inputLog.x) * 32
			inputLog.x -= sign(inputLog.x)
		else:
			if (inputLog.y != 0):
				targetPos.y += sign(inputLog.y) * 32
				inputLog.y -= sign(inputLog.y)
	
	move_ready = self.position.distance_to(targetPos) < 5
	
	# slide player into target position
	self.position = lerp(self.position, targetPos, 16 * delta)
	
	pass

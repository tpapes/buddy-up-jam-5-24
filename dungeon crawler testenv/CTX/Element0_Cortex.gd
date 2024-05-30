extends Node

@export var pressure_plate: PressurePlate

@onready var player = Node
@onready var move_ready : bool
@onready var targetPos : Vector2
@onready var movePattern = [Vector2.RIGHT]
@onready var moveStep : int
@onready var groundCheck = $GroundCheck
@onready var wallCheck = $WallCheck
@onready var foot = $Foot
@onready var sprite : Sprite2D

var active:= false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(pressure_plate != null, "pressure_plate must be set in the inspector.")
	sprite = self.get_node(".")
	targetPos = self.position
	moveStep = 0
	move_ready = false
	player = get_node("/root/TileStuff/Player_CTX")
	pressure_plate.triggered.connect(toggle_activation.bind(true))

func toggle_activation(toggle: bool):
	if toggle:
		if not player.move.is_connected(_on_player_move):
			player.move.connect(_on_player_move)
	else:
		if player.move.is_connected(_on_player_move):
			player.move.disconnect(_on_player_move)
	active = toggle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not active:
		return
	# When the player is ready to move, determine the move direction for this step
	if (player != null and move_ready and movePattern.size() > 0):
		move_ready = false
		var direction = Vector2.ZERO
		
		for i in movePattern.size():
			if (check_direction(self.global_position, movePattern[moveStep] * 32)):
				direction = movePattern[moveStep] * 32
				break;
			else:
				movePattern[moveStep] *= -1
				if (check_direction(self.global_position, movePattern[moveStep] * 32)):
					direction = movePattern[moveStep] * 32
					break;
				else:
					moveStep = (moveStep + 1) % movePattern.size()
		self.position += direction
		sprite.offset = -direction
		moveStep = (moveStep + 1) % movePattern.size()
		
	
	# Slide into target position
	sprite.offset = lerp(sprite.offset, Vector2.ZERO, 16 * delta)
	if (sprite.offset.length() < 3):
		sprite.offset = Vector2.ZERO
	
	# Move foot onto target position
	foot.global_position = self.global_position
	foot.force_update_transform()
	

func check_direction(from, direction):
	# Check if there is ground
	groundCheck.position = Vector2.ZERO
	groundCheck.target_position = direction
	groundCheck.force_raycast_update()
	# Check if the spot is taken
	wallCheck.position = Vector2.ZERO
	wallCheck.target_position = direction
	wallCheck.force_raycast_update()
	# Return true if there is ground and spot is not taken
	return groundCheck.is_colliding() && !wallCheck.is_colliding()

func _on_player_move(direction):
	move_ready = true

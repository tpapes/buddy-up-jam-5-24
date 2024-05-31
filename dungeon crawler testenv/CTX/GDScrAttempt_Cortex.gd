extends CharacterBody2D

@onready var groundCheck = $GroundCheck
@onready var wallCheck = $WallCheck
@onready var drill = $Drill
@onready var sprite = $Sprite2D
@onready var camera = $Camera2D

const LERP_SPEED:= 16

var startPos : Vector2
var targetPos : Vector2
var lerp_weight:= 0.0
var inputLog:= Vector2.ZERO
var held_directions:= []
var move_ready:= true
var move_timer:= 0.0
var move_fire:= true
var is_moving:= false

signal move(direction)
signal move_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	startPos = self.position
	targetPos = self.position

func check_direction(from: Vector2, direction: Vector2) -> bool:
	for cast in [groundCheck, wallCheck]:
		cast.global_position = from + direction
		cast.target_position = Vector2.DOWN
		cast.force_raycast_update()
	return groundCheck.is_colliding() && !wallCheck.is_colliding()

func _unhandled_input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		return
	if event.is_action_released("left"):
		held_directions.erase(Vector2.LEFT)
	elif event.is_action_released("right"):
		held_directions.erase(Vector2.RIGHT)
	elif event.is_action_released("up"):
		held_directions.erase(Vector2.UP)
	elif event.is_action_released("down"):
		held_directions.erase(Vector2.DOWN)
	if is_moving:
		return
	if inputLog != Vector2.ZERO:
		return
	if event.is_action_pressed("left"):
		inputLog.x = -1
	elif event.is_action_pressed("right"):
		inputLog.x = 1
	elif event.is_action_pressed("up"):
		inputLog.y = -1
	elif event.is_action_pressed("down"):
		inputLog.y = 1
	if not inputLog in held_directions:
		held_directions.append(inputLog)

func update_move_state():
	if is_moving:
		return
	if inputLog == Vector2.ZERO:
		return
	var move_direction = inputLog * Sizes.newTileSize
	if check_direction(global_position, move_direction):
		startPos = global_position
		global_position = global_position + move_direction
		sprite.offset -= move_direction
		is_moving = true
		drill.start_move(move_direction)
		move.emit(move_direction)
	inputLog = Vector2.ZERO

func end_move():
	inputLog = Vector2.ZERO
	lerp_weight = 0.0
	is_moving = false
	if drill.current_state == drill.States.ROTATING:
		await drill.move_finished
	move_finished.emit()

func _physics_process(delta):
	update_move_state()
	if !is_moving:
		return
	sprite.offset = lerp(sprite.offset, Vector2.ZERO, 16 * delta)
	if (sprite.offset.length() < 3):
		end_move()
		sprite.offset = Vector2.ZERO
	#lerp_weight += LERP_SPEED * delta
	#lerp_weight = clamp(lerp_weight, 0.0, 1.0)

func _process(delta):
	if (camera != null):
		camera.position = sprite.offset
	pass

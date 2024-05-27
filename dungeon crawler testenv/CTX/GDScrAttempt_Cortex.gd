extends CharacterBody2D

@onready var groundCheck = $GroundCheck
@onready var wallCheck = $WallCheck
@onready var drill = $Drill

const LERP_SPEED:= 16

var startPos : Vector2
var targetPos : Vector2
var lerp_weight:= 0.0
var inputLog:= Vector2.ZERO
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
		cast.target_position = -direction / 4
		cast.force_raycast_update()
	return groundCheck.is_colliding() && !wallCheck.is_colliding()

func _unhandled_input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		return
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

func update_move_state():
	if is_moving:
		return
	if inputLog == Vector2.ZERO:
		return
	var move_direction = inputLog * Sizes.newTileSize
	if check_direction(global_position, move_direction):
		startPos = global_position
		targetPos = global_position + move_direction
		is_moving = true
		drill.start_move(move_direction)
		move.emit(move_direction)
	inputLog = Vector2.ZERO

func end_move():
	inputLog = Vector2.ZERO
	lerp_weight = 0.0
	is_moving = false
	if drill.is_moving:
		await drill.move_finished
	move_finished.emit()

func _physics_process(delta):
	update_move_state()
	if !is_moving:
		return
	self.global_position = lerp(startPos, targetPos, lerp_weight)
	if lerp_weight == 1:
		end_move()
	lerp_weight += LERP_SPEED * delta
	lerp_weight = clamp(lerp_weight, 0.0, 1.0)



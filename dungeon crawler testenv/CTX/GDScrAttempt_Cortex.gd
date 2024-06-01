extends CharacterBody2D

@onready var groundCheck = $GroundCheck
@onready var wallCheck = $WallCheck
@onready var drill = $Drill
@onready var sprite = $Sprite2D
@onready var camera = $Camera2D

const LERP_SPEED:= 16
const MAX_LATENCY:= 0.05

var step_particles_pl:= preload("res://Particles/StepParticles.tscn")

var startPos : Vector2
var targetPos : Vector2
var lerp_weight:= 0.0
var inputLog:= Vector2.ZERO
var held_directions:= []
var move_ready:= true
var move_timer:= 0.0
var move_fire:= true
var is_moving:= false
var latency:= 0.0

signal move(direction)
signal move_finished
signal add_particles(particles: CPUParticles2D)

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
	inputLog = Vector2.ZERO
	if event.is_action_pressed("left"):
		inputLog.x = -1
	elif event.is_action_pressed("right"):
		inputLog.x = 1
	elif event.is_action_pressed("up"):
		inputLog.y = -1
	elif event.is_action_pressed("down"):
		inputLog.y = 1
	if inputLog != Vector2.ZERO and not inputLog in held_directions:
		held_directions.append(inputLog)
	
	if (event.is_action_pressed("r")):
		get_tree().reload_current_scene()

func update_move_state(delta):
	if is_moving:
		return
	if held_directions.size() == 0:
		latency = 0.0
		return
	if latency > 0.0:
		latency -= delta
		return
	var move_direction = held_directions[-1] * Sizes.newTileSize
	if check_direction(global_position, move_direction):
		make_footstep_particles()
		startPos = global_position
		global_position = global_position + move_direction
		sprite.offset -= move_direction
		is_moving = true
		drill.start_move(move_direction)
		sprite.flip_h = !sprite.flip_h
		move.emit(move_direction)
	inputLog = Vector2.ZERO

func make_footstep_particles():
	if not ground_is_tilemap():
		return
	var particles = step_particles_pl.instantiate()
	particles.init(global_position)
	add_particles.emit(particles)

func ground_is_tilemap() -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, \
			global_position + Vector2.LEFT, 0b1, [self])
	query.collide_with_areas = true
	query.hit_from_inside = true
	var result = space_state.intersect_ray(query)
	if result.is_empty():
		return false
	if result["collider"].is_in_group("breaking_tile"):
		return false
	return true

func end_move():
	inputLog = Vector2.ZERO
	lerp_weight = 0.0
	is_moving = false
	if drill.current_state == drill.States.ROTATING:
		await drill.move_finished
	latency = MAX_LATENCY
	move_finished.emit()

func _physics_process(delta):
	update_move_state(delta)
	if !is_moving:
		return
	sprite.offset = lerp(sprite.offset, Vector2.ZERO, 16 * delta)
	if (sprite.offset.length() < 3):
		end_move()
		sprite.offset = Vector2.ZERO
	#lerp_weight += LERP_SPEED * delta
	#lerp_weight = clamp(lerp_weight, 0.0, 1.0)

func _process(delta):
	
	var rect = sprite.region_rect.position
	var dir = drill.goal_position.normalized()
	if (drill.current_state == drill.States.IDLE):
		dir = drill.position.normalized()
	dir.x = round(dir.x)
	dir.y = round(dir.y)
	
	if (dir == Vector2.UP): rect.x = 32
	elif (dir == Vector2.DOWN): rect.x = 0
	else:
		rect.x = 64
		sprite.flip_h = (dir.x < 0)
	rect.y = 32 if is_moving else 0
	sprite.region_rect.position = rect
	
	if (camera != null):
		camera.position = sprite.offset

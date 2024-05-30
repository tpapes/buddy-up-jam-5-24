extends Node2D
class_name MoveComponent

@export var character: CharacterBody2D

@onready var ground_check:= $GroundCheck
@onready var wall_check:= $WallCheck

signal starting_move(direction: Vector2)
signal move_ended

const LERP_SPEED:= 12

var is_moving:= false
var start_position: Vector2
var end_position: Vector2
var lerp_weight:= 0.0

func _ready():
	assert(character != null, "character must be set by the inspector.")
	ground_check.collision_mask = 0b1
	wall_check.collision_mask = 0b10

func init(_character: CharacterBody2D):
	character = _character

func check_direction(direction: Vector2) -> bool:
	var start_cast: Vector2 = \
			character.global_position + (direction * Sizes.newTileSize)
	var end_cast: Vector2 = start_cast - direction
	var space_state = get_world_2d().direct_space_state
	var colliders = {}
	for layer in [0b1, 0b10]:
		var query = PhysicsRayQueryParameters2D.create(start_cast, end_cast, \
				layer)
		query.collide_with_areas = true
		query.hit_from_inside = true
		var result = space_state.intersect_ray(query)
		if layer == 0b1 and result.is_empty():
			return false
		if layer == 0b10 and not result.is_empty():
			return false
	return true

func attempt_move(direction: Vector2):
	if direction == Vector2.ZERO:
		return
	if is_moving:
		return
	if not check_direction(direction):
		return
	start_position = character.global_position
	end_position = character.global_position + (direction * Sizes.newTileSize)
	is_moving = true
	lerp_weight = 0.0
	starting_move.emit(direction)

func end_move():
	is_moving = false
	move_ended.emit()

func _physics_process(delta):
	if !is_moving:
		return
	character.global_position = lerp(start_position, end_position, lerp_weight)
	if (lerp_weight == 1):
		end_move()
	lerp_weight += LERP_SPEED * delta
	lerp_weight = clamp(lerp_weight, 0.0, 1.0)





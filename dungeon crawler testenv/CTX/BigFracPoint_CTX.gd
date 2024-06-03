extends Sprite2D

enum ShakeStates {IDLE = 0, FIRST, SECOND, THIRD}

@export var health:= 1

@onready var drill_obj : Node2D
@onready var area = $Area2D
@onready var collision:= $Area2D
@onready var particles:= [$BackParticles, $FrontParticles]

signal just_broke
signal finish_game

const SHAKE_LENGTH:= 3
const SHAKE_SPEED:= 100
const SCALE_DIMINISH_FACTOR:= 0.96

var is_broken:= false
var shaking:= 0
var shake_lerp = 0
var original_scale: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	drill_obj = get_node("/root/TileStuff/Player_CTX/Drill")
	if (drill_obj != null):
		drill_obj.drill.connect(_on_drill_break)
	for particle in particles:
		particle.one_shot = true
		particle.emitting = false
	original_scale = scale

func attempt_undo(prev_health: int):
	if prev_health == 0 and health > 0:
		break_frac()
	elif prev_health > 0 and health == 0:
		unbreak_frac()
	if prev_health == health + 1:
		pass
		#scale /= SCALE_DIMINISH_FACTOR
		#collision.scale *= SCALE_DIMINISH_FACTOR
	health = prev_health

func break_frac():
	shake_lerp = 1
	health -= 1
	if health > 0:
		shaking = ShakeStates.FIRST
		#scale *= SCALE_DIMINISH_FACTOR
		#collision.scale /= SCALE_DIMINISH_FACTOR
		return
	var spr : Sprite2D = self.get_node(".")
	var p = spr.region_rect.position + Vector2.RIGHT * 32
	var s = spr.region_rect.size
	spr.region_rect = Rect2(p, s)
	self.z_index = 0
	self.name = "Broken_FracPoint_CTX"
	is_broken = true
	offset.x = 0
	shaking = 0
	scale = original_scale
	collision.scale = Vector2.ONE
	for particle in particles:
		particle.emitting = true
	just_broke.emit()

func unbreak_frac():
	region_rect.position.x -= 32
	is_broken = false

func _on_drill_break(frac_area):
	if (frac_area == area and !is_broken):
		break_frac()
		#self.reparent(get_parent().get_parent())
		#print("borken")

func shake_process(delta):
	if shaking == ShakeStates.IDLE:
		return
	var direction = -1
	if shaking == ShakeStates.SECOND:
		direction = 1
	offset.x = SHAKE_LENGTH * shake_lerp * sin(shake_lerp * SHAKE_SPEED) 
	#if offset.length() > SHAKE_LENGTH and (shaking == ShakeStates.FIRST or \
			#shaking == ShakeStates.SECOND):
		#shaking += 1
		#return
	#if offset.length() < 0.5 and shaking == ShakeStates.THIRD:
	if (shake_lerp <= 0):
		shaking = ShakeStates.IDLE
		shake_lerp = 0

func _process(delta):
	var spr:Sprite2D = self
	spr.frame = 3 - health
	shake_process(delta)
	shake_lerp -= delta * 5
	if (shake_lerp > 0):
		spr.frame = 3
	elif (health <= 0):
		await get_tree().create_timer(1).timeout
		finish_game.emit()

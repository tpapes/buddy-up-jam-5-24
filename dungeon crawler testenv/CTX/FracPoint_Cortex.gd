extends Sprite2D

enum ShakeStates {IDLE = 0, FIRST, SECOND, THIRD}

@export var health:= 1

@onready var drill_obj : Node2D
@onready var area = $Area2D
@onready var particles:= [$BackParticles, $FrontParticles]

signal just_broke

const SHAKE_LENGTH:= 2
const SHAKE_SPEED:= 40

var is_broken:= false
var shaking:= 0

# Called when the node enters the scene tree for the first time.
func _ready():
	drill_obj = get_node("/root/TileStuff/Player_CTX/Drill")
	if (drill_obj != null):
		drill_obj.drill.connect(_on_drill_break)
	for particle in particles:
		particle.one_shot = true
		particle.emitting = false

func attempt_undo(prev_health: int):
	if prev_health == 0 and health > 0:
		break_frac()
	elif prev_health > 0 and health == 0:
		unbreak_frac()
	health = prev_health

func break_frac():
	health -= 1
	if health > 0:
		shaking = ShakeStates.FIRST
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
	offset.x += delta * direction * SHAKE_SPEED
	if offset.length() > SHAKE_LENGTH and (shaking == ShakeStates.FIRST or \
			shaking == ShakeStates.SECOND):
		shaking += 1
		return
	if offset.length() < 0.5 and shaking == ShakeStates.THIRD:
		shaking = ShakeStates.IDLE

func _process(delta):
	shake_process(delta)


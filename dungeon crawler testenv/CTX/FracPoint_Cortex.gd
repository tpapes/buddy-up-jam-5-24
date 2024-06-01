extends Sprite2D
class_name FracturePoint

@export var health:= 1

@onready var drill_obj : Node2D
@onready var area = $Area2D
@onready var collision:= $Area2D
@onready var particles:= [$BackParticles, $FrontParticles]

signal just_broke

var is_broken:= false

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
		return
	var spr : Sprite2D = self.get_node(".")
	var p = spr.region_rect.position + Vector2.RIGHT * 32
	var s = spr.region_rect.size
	spr.region_rect = Rect2(p, s)
	self.z_index = 0
	self.name = "Broken_FracPoint_CTX"
	is_broken = true
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

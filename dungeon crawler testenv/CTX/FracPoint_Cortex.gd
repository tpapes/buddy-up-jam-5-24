extends Sprite2D

@onready var drill_obj : Node2D
@onready var area = $Area2D

var is_broken:= false

# Called when the node enters the scene tree for the first time.
func _ready():
	drill_obj = get_node("/root/TileStuff/Player_CTX/Foot/Drill")
	if (drill_obj != null):
		drill_obj.drill.connect(_on_drill_break)

func attempt_undo(was_broken: bool):
	if was_broken and !is_broken:
		break_frac()
	elif !was_broken and is_broken:
		unbreak_frac()

func break_frac():
	var spr : Sprite2D = self.get_node(".")
	var p = spr.region_rect.position + Vector2.RIGHT * 32
	var s = spr.region_rect.size
	spr.region_rect = Rect2(p, s)
	self.z_index = 0
	self.name = "Broken_FracPoint_CTX"
	is_broken = true

func unbreak_frac():
	region_rect.position.x -= 32
	is_broken = false

func _on_drill_break(frac_area):
	if (frac_area == area and !is_broken):
		break_frac()
		#self.reparent(get_parent().get_parent())
		#print("borken")

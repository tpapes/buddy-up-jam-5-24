extends Node

@onready var drill_obj : Node2D
@onready var area = $Area2D
@onready var broken : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	broken = false
	drill_obj = get_node("/root/TileStuff/Player_CTX/Foot/Drill")
	if (drill_obj != null):
		drill_obj.drill.connect(_on_drill_break)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_drill_break(frac_area):
	if (frac_area == area and !broken):
		var spr : Sprite2D = self.get_node(".")
		var p = spr.region_rect.position + Vector2.RIGHT * 32
		var s = spr.region_rect.size
		spr.region_rect = Rect2(p, s)
		self.z_index = 0
		self.name = "Broken_FracPoint_CTX"
		broken = true
		#self.reparent(get_parent().get_parent())
		#print("borken")

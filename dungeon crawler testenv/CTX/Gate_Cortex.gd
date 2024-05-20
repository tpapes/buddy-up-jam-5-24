extends Sprite2D

@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var c = self.find_child("FracPoint_CTX*")
	if (c == null and area != null):
		area.get_node(".").queue_free()
		var spr : Sprite2D = self
		var p = spr.region_rect.position + Vector2.RIGHT * 96
		var s = spr.region_rect.size
		spr.region_rect = Rect2(p, s)
		self.z_index = 1
		#print("borken")
	pass

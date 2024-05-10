extends Node2D

@export var movement:Movement
var charging:bool = false
@export var trip:RayCast2D
var dir:Vector2 = Vector2.RIGHT
# Called when the node enters the scene tree for the first time.
func _ready():
	MovementServer.player_moved.connect(on_player_step)
	pass # Replace with function body.

func _draw():
	draw_line(Vector2.ZERO,trip.get_collision_point(),Color.RED)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#assert(!trip.is_colliding())
	#pass

func on_player_step(_dir:Vector2):
	if charging: charge(); return;
	trip.force_raycast_update()
	print(trip.is_colliding())
	if trip.is_colliding():
		charging = true
		charge();

func charge():
	if movement.check_move(dir):
		movement.move(dir,0.1)
	else:
		charging = false
	pass

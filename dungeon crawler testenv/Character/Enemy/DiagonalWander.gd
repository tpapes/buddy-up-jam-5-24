extends Node

@export var movement:Movement
@export var timer:Timer
var targetDirection:Vector2 = Vector2(1,1)
@export var movement_time:float
@export var delay:float
# Called when the node enters the scene tree for the first time.
func _ready():
	movement.movement_finished.connect(start_delay)
	timer.timeout.connect(full_move)
	timer.wait_time = delay
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func start_delay()->void:
	timer.start()

func full_move()->void:
	#TODO: if target direction becomes 0 on an axis we're in a 
	# cooridoor but we should check if we're out after moving
	
	if !movement.check_move(Vector2(targetDirection.x,0)):
		targetDirection.x *= -1;
		if !movement.check_move(Vector2(targetDirection.x,0)):
			targetDirection.x = 0;
			
	if !movement.check_move(Vector2(0,targetDirection.y)):
		targetDirection.y *= -1;
		if !movement.check_move(Vector2(0,targetDirection.y)):
			targetDirection.y = 0;

	movement.move(targetDirection,movement_time)

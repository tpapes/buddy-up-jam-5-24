extends Node
@export var movement:Movement
@export var inventory:Inventory
@export var currentItem:Item
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass

func _unhandled_input(event):
	if event.is_action_pressed("up"):
		full_move(Vector2.UP)
		
	if event.is_action_pressed("left"):
		full_move(Vector2.LEFT)
		
	if event.is_action_pressed("right"):
		full_move(Vector2.RIGHT)
		
	if  event.is_action_pressed("down"):
		full_move(Vector2.DOWN)
	
	if event.is_action_pressed("use"):
		currentItem.use()


func full_move(dir:Vector2,buffered:bool=false):
	
	#Stop movement on collision
	if !movement.check_move(dir):
		return
	
	#If in the middle of a previous movement, buffer
	if movement.moving:
		await movement.movement_finished
		if buffered: return #only buffer once
		full_move(dir,true) #try again
		return
	#Move if 
	movement.move(dir,0.16)

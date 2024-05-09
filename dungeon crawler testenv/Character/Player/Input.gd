extends Node
@export var movement:Movement
var inventory:Inventory
	#set(value):
		#if inventory: inventory.disconnect("item_activated", _on_inventory_item_activated)
		#inventory = value
		#inventory.connect("item_activated", _on_inventory_item_activated)
var currentItem:Node
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory = get_tree().get_first_node_in_group("Inventory")
	inventory.connect("item_activated", _on_inventory_item_activated)
	inventory.player = get_parent()
	currentItem = inventory.item_map[inventory.last_selected]
	inventory.level_start()
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
		if currentItem: currentItem.use(currentItem)
	
	if event.is_action_pressed("r"):
		get_tree().reload_current_scene()



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


func _on_inventory_item_activated(index):
	currentItem = inventory.item_map[index]
	
	pass # Replace with function body.

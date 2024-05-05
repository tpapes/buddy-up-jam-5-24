extends ItemList
class_name Inventory

@export var inventory_size:int = 100:
	set(value):
		inventory_size = value
@export var starting_items:Array[Item]

@onready var audio = $AudioStreamPlayer

var item_map = {}
var last_selected:int = 0

func _ready():
	connect("item_selected", select_item)
	connect("item_activated", activate_item)
	for item in starting_items:
		add(item)

func toggle():
	visible = !visible
	if visible:
		if item_count > 0:
			select(last_selected)
			audio.play_open()
			grab_focus()
	else:
		audio.play_close()

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		toggle()
	if visible and event.is_action_pressed("test"):
		var item = load("res://Items/Test_Item.tres")
		add(item)

func add(item):
	var index = add_item(item.get("item_name"), item.get("texture"))
	var script = item.get("action").new()
	add_child(script)
	item_map[index] = script

func select_item(item_ind:int):
	last_selected = item_ind

func activate_item(item_ind:int):
	toggle()
	print(item_ind)

extends ItemList
class_name Inventory


@export var inventory_size:int = 100:
	set(value):
		inventory_size = value
@export var item_list:Array[Item]

var last_selected:int = 0

func _ready():
	connect("item_selected", select_item)

func toggle():
	visible = !visible

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle()
	if visible and event.is_action_pressed("test"):
		var item = load("res://Test_Item.tres")
		add_item(item.get("item_name"), item.get("texture"))

func select_item(item_ind):
	print(item_ind)

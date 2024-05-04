extends Resource
class_name Item

@export var item_name:String:
	get:
		return item_name
@export var texture:Texture:
	get:
		return texture
@export var action:Script

func use():
	action.use(self)

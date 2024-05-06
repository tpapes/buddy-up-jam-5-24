extends Item_Script

const CHARACTER_SCENE = preload("res://Character/Player/Player.tscn")
func use(item):
	get_tree().root.add_child(CHARACTER_SCENE.instantiate())

	print("This is a different Item!")

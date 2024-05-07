extends Item_Script

var bullet_preload:PackedScene = preload("res://Weapon/Bullet.tscn")

func use(_item):
	var direction = player.movement.current_direction
	var bullet = bullet_preload.instantiate()
	bullet.init(player.global_position, direction)
	add_child(bullet)


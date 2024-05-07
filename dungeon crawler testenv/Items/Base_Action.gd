extends Node
class_name Item_Script

var player:Player

func init(_player:Player):
	player = _player

func use(_item):
	print(name + ".use() not implemmented")

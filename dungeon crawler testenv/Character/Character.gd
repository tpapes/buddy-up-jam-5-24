extends Node2D
class_name Player

@onready var footstep = $Footstep
@onready var movement:Movement = $RayCast2D

func _ready():
	movement.connect("movement_started", footstep.play)

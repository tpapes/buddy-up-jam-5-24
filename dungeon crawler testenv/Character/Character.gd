extends Node2D

@onready var footstep = $Footstep
@onready var movement = $RayCast2D

func _ready():
	movement.connect("movement_started", footstep.play)

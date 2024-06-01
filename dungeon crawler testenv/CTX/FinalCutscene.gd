extends Camera2D

signal explode
@onready var explosion:CPUParticles2D = $Explosion
var time = 1
var game_pl:= preload("res://Menus/MainMenu.tscn")

func _ready():
	Music.stop()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (time <= 0):
		explode.emit()
		explosion.emitting = true
	
	if (time <= -3.5):
		get_tree().change_scene_to_packed(game_pl)
	
	time -= delta

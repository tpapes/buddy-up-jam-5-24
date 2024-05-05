extends Control

@onready var MASTER_BUS_INDEX = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_INDEX = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_INDEX = AudioServer.get_bus_index("SFX")

func _ready():
	var volume = 10
	AudioServer.set_bus_volume_db(MASTER_BUS_INDEX, linear_to_db(volume))
	AudioServer.set_bus_volume_db(MUSIC_BUS_INDEX, linear_to_db(volume))
	AudioServer.set_bus_volume_db(SFX_BUS_INDEX, linear_to_db(volume))
	

func toggle():
	visible = !visible

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle()

func _on_master_volume_slider_changed(value):
	AudioServer.set_bus_volume_db(MASTER_BUS_INDEX, linear_to_db(value))
	AudioServer.set_bus_mute(MASTER_BUS_INDEX, value < 1)

func _on_music_volume_slider_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_INDEX, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_INDEX, value < 1)

func _on_sfx_volume_slider_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_INDEX, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_INDEX, value < 1)



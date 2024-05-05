extends AudioStreamPlayer

@export var open_sound:AudioStreamWAV
@export var close_sound:AudioStreamWAV

func play_open():
	stream = open_sound
	play()

func play_close():
	stream = close_sound
	play()

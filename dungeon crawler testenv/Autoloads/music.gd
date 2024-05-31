extends Node

@onready var theme_techno:= $TechnoTheme
@onready var theme:= $NotTechnoTheme

func _ready():
	for song in [theme_techno, theme]:
		song.finished.connect(repeat_theme.bind(song))

func play_theme():
	theme_techno.stop()
	if theme.playing:
		return
	theme.play()

func switch_themes():
	if not theme.playing and not theme_techno.playing:
		theme_techno.play()
		return
	if not theme.playing:
		return
	var playback_position = theme.get_playback_position()
	theme.stop()
	theme_techno.play(playback_position)

func repeat_theme(theme):
	theme.play()


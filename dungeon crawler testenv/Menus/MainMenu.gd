extends Node2D

@onready var main_canvas:= $MainCanvas
@onready var help_canvas:= $HelpCanvas
@onready var credits_canvas:= $CreditsCanvas
@onready var play_button:= $MainCanvas/VBoxContainer/Play
@onready var help_button:= $MainCanvas/VBoxContainer/Help
@onready var credits_button:= $MainCanvas/VBoxContainer/Credits
@onready var back_buttons:= [$HelpCanvas/Back,$CreditsCanvas/Back]
@onready var button_sound:= $ButtonSound

var game_pl:= preload("res://CTX/TileStuff.tscn")

func _ready():
	help_button.pressed.connect(show_menu.bind(help_canvas))
	credits_button.pressed.connect(show_menu.bind(credits_canvas))
	play_button.pressed.connect(start_game)
	for button in back_buttons:
		button.pressed.connect(show_menu.bind(main_canvas))
	connect_button_sounds(self)
	show_menu(main_canvas)

func show_menu(menu: CanvasLayer):
	for canvas in [main_canvas, help_canvas, credits_canvas]:
		canvas.hide()
	menu.show()

func connect_button_sounds(node: Node):
	for child in node.get_children():
		if child is Button and not child==play_button:
			child.pressed.connect(button_sound.play)
		connect_button_sounds(child)

func start_game():
	get_tree().change_scene_to_packed(game_pl)



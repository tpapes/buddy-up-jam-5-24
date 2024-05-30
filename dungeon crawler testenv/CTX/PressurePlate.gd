extends Area2D
class_name PressurePlate


signal triggered

var is_triggered:= false

func _ready():
	add_to_group("pressure_plate")
	add_to_group("undoable")
	body_entered.connect(trigger_plate)

func trigger_plate(body):
	if is_triggered:
		return
	if !body.is_in_group("player"):
		return
	is_triggered = true
	triggered.emit()


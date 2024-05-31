extends Node
class_name SoundComponent

enum SoundEnum {PLAYER_FOOTSTEP, ENEMY_FOOTSTEP, MENU_CLICK, FINISHED_GAME, \
		PLATE_ON, PLATE_OFF, DRILL, GATE_OPEN, FRACTURE_BREAK, FLOOR_FALL,
		UNDO}

@onready var sounds:= {
	SoundEnum.PLAYER_FOOTSTEP: $PlayerFootstep,
	SoundEnum.ENEMY_FOOTSTEP: $EnemyFootstep,
	SoundEnum.MENU_CLICK: $MenuClick,
	SoundEnum.FINISHED_GAME: $FinishedGame,
	SoundEnum.PLATE_ON: $PressurePlateOn,
	SoundEnum.PLATE_OFF: $PressurePlateOff,
	SoundEnum.DRILL: $Drill,
	SoundEnum.GATE_OPEN: $GateOpen,
	SoundEnum.FRACTURE_BREAK: $FractureBreak,
	SoundEnum.FLOOR_FALL: $FloorFall,
	SoundEnum.UNDO: $Undo
}

func play_sound(sound: int):
	sounds[sound].play()



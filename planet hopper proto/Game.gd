extends Node2D

@export var MIN_SPAWN_TIME = 1.0 #lowest amount of time a planet can take
@export var MAX_SPAWN_TIME = 3.0 # ^^ but highest

@export var MIN_PLANET_SCALE = 0.5 #smallest planet scale as ratio of original scale
@export var MAX_PLANET_SCALE = 1.5 # ^^ but largest 

@onready var player = $planet/Player
@onready var planet = $planet
@onready var planet_scene = load("res://planet.tscn")

var spawners:Array #holds references to each spawner node
var waiting = false #stores whether a spawn timer is running to avoid dupes

var playing:bool:
	set(value):
		if value != playing:
			for node in get_tree().get_nodes_in_group("planet"):
				node.set("playing", true)
			playing = value 
# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("new_planet", _on_planet_changed)
	player.connect("jump", _on_jump)
	player.set("planet_size", planet.SIZE)
	player.update_offset_from_planet()
	for node in get_tree().get_nodes_in_group("spawner"):
		spawners.append(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and not waiting: #if game has started and no spawn timers are running
		#spawn new planets infinitely
		#creates timer, sets spawn time, and adds to tree so it starts
		var timer = Timer.new()
		timer.autostart = true
		timer.wait_time = randf_range(MIN_SPAWN_TIME, MAX_SPAWN_TIME)
		add_child(timer)
		
		
		waiting = true #avoids multiple timers starting
		await timer.timeout #waits for timer to end to spawn
		waiting = false
		
		#spawn planet
		var new_planet = planet_scene.instantiate()
		new_planet.set("playing", true)
		spawners[randi_range(0, spawners.size() - 1)].add_child(new_planet)
		
		#scales planets randomly (must happen after spawning
		#so that planet can set up @onready vars)
		var scale_ratio = randf_range(MIN_PLANET_SCALE, MAX_PLANET_SCALE)
		new_planet.update_scale(scale_ratio)


func _on_planet_changed(new_planet): #called when player hits new planet
	planet = new_planet #stores new planet in memory
	player.set("planet_size", planet.SIZE) #updates planet size so player knows how far to sit
	remove_child(player)
	planet.add_child(player)

func _on_jump(): #called when player jumps
	set("playing", true) #start game/movement/everything
	
	#store player position and set it later to avoid the reset 
	#that comes with changing parents
	var prepos = player.global_position
	var prerot = player.global_rotation
	
	planet.remove_child(player)
	
	#add player as child of Game so it doesn't disappear for not having a parent
	add_child(player)
	
	#put back the position info we stored
	player.global_position = prepos
	player.global_rotation = prerot
	
	#change the player's target rotation so that it doesn't rotate back
	player.set("target_rotation", prerot)


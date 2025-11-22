extends Node2D
var current_level: Node2D = null
var levels: Dictionary = {
	"Infinity":preload("res://scenes/infinity.tscn"),
"Training":preload("res://scenes/training_level1.tscn"),
}
var player = null
var camera = null 



#@onready var staticbox_animation = get_node("TrainingLevel/Static/StaticBox/AnimationPlayer")
@onready var dude = get_node("PhysicsDude")
@onready var menu: Node = $ui/Menu
@onready var hud: Node = $ui/Hud
var player_scene = preload("res://scenes/physics_dude.tscn")
@onready var world: Node = $World


func _ready() -> void:
	player = player_scene.instantiate()
	camera = player.get_node("Camera2D")
	world.add_child(player)
	menu.update_levels(levels.keys())
	load_level(levels.keys()[0])
	menu.level_changed.connect(load_level)
	load_settings()

#func _on_hit_static_box():
	#staticbox_animation.play("hit")
func load_level(name):
	if current_level:
		current_level.queue_free()
	current_level = levels[name].instantiate()
	world.add_child(current_level)
	print(player.global_position)
	player.global_position = current_level.get_node("Spawn").global_position
	match name:
		"Training": camera.enabled=false
		"Infinity":
			camera.enabled=true
			camera.limit_left=0
			camera.limit_top=0
			camera.limit_bottom=648
			current_level.camera = camera
			current_level.player = player
			current_level.hud = hud
func save_settings():
	var config = ConfigFile.new()
	var slider: HSlider = menu.get_node("CenterContainer/VBoxContainer/HBoxContainer/HSlider")
	config.set_value("audio","volume",slider.value)
	config.save("user://dude.cfg")
func load_settings():
	var config = ConfigFile.new()
	var error = config.load("user://dude.cfg")
	if error==OK:
		var slider: HSlider = menu.get_node("CenterContainer/VBoxContainer/HBoxContainer/HSlider")
		var volume = config.get_value("audio","volume",0.0)
		slider.value = volume
				

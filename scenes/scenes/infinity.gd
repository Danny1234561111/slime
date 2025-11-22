extends Node2D

#@onready var dude = get_node("PhysicsDude")
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var spawn:Marker2D = $Spawn
@onready var platforms = $Platforms
@onready var priz = $Priz_node
@export var platform_scene: PackedScene
@export var offscreen_distance:float =300
@export var min_gap:float =50
@export var max_gap:float =150
@export var min_y:float =300
@export var max_y:float =500
var chet:int =0
var camera: Camera2D
var player: CharacterBody2D
var hud: Node
var spawned_platforms: Array[Node]=[]
var right_x: float = 0.0
var left_x:float = 0.0
var died:bool
func _on_player_died():
	print("alo")
	died=true
func _ready() -> void:
	#dude.hit.connect(_on_hit_static_box)
	#audio_player.stream = load("res://audio/background.ogg")
	audio_player.play()
	if platform_scene:
		_spawn_platform(spawn.global_position.x,1)
func _process(delta):
	#print("Platform: ",spawned_platforms.size())
	if not camera or not player or not platform_scene:
		return
	if (player):
		if(player.has_signal("died")):
			player.died.connect(_on_player_died)
	var screen_size = get_viewport_rect().size
	var camera_position = camera.global_position
	var half_w = screen_size.x/2
	var left_edge = camera_position.x - half_w
	var right_edge = camera_position.x + half_w
	var k:int =0
	var finish:int =0
	
	while right_x<right_edge*offscreen_distance:
		chet+=1
		
			
		k=randi_range(0,2)
		max_gap=max_gap*1.1
		_spawn_platform(right_x+randi_range(min_gap,max_gap),k)
		right_x = spawned_platforms[-1].position.x
	for i in range(spawned_platforms.size()-1,-1,-1):
		var platform = spawned_platforms[i]
		if platform.position.x<left_edge - offscreen_distance:
			platform.queue_free()
			spawned_platforms.remove_at(i)
	if died:
		died=false
		hud.update_health()
		for plat in spawned_platforms:
			print(max_gap)
			var dop_x = 100+max_gap/1500
			if plat.global_position.x-dop_x<player.global_position.x and plat.global_position.x+dop_x>player.global_position.x:
				player.global_position.x=plat.global_position.x
				player.global_position.y= spawn.global_position.y
func _spawn_platform(x:float,k:int):
	if not platform_scene:
		return
	var platform = platform_scene.instantiate()
	if k%2==0:
		platform.max_x = randi_range(30,100)+x
		platform.min_x = x
	platform.position.x = x
	platform.position.y = randi_range(min_y,max_y)
	if (chet==10):
		if (priz):
			priz.global_position.y = platform.position.y-20
			priz.global_position.x = platform.position.x
	
	platforms.add_child(platform)
	spawned_platforms.append(platform)
	
	
	
	

				

extends StaticBody2D

@export var min_x:float
@export var max_x:float
var state="left"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not max_x:
		return
	if state=="left":
		if (global_position.x<=max_x):
			global_position.x=global_position.x+1
		else:
			state="right"
	else:
		if (global_position.x>=min_x):
			global_position.x=global_position.x-1
		else:
			state="left"
	

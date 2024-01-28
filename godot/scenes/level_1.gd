extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_animation_name = "elevator_movement"
	animation_player.play(current_animation_name)
	var animation = animation_player.get_animation(current_animation_name)
	animation.loop_mode = Animation.LOOP_LINEAR

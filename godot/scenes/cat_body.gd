extends Node2D

@export var head_texture: CompressedTexture2D
@export var body_texture: CompressedTexture2D
@export var body_action_texture: CompressedTexture2D
@export var tail_texture: CompressedTexture2D
# We cannot set Animation, but must use a string
@export var current_animation_name: String

@onready var head: Sprite2D = $Head
@onready var body: Sprite2D = $Body
@onready var tail: Sprite2D = $Tail
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if tail_texture:
		tail.texture = tail_texture
	if body_texture:
		body.texture = body_texture
	# Alwats overwrite action
	if body_action_texture:
		body.texture = body_action_texture
	if head_texture:
		head.texture = head_texture
	if not current_animation_name.is_empty():
		animation_player.play(current_animation_name)
		var animation = animation_player.get_animation(current_animation_name)
		animation.loop_mode = Animation.LOOP_LINEAR


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

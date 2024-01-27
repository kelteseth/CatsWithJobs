extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0
@export var max_player_units_moved: float = 1000
@export var phantom_camera: PhantomCamera2D
@export var player_id = 0
@export var plazer_image_left: CompressedTexture2D
@export var plazer_image_right: CompressedTexture2D
@onready var animation_player = $AnimationPlayer
@onready var player_image = $PlayerImage
var input_active = false
var last_position = Vector2()
var total_distance_moved: float = 0.0

signal turn_done(player_id)
signal player_moved(player_id, units_moved)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func set_player_active(is_active):
	input_active = is_active
	var idle_anim = animation_player.get_animation("idle")
	if is_active:
		phantom_camera.set_priority(1)
		last_position = position
		total_distance_moved = 0
		animation_player.play("idle")
		idle_anim.loop_mode = Animation.LOOP_LINEAR
	else:
		phantom_camera.set_priority(0)
		total_distance_moved = 0
		animation_player.stop()
		
func calc_distance_traveled():
	var distance_this_frame = position.distance_to(last_position)
	total_distance_moved += distance_this_frame

	# Update last position for the next frame
	last_position = position
	var percentage_moved = floor((total_distance_moved / max_player_units_moved)* 100)
	player_moved.emit(player_id, percentage_moved)

	#print("Total distance moved: ", total_distance_moved, " units")
	
func _ready():
	last_position = position
	
	
func _physics_process(delta):
	if not input_active:
		return 

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("jump")

	calc_distance_traveled()

	# Handle movement/deceleration.
	var direction = 0
	if Input.is_action_pressed("move_left_p" + str(player_id)):
		direction -= 1
	if Input.is_action_pressed("move_right_p" + str(player_id)):
		direction += 1

	if direction != 0:
		velocity.x = direction * SPEED
		if direction < 0:
			player_image.texture = plazer_image_left
		if direction > 0:
			player_image.texture = plazer_image_right
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# We are done when we reached max movement. There is
	if total_distance_moved >= max_player_units_moved:
		input_active = false
		turn_done.emit(player_id)
	

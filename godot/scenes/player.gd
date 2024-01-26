extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0
@export var max_player_units_moved: float = 1000
@export var phantom_camera: PhantomCamera2D
@export var player_id = 0
@onready var animation_player = $AnimationPlayer
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
	
	if not  input_active:
		return 
		
	calc_distance_traveled()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# We are done when we reached max movement. There is
	if total_distance_moved >= max_player_units_moved:
		input_active = false
		turn_done.emit(player_id)
	

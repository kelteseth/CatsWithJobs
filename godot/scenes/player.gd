extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
@export var max_player_units_moved: float = 300
@export var phantom_camera: PhantomCamera2D
@export var player_id = 0
@export var plazer_image_left: CompressedTexture2D
@export var plazer_image_right: CompressedTexture2D
@onready var cat_body_left = $CatBodyLeft
@onready var cat_body_right = $CatBodyRight
@onready var gun_pos_right = $GunPosRight
@onready var gun_pos_left = $GunPosLeft
@onready var target_cursor:Sprite2D = $TargetCursor
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
var input_active = false
var last_position = Vector2()
var total_distance_moved: float = 0.0
var cursor_speed = 200

var has_gun = false
var bullet_count = 5

var movement_direction = MovementDirection.INVALID
enum MovementDirection {INVALID, LEFT, RIGHT}

signal turn_done(player_id)
signal player_moved(player_id, units_moved)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func set_player_active(is_active):
	input_active = is_active
	if is_active:
		phantom_camera.set_priority(1)
		last_position = position
		total_distance_moved = 0
	else:
		phantom_camera.set_priority(0)
		total_distance_moved = 0
		
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
	self.visible = false
	await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
	$AudioStreamPlayerSpawnSound.play()
	self.visible = true

func move_cusor(delta: float):
	# Construct input action names based on player_id
	var move_right_action = "target_right_p" + str(player_id)
	var move_left_action = "target_left_p" + str(player_id)
	var move_down_action = "target_down_p" + str(player_id)
	var move_up_action = "target_up_p" + str(player_id)

	# Get input from the joystick
	var input_vector = Vector2(
		Input.get_action_strength(move_right_action) - Input.get_action_strength(move_left_action),
		Input.get_action_strength(move_down_action) - Input.get_action_strength(move_up_action)
	)

	# Normalize the vector to have a consistent movement speed in all directions
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

	# Define the speed of the cursor
	var speed = 500  # Adjust the speed as necessary

	# Update the position
	target_cursor.position += input_vector * speed * delta
	
	if has_gun:
		set_gun_enabled(true)
		
	gun_pos_right.look_at(target_cursor.global_position)
	gun_pos_left.look_at(target_cursor.global_position)
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	cat_body_left.set_sleeping(not input_active)
	cat_body_right.set_sleeping(not input_active)

	# Handle jump.
	if input_active and Input.is_action_just_pressed("jump_p" + str(player_id)) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AudioStreamPlayerJump.play(0.05)
		

	# Handle movement/deceleration.
	var direction = 0
	if input_active and Input.is_action_pressed("move_left_p" + str(player_id)):
		direction -= 1
		if not $AudioStreamPlayerSteps.playing:
			$AudioStreamPlayerSteps.play()
		cat_body_left.visible = true
		cat_body_right.visible = false
		movement_direction = MovementDirection.LEFT
	if input_active and Input.is_action_pressed("move_right_p" + str(player_id)):
		direction += 1
		if not $AudioStreamPlayerSteps.playing:
			$AudioStreamPlayerSteps.play()
		cat_body_left.visible = false
		cat_body_right.visible = true
		movement_direction = MovementDirection.RIGHT
		
	if input_active and has_gun and Input.is_action_just_pressed("shoot_p" + str(player_id)):
		shoot()

	calc_distance_traveled()
	
	if input_active:
		move_cusor(delta)

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# We are done when we reached max movement. There is
	if total_distance_moved >= max_player_units_moved:
		input_active = false
		turn_done.emit(player_id)

func shoot():
	print("shoot",movement_direction)
	for i in range(5):
		var bullet = bullet_scene.instantiate()
		if movement_direction == MovementDirection.LEFT || movement_direction == MovementDirection.INVALID:
			bullet.position = gun_pos_right.global_position
			bullet.rotation = gun_pos_right.global_rotation
		if movement_direction == MovementDirection.RIGHT:
			bullet.position = gun_pos_left.global_position
			bullet.rotation = gun_pos_left.global_rotation
		get_tree().current_scene.add_child(bullet)
		bullet.position += Vector2(randf_range(1, 5), randf_range(1, 5))
	
		
		# Calculate the direction from the gun to the target cursor
		var direction = (target_cursor.global_position - gun_pos_left.global_position).normalized()
		# Define the impulse strength (adjust as necessary)
		var impulse_strength = 1000
		# Apply the impulse to the bullet
		bullet.apply_impulse( direction * impulse_strength)
	
	$AudioStreamPlayerShoot.play(0.05)
	bullet_count -= 1
	total_distance_moved += 150
	print(bullet_count)
	if bullet_count <= 0:
		set_gun_enabled(false)

func set_gun_enabled(enabled: bool):
	has_gun = enabled
	if has_gun:
		if movement_direction == MovementDirection.RIGHT:
			gun_pos_left.visible = true
			gun_pos_right.visible = false

		if movement_direction == MovementDirection.LEFT:
			gun_pos_left.visible = false
			gun_pos_right.visible = true
	else:
		gun_pos_left.visible = false
		gun_pos_right.visible = false
		
func _on_pickup_area_2d_body_entered(body):
	if body.has_method("get_pickup"):
		body.queue_free()
		has_gun = true
		
	

extends Sprite2D

var selected_object = null
var carried_object: RigidBody2D = null
var previous_collision_layer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if carried_object != null:
		carried_object.global_position = self.global_position

func _input(event):
	if event.is_action_pressed("shoot_p0"):
		if carried_object == null:
			if self.selected_object != null:
				self.carried_object = self.selected_object
				self.carried_object.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
				self.carried_object.freeze = true
				self.carried_object.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
				self.previous_collision_layer = self.carried_object.collision_layer
				self.carried_object.collision_layer = 0
		else:
			self.carried_object.collision_layer = self.previous_collision_layer
			self.carried_object.freeze = false
			self.carried_object = null
			


func _on_area_2d_body_entered(body):
		if body is RigidBody2D:
			self.selected_object = body

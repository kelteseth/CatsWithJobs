extends RigidBody2D

var current_gravity_force = Vector2.ZERO

func react_to_gravity(direction: Vector2, strength: float):
	current_gravity_force = direction * strength * mass

func _integrate_forces(state):
	apply_central_force(current_gravity_force)

func _on_body_entered(body):
	$AudioStreamPlayerCollide.play()

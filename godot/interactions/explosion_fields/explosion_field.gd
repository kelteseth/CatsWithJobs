extends Area2D

func _ready():
	$AudioStreamPlayerBoom.play(0.63)


func _on_body_entered(body):
	if body is RigidBody2D:
		var direction = (body.global_position - self.global_position).normalized()
		body.apply_central_impulse(direction * 3000)

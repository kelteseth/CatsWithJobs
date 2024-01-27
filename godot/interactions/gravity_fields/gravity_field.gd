extends Area2D


func _on_body_entered(body):
	if body.has_method("react_to_gravity"):
		body.react_to_gravity(Vector2(0, 1), 980)


func _on_body_exited(body):
	if body.has_method("react_to_gravity"):
		body.react_to_gravity(Vector2(0, 1), 0)

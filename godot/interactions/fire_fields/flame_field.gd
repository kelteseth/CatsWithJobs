extends Area2D


func _on_body_entered(body):
	if body.has_method("react_to_fire"):
		body.react_to_fire(3)


func _on_body_exited(body):
	if body.has_method("react_to_fire"):
		body.react_to_fire(0)

extends Area2D

var contained_flammables: Array[Node]

func _on_body_entered(body):
	if body.has_method("react_to_fire"):
		self.contained_flammables.append(body)


func _on_body_exited(body):
	if body.has_method("react_to_fire"):
		body.react_to_fire(0, self)


func _process(delta):
	for f in contained_flammables:
		if not f == null:
			f.react_to_fire(3, self)

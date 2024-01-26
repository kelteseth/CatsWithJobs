extends CharacterBody2D

	
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		position.x += 100 * delta
	if Input.is_action_pressed("ui_left"):
		position.x -= 100 * delta
	if Input.is_action_pressed("ui_up"):
			position.y -= 100 * delta
	if Input.is_action_pressed("ui_down"):
		position.y += 100 * delta

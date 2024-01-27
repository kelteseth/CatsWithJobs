extends RigidBody2D

@onready var life_timer = $LifeTimer  # Ensure you have a Timer node named LifeTimer as a child

func _ready():
	# Start the life timer
	life_timer.start()
	# Connect the timer's timeout signal to a function on this script
	life_timer.timeout.connect(_on_LifeTimer_timeout)

func _on_LifeTimer_timeout():
	# This function is called when the timer reaches zero
	queue_free()

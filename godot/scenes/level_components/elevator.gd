extends StaticBody2D

@onready var elevator: Sprite2D = $Sprite2D

enum Collsition {RIGHT, LEFT}
@export var img_position = Collsition.LEFT

# Called when the node enters the scene tree for the first time.
func _ready():
	if img_position == Collsition.LEFT:
		elevator.flip_h = true
	if img_position == Collsition.RIGHT:
		elevator.flip_h = false

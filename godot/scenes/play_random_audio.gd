extends AudioStreamPlayer2D

@export var sounds: Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.stream = self.sounds.pick_random()
	self.play()

func _on_finished():
	self.stream = self.sounds.pick_random()
	self.play()

extends Control

signal player_clicked(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	player_clicked.emit(0)
	pass # Replace with function body.


func _on_button_2_pressed():
	player_clicked.emit(1)
	pass # Replace with function body.

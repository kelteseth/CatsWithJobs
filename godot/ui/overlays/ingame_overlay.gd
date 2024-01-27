extends Control
@onready var movement_label = $MovementLabel
@onready var movement_progress_bar = $ProgressBar
signal player_clicked(id)


func set_player_active(player_id):
	pass
	
func set_player_percentage_moved(player_id: int, percentage_moved: int):
	movement_label.text = "Player " + str(player_id + 1) + " round"
	movement_progress_bar.value = floor(percentage_moved)

func _on_button_pressed():
	player_clicked.emit(0)
	pass # Replace with function body.


func _on_button_2_pressed():
	player_clicked.emit(1)
	pass # Replace with function body.

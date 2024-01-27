extends Control
@onready var movement_label = $MovementLabel
@onready var movement_progress_bar = $ProgressBar

func set_player_percentage_moved(player_id: int, percentage_moved: int):
	movement_label.text = "Player " + str(player_id + 1) + " round"
	movement_progress_bar.value = floor(percentage_moved)


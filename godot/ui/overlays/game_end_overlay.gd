extends Control

@export var menu_scene:PackedScene

func set_winner(player_id: int):
	$PlayerName.text = "Player " + str(player_id + 1) + " won!"

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu_scene.tscn")

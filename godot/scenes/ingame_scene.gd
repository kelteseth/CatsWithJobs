extends Node2D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay
@export var ingame_overlay: Control
@export var player_0 : CharacterBody2D
@export var player_1 : CharacterBody2D

func _ready() -> void:
	fade_overlay.visible = true
	return
	ingame_overlay.player_clicked.connect(on_player_clicked)
	
	if SaveGame.has_save():
		SaveGame.load_game(get_tree())
	
	pause_overlay.game_exited.connect(_save_game)
	
func on_player_clicked(player_id):
	player_0.set_player_active(player_id == 0)
	player_1.set_player_active(player_id == 1)
	
func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
		
func _save_game() -> void:
	SaveGame.save_game(get_tree())

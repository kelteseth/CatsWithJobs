extends Node2D

@onready var fade_overlay = %FadeOverlay
@onready var pause_overlay = %PauseOverlay
@export var ingame_overlay: Control
@export var player_0 : CharacterBody2D
@export var player_1 : CharacterBody2D
@export var end_credits : Control

var active_player = 0

func _ready() -> void:
	fade_overlay.visible = true
	player_0.turn_done.connect(on_player_turn_done)
	player_1.turn_done.connect(on_player_turn_done)
	player_0.player_moved.connect(set_ui_player_percentage_moved)
	player_1.player_moved.connect(set_ui_player_percentage_moved)
	player_0.game_end.connect(load_end_credits)
	player_1.game_end.connect(load_end_credits)
	player_0.set_player_active(true)
	player_1.set_player_active(false)

func load_end_credits(player_id):
	$UI/GameEndOverlay.set_winner(player_id)
	$UI/GameEndOverlay.visible = true
	$UI/IngameOverlay.visible = false
	player_0.set_player_active(false)
	player_1.set_player_active(false)
	
func on_player_turn_done(player_id):
	print("Player turn done of player: ", player_id)
	set_ui_player_percentage_moved(player_id,0)
	if player_id == 0:
		set_player_active(1)
	else:
		set_player_active(0)

func set_ui_player_percentage_moved(player_id, percentage):
	# Both player trigger this all the time...
	if player_id == active_player:
		ingame_overlay.set_player_percentage_moved(player_id, percentage)

# Sets player with player_id active and resets all states
func set_player_active(player_id):
	active_player = player_id
	player_0.set_player_active(player_id == 0)
	player_1.set_player_active(player_id == 1)
	
func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		pause_overlay.grab_button_focus()
		pause_overlay.visible = true
		$AudioStreamPlayerBackgroundnMusic.pitch_scale = 0.75

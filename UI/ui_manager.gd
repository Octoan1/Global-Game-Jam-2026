extends Control

#Ready AudioStreams
@onready var ui_accept: AudioStreamPlayer2D = $UIAccept
@onready var ui_click: AudioStreamPlayer2D = $UIClick
@onready var game_start: AudioStreamPlayer2D = $GameStart

#Ready Main Menu
@onready var main_center: CenterContainer = $MainCenter

#Ready Pause
@onready var pause_center: CenterContainer = $PauseCenter
@onready var pause_resume: TextureButton = $PauseCenter/PauseMenu/CenterResume/PauseResume
@onready var pause_music_volume: Slider = $PauseCenter/PauseMenu/CenterSound/Sound/VBoxContainer/PauseMusicVolume
@onready var pause_sfx_volume: Slider = $PauseCenter/PauseMenu/CenterSound/Sound/VBoxContainer/PauseSFXVolume
@onready var pause_quit: TextureButton = $PauseCenter/PauseMenu/CenterQuit/PauseQuit


@onready var menu: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_center.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#Pausing Input
	if Input.is_action_just_pressed("pause") and not (get_tree().paused):
		get_tree().paused = true
		pause_center.visible = true
		pause_resume.focus_mode = 2
		await get_tree().create_timer(1).timeout
	if Input.is_action_just_pressed("pause") and (get_tree().paused):
		get_tree().paused = false
		pause_center.visible = false
		await get_tree().create_timer(1).timeout
#PLAY THE GAME
func _on_main_play_pressed() -> void:
	var start_game = load("res://Scenes/game_world.tscn")
	var game_instantiate = start_game.instantiate()
	call_deferred("add_child", game_instantiate)
	main_center.visible = false
	main_center.PROCESS_MODE_DISABLED
#Resume
func _on_pause_resume_pressed() -> void:
	get_tree().paused = false
	pause_center.visible = false
	await get_tree().create_timer(1).timeout
#Volume Control
	#Pause
func _on_pause_music_volume_value_changed(value: float) -> void:
	pass # Replace with function body.
func _on_pause_sfx_volume_value_changed(value: float) -> void:
	pass # Replace with function body.
	#Main
func _on_main_sfx_volume_value_changed(value: float) -> void:
	pass # Replace with function body.
func _on_main_music_volume_value_changed(value: float) -> void:
	pass # Replace with function body.
#Quit
func _on_pause_quit_pressed() -> void:
	get_tree().quit()
func _on_main_quit_pressed() -> void:
	get_tree().quit()

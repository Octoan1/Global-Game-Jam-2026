extends Control

#Ready AudioStreams
@onready var ui_accept: AudioStreamPlayer2D = $UIAccept
@onready var ui_click: AudioStreamPlayer2D = $UIClick
@onready var game_start: AudioStreamPlayer2D = $GameStart

#Ready Main Menu
@onready var main_center: CenterContainer = $MainCenter
@onready var main_play: TextureButton = $MainCenter/MainMenu/CenterPlay/MainPlay
@onready var main_quit: TextureButton = $MainCenter/MainMenu/CenterQuit/MainQuit
@onready var main_music: Slider = $MainCenter/MainMenu/CenterSound/Sound/CenterSliders/VBoxContainer/MainMusicVolume
@onready var main_sfx: Slider = $MainCenter/MainMenu/CenterSound/Sound/CenterSliders/VBoxContainer/MainSFXVolume

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
	get_tree().paused = true
	main_play.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#Pausing Input
	if Input.is_action_just_pressed("pause") and not (get_tree().paused):
		get_tree().paused = true
		pause_center.visible = true
		pause_resume.grab_focus()
		await get_tree().create_timer(1).timeout
	if Input.is_action_just_pressed("pause") and (get_tree().paused):
		get_tree().paused = false
		pause_center.visible = false
		await get_tree().create_timer(1).timeout
#Play
func _on_main_play_pressed() -> void:
	get_tree().paused = false
	main_center.visible = false
	game_start.play()
	main_center.PROCESS_MODE_DISABLED
func _on_main_play_focus_entered() -> void:
	ui_click.play()
func _on_main_play_mouse_entered() -> void:
	ui_click.play()
#Resume
func _on_pause_resume_pressed() -> void:
	get_tree().paused = false
	pause_center.visible = false
	await get_tree().create_timer(1).timeout
#Volume Control
	#Pause
func _on_pause_music_volume_value_changed(value: float) -> void:
	pass # Replace with function body.
func _on_main_music_volume_focus_entered() -> void:
	ui_click.play()
func _on_main_music_volume_mouse_entered() -> void:
	ui_click.play()
func _on_pause_sfx_volume_value_changed(value: float) -> void:
	pass # Replace with function body.
func _on_main_sfx_volume_focus_entered() -> void:
	ui_click.play()
func _on_main_sfx_volume_mouse_entered() -> void:
	ui_click.play()
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
func _on_main_quit_focus_entered() -> void:
	ui_click.play()
func _on_main_quit_mouse_entered() -> void:
	ui_click.play()

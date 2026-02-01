extends Control

@onready var ui_accept: AudioStreamPlayer2D = $UIAccept
@onready var ui_click: AudioStreamPlayer2D = $UIClick
@onready var game_start: AudioStreamPlayer2D = $GameStart
@onready var main_center: CenterContainer = $MainCenter
@onready var pause_center: CenterContainer = $PauseCenter

@onready var paused: bool = false
@onready var menu: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_center.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("pause") and not (get_tree().paused):
			get_tree().paused = true
			pause_center.visible = true
			await get_tree().create_timer(1).timeout

		if Input.is_action_just_pressed("pause") and (get_tree().paused):
			get_tree().paused = false
			pause_center.visible = false
			await get_tree().create_timer(1).timeout

			
			

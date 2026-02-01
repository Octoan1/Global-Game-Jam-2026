extends Area2D

var player1_detected = false
var player2_detected = false

var activate_exit = false

signal exit_level(next: int, current: int)
signal fade_to_black
signal stop_players

@export var next_level_id: int
#@export var current_level_id: int
var player1_pos: Vector2
var player2_pos: Vector2

@onready var doo_complete = $DooComplete
@onready var dingle_complete = $DingleComplete

var await_dingle_sound = false
var await_doo_sound = false

func _ready():
	var head_node = get_parent()
	print(head_node.name)
	player1_pos = get_parent().get_player_1_spawn()
	player2_pos = get_parent().get_player_2_spawn()
	
	await get_tree().create_timer(0.5).timeout
	activate_exit = true

func _on_body_entered(body):
	if activate_exit == true:
		if body.name == "Player1":
			dingle_complete.play()
			player1_detected = true
	
	
		if body.name == "Player2":
			doo_complete.play()
			player2_detected = true
		
	
	if(player1_detected and player2_detected):
		stop_players.emit()
		fade_to_black.emit()
		await get_tree().create_timer(1).timeout
		exit_level.emit(next_level_id, player1_pos, player2_pos)
		print("Going to level: ", next_level_id)
		#queue_free()


func _on_body_exited(body):
	if body.name == "Player1":
		player1_detected = false
	
	if body.name == "Player2":
		player2_detected = false
		

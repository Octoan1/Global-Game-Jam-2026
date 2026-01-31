extends Area2D

var player1_detected = false
var player2_detected = false

signal exit_level(next: int, current: int)

@export var next_level_id: int
#@export var current_level_id: int
var player1_pos: Vector2
var player2_pos: Vector2

func _ready():
	var head_node = get_parent()
	print(head_node.name)
	player1_pos = get_parent().get_player_1_spawn()
	player2_pos = get_parent().get_player_2_spawn()

func _on_body_entered(body):
	print(body.name)
	if body.name == "Player1":
		print("waiting for player 2")
		player1_detected = true
	
	if body.name == "Player2":
		print("waiting for player 1")
		player2_detected = true
		
	
	if(player1_detected and player2_detected):
		print("Exiting level.")
		print(player1_pos)
		print(player2_pos)
		exit_level.emit(next_level_id, player1_pos, player2_pos)
		#queue_free()


func _on_body_exited(body):
	if body.name == "Player1":
		print("Player 1 left the area.")
		player1_detected = false
	
	if body.name == "Player2":
		print("Player 2 left the area.")
		player2_detected = false
		

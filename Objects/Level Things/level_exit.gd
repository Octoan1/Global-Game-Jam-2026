extends Area2D

var player1_detected = false
var player2_detected = false

signal exit_level

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
		emit_signal("exit_level")


func _on_body_exited(body):
	if body.name == "Player1":
		print("Player 1 left the area.")
		player1_detected = false
	
	if body.name == "Player2":
		print("Player 2 left the area.")
		player2_detected = false
		

extends Area2D

signal player_reset

func _on_body_entered(body):
	print(body.name)
	if body.name == "Player1" or body.name == "Player2":
		player_reset.emit()
		

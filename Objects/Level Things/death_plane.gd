extends Area2D

signal player1_reset
signal player2_reset
signal player_reset

@onready var dingle_dies = $DingleDies
@onready var doo_dies = $DooDies

var sound_ready = true

func _on_body_entered(body):
	
		if body.name == "Player1":
			#await get_tree().create_timer(0.5).timeout
			#player_reset.emit()
			if sound_ready == true:
				dingle_dies.play()
				sound_ready = false
				await get_tree().create_timer(1).timeout
				sound_ready = true
			#player1_reset.emit()
			player_reset.emit()
		
		
		if body.name == "Player2":
			#await get_tree().create_timer(0.5).timeout
			#player_reset.emit()
			if sound_ready == true:
				doo_dies.play()
				sound_ready = false
				await get_tree().create_timer(1).timeout
				sound_ready = true
			#player2_reset.emit()
			player_reset.emit()

extends Camera2D

@onready var player1: CharacterBody2D = $"../Player1"
@onready var player2: CharacterBody2D = $"../Player2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player1.camera_on:
		self.enabled = true
		global_position = (player1.global_position + player2.global_position) * 0.5
	else:
		self.enabled = false

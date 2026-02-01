extends Node2D

@export var thickness := 3.0
@export var color := Color(1, 1, 1, 0.8)
@onready var player1: CharacterBody2D = $"../Player1"
@onready var player2: CharacterBody2D = $"../Player2"
@onready var camera: Camera2D = $"../Camera2D"
@onready var cam_size = camera.get_viewport_rect().size * camera.zoom

func _ready() -> void:
	print(player1)
	print(player2)
	print(camera)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()
	
func _draw():
	if player1 == null or player2 == null:
		return

	var dist = player1.global_position.distance_to(player2.global_position)
	if dist < min(cam_size.x, cam_size.y) - 30:
		return

	draw_line(
		to_local(player1.global_position),
		to_local(player2.global_position),
		color,
		thickness
	)

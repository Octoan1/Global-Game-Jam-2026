extends RigidBody2D

@export var fly_speed = 125.0
var player: CharacterBody2D
var flying = false
var connected = false
var red: bool
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
		
func _process(delta):
	if not connected:
		player.gather_leaves.connect(_on_player_gather_leaves)
		connected = true
		if red:
			sprite.play("Red")
		else:
			sprite.play("Blue")
	if not flying or not player:
		return

	var dir = player.global_position - global_position
	var distance = dir.length()

	if distance < 10:
		queue_free()
		player.unpoof_from_leaves()
		return

	global_position += dir.normalized() * fly_speed * delta
	rotation = dir.angle()

func _on_player_gather_leaves():
	flying = true
	player.respawning = true

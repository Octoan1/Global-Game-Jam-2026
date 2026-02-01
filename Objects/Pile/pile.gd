extends RigidBody2D

@export var fly_speed = 200.0
var player: CharacterBody2D
var flying = false
var connected = false
var red: bool
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
		
func _physics_process(delta: float):
	if not connected:
		player.gather_leaves.connect(_on_player_gather_leaves)
		connected = true
		if red:
			sprite.play("Red")
		else:
			sprite.play("Blue")
		set_collision_mask_value(1, true)
	if not flying or not player:
		return

	var dir = player.global_position - global_position
	var distance = dir.length()

	if distance < 10:
		queue_free()
		player.unpoof_from_leaves()
		return

	linear_velocity = dir / distance * fly_speed
	rotation = dir.angle()

func _on_player_gather_leaves():
	flying = true
	sprite.play("Flying_Blue")
	set_collision_mask_value(1, false)
	player.respawning = true

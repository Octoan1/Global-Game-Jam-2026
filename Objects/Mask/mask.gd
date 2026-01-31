extends RigidBody2D

signal hit_player

var thrower: Node = null
var returning = false

func throw(direction: Vector2, speed: float, player: Node):
	thrower = player
	linear_velocity = direction.normalized() * speed

func _return_to_thrower():
	if thrower == null:
		return
	self.set_collision_mask_value(1, false)
	var direction = (thrower.global_position - global_position).normalized()
	linear_velocity = direction * 200

func _physics_process(_delta: float) -> void:
	if returning and thrower != null:
		if global_position.distance_to(thrower.global_position) < 10:
			thrower.ammo = 1
			queue_free()
			returning = false
			self.set_collision_mask_value(1, true)
		else:
			_return_to_thrower()
	

func _on_body_entered(body):
	if body.name == "Player2" or body.name == "Player1":
		print("hit")
		emit_signal("hit_player", body)
		queue_free()
		returning = false
	if body.name == "Floor" and thrower != null:
		returning = true
		_return_to_thrower()
		

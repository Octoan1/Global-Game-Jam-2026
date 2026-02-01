extends RigidBody2D

signal hit_player

var thrower: Node = null
var returning = false

#Sound
@onready var throw_sound = $ThrowSound
@onready var return_sound = $ReturnSound

func throw(direction: Vector2, speed: float, player: Node):
	thrower = player
	linear_velocity = direction.normalized() * speed
	
	#throw sound
	throw_sound.play()

func _return_to_thrower():
	if thrower == null:
		return
	self.set_collision_mask_value(1, false)
	var direction = (thrower.global_position - global_position).normalized()
	linear_velocity = direction * 200
	
	#return sound
	if returning == true:
		if return_sound.has_stream_playback() == false:
			#return_sound.play()
			pass

func _physics_process(_delta: float) -> void:
	if returning and thrower != null:
		if global_position.distance_to(thrower.global_position) < 10:
			thrower.ammo = 1
			#thrower.animated.play("Unpoof")
			thrower.unpoof_from_leaves()
			thrower.waiting = false
			queue_free()
			returning = false
			self.set_collision_mask_value(1, true)
		else:
			_return_to_thrower()
	

func _on_body_entered(body):
	if body.name == "Player2" or body.name == "Player1":
		thrower.waiting = false
		emit_signal("hit_player", body)
		queue_free()
		returning = false
	if body.name == "Walls" and thrower != null:
		returning = true
		_return_to_thrower()
		

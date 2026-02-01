extends CharacterBody2D

#Player
const SPEED = 100.0
const GSPEED = 150.0
const JUMP_VELOCITY = -200.0
@export var mask = true
@onready var throwing = false
@onready var waiting = false
@onready var ammo = 1
var controller = true

#Arrow
@export var thickness := 2.0
@export var max_length := 50.0
@export var joystick_id := 0
@export var deadzone := 0.2
@export var arrow_color := Color.BLUE
var arrow_dir = Vector2.ZERO
var arrow_length = 0.0
@onready var pointer: Node2D = $Pointer

#Texture
@export var real_tex: Texture2D
@export var ghost_tex: Texture2D
@onready var sprite: Sprite2D = $Sprite
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
var prev_dir = 1

#Throwing
@export var mask_scene: PackedScene

#Camera
@export var camera_on = false
@onready var camera: Camera2D = $"../Camera2D"
@onready var cam_size = camera.get_viewport_rect().size * camera.zoom

func _physics_process(delta: float) -> void:
	_update_inputs()
	if mask:
		self.set_collision_layer_value(2, true)
		self.set_collision_layer_value(3, false)
		self.set_collision_mask_value(1, true)
		self.set_collision_mask_value(5, false)
	else:
		self.set_collision_layer_value(3, true)
		self.set_collision_layer_value(2, false)
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(5, true)
	
	# Add the gravity.
	if not is_on_floor() and mask:
		velocity += get_gravity() * delta / 2
		
	# Handle jump.
	if controller:
		if Input.is_action_pressed("p1_jump_c" if joystick_id == 0 else "p2_jump_c") and is_on_floor() and not throwing and not waiting and mask:
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_pressed("p1_jump_k" if joystick_id == 0 else "p2_jump_k") and is_on_floor() and not throwing and not waiting and mask:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var other = _get_other_player()
	var players_dist = global_position.distance_to(other.global_position)
	var to_other = (_get_other_player().global_position - global_position).normalized()
	var direction
	if controller:
		direction = Input.get_axis("p1_move_left_c" if joystick_id == 0 else "p2_move_left_c", "p1_move_right_c" if joystick_id == 0 else "p2_move_right_c")
	else:
		direction = Input.get_axis("p1_move_left_k" if joystick_id == 0 else "p2_move_left_k", "p1_move_right_k" if joystick_id == 0 else "p2_move_right_k")
	var moving_away = direction != 0 and sign(direction) == -sign(to_other.x)
	if direction and not throwing and not waiting and mask and ((players_dist < _get_max_distance() or not moving_away) or not camera_on):
		animated.play("Walk")
		velocity.x = direction * SPEED
		animated.flip_h = prev_dir < 0
		sprite.flip_h = prev_dir < 0
		prev_dir = direction
	else:
		animated.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#ghost movement
	if not mask:
		if controller:
			var stick = Vector2(
			Input.get_joy_axis(joystick_id, JOY_AXIS_LEFT_X),
			Input.get_joy_axis(joystick_id, JOY_AXIS_LEFT_Y)
			)
			if stick.length() < deadzone:
				stick = Vector2.ZERO
			if camera_on:
				var desired_velocity = stick * GSPEED

				if desired_velocity != Vector2.ZERO:
					var move_dir = desired_velocity.normalized()
					moving_away = move_dir.dot(to_other) < 0

					if players_dist < _get_max_distance() or not moving_away:
						velocity = desired_velocity
					else:
						velocity = Vector2.ZERO
				else:
					velocity.x = 0
					velocity.y = 0
			else:
				velocity.x = stick.x * GSPEED
				velocity.y = stick.y * GSPEED
			if stick.x != 0:
				sprite.flip_h = prev_dir < 0
			prev_dir = stick.x
		else:
			var h_dir := Input.get_axis("p1_move_left_k" if joystick_id == 0 else "p2_move_left_k", "p1_move_right_k" if joystick_id == 0 else "p2_move_right_k")
			var v_dir := Input.get_axis("p1_move_up" if joystick_id == 0 else "p2_move_up", "p1_move_down" if joystick_id == 0 else "p2_move_down")
			var desired_velocity = Vector2(h_dir, v_dir) * GSPEED

			if camera_on:
				if desired_velocity != Vector2.ZERO:
					var move_dir = desired_velocity.normalized()
					moving_away = move_dir.dot(to_other) < 0

					if players_dist < _get_max_distance() or not moving_away:
						velocity = desired_velocity
					else:
						velocity = Vector2.ZERO
				else:
					velocity.x = 0
					velocity.y = 0
			else:
				velocity.x = h_dir * GSPEED
				velocity.y = v_dir * GSPEED
			if h_dir != 0:
				sprite.flip_h = prev_dir < 0
			prev_dir = h_dir
		
	var arrow = _update_arrow()
	if controller:
		if Input.is_action_just_pressed("p1_throw_c" if joystick_id == 0 else "p2_throw_c") and throwing:
			_throw_mask(arrow[0], arrow[1])
		elif Input.is_action_just_pressed("p1_throw_c" if joystick_id == 0 else "p2_throw_c") and mask and not waiting:
			throwing = true
			_update_arrow()
		if Input.is_action_just_pressed("p1_back_c" if joystick_id == 0 else "p2_back_c") and throwing:
			throwing = false
	else:
		if Input.is_action_just_pressed("p1_throw_k" if joystick_id == 0 else "p2_throw_k") and throwing:
			_throw_mask(arrow[0], arrow[1])
		elif Input.is_action_just_pressed("p1_throw_k" if joystick_id == 0 else "p2_throw_k") and mask and not waiting:
			throwing = true
			_update_arrow()
		if Input.is_action_just_pressed("p1_back_k" if joystick_id == 0 else "p2_back_k") and throwing:
			throwing = false
	
	if Input.is_action_just_pressed("ui_accept"):
		mask = !mask
	_update_sprite()
		
	move_and_slide()
	
	if throwing:
		queue_redraw()
	
func _update_arrow():
	if not throwing:
		pointer.global_position.x = 30
		pointer.global_position.y = 0
		queue_redraw()
	# Get joystick input
	if controller:
		var stick = Vector2(
		Input.get_joy_axis(joystick_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(joystick_id, JOY_AXIS_LEFT_Y)
		)

		if stick.length() < deadzone:
			stick = Vector2.ZERO
			
		pointer.global_position.x += stick.x * 2
		pointer.global_position.y += stick.y * 2
	#Get keyboard input
	else:
		var h_dir := Input.get_axis("p1_move_left_k" if joystick_id == 0 else "p2_move_left_k", "p1_move_right_k" if joystick_id == 0 else "p2_move_right_k")
		var v_dir := Input.get_axis("p1_move_up" if joystick_id == 0 else "p2_move_up", "p1_move_down" if joystick_id == 0 else "p2_move_down")
		
		pointer.global_position.x += h_dir
		pointer.global_position.y += v_dir
	
	var pointer_pos = Vector2(pointer.global_position.x, pointer.global_position.y)
	var length = pointer_pos.length()
	if length > max_length:
		var unit_vector = pointer_pos / length
		pointer.global_position.x = unit_vector.x * max_length
		pointer.global_position.y = unit_vector.y * max_length
		
	arrow_dir = Vector2(pointer.global_position.x, pointer.global_position.y).normalized()
	arrow_length = Vector2(pointer.global_position.x, pointer.global_position.y).length()
	return [Vector2(pointer.global_position.x, pointer.global_position.y) / arrow_length, arrow_length * 10]
	
func _draw():
	if arrow_length == 0 or not throwing:
		return

	var start_pos = Vector2(0,0)
	var end_pos = arrow_dir * arrow_length

	# Draw shaft
	draw_line(start_pos, end_pos, arrow_color, thickness)

	# Draw arrowhead
	var head_size = thickness * 2
	var perp = Vector2(-arrow_dir.y, arrow_dir.x) * head_size  # perpendicular
	draw_line(end_pos, end_pos - arrow_dir * head_size + perp, arrow_color, thickness)
	draw_line(end_pos, end_pos - arrow_dir * head_size - perp, arrow_color, thickness)

func _update_sprite():
	if mask:
		sprite.texture = real_tex
	else:
		sprite.texture = ghost_tex

func _throw_mask(direction: Vector2, speed: float):
	if not throwing or ammo == 0:
		return
	ammo = 0
	throwing = false
	waiting = true
	queue_redraw()
	var projectile = mask_scene.instantiate()
	self.add_child(projectile)
	projectile.global_position = global_position
	projectile.throw(direction, speed, self)
	
	projectile.connect("hit_player", Callable(self, "_on_mask_hit"))

func _on_mask_hit(body):
	if body == self:
		return
	mask = false
	throwing = false
	queue_redraw()
	body.mask = true
	body.ammo = 1

func _update_inputs():
	if Input.is_action_just_pressed("p1_connect_controller" if joystick_id == 0 else "p2_connect_controller"):
		controller = true
	if Input.is_action_just_pressed("p1_connect_keyboard" if joystick_id == 0 else "p2_connect_keyboard"):
		controller = false

func _get_max_distance():
	return min(cam_size.x, cam_size.y) - 30

func _get_other_player():
	return $"../Player2" if joystick_id == 0 else $"../Player1"

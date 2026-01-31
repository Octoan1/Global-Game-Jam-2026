extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var mask = true
@onready var throwing = false
@export var pointer_scene: PackedScene
@export var arrow_scene: PackedScene

@export var thickness := 8.0
@export var max_length := 500.0
@export var joystick_id := 0
@export var deadzone := 0.2
@export var arrow_color := Color.RED

var arrow_dir = Vector2.ZERO
var arrow_length = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_pressed("p1_jump") and is_on_floor() and not throwing:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("p1_move_left", "p1_move_right")
	if direction and not throwing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("p1_throw") and mask:
		throwing = true
	if Input.is_action_just_pressed("p1_back") and throwing:
		throwing = false
		
	_update_arrow()
		
	move_and_slide()
	
	if throwing:
		queue_redraw()
	
func _update_arrow():
	# Get joystick input
	var stick = Vector2(
		Input.get_joy_axis(joystick_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(joystick_id, JOY_AXIS_LEFT_Y)
	)

	if stick.length() < deadzone or not throwing:
		arrow_dir = Vector2.ZERO
		arrow_length = 0.0
		return
		
	arrow_dir = stick.normalized()
	arrow_length = stick.length() * max_length
	
	
func _draw():
	if arrow_length == 0:
		return

	var start_pos = Vector2(20,0)
	var end_pos = arrow_dir * arrow_length

	# Draw shaft
	draw_line(start_pos, end_pos, arrow_color, thickness)

	# Draw arrowhead
	var head_size = thickness * 2
	var perp = Vector2(-arrow_dir.y, arrow_dir.x) * head_size  # perpendicular
	draw_line(end_pos, end_pos - arrow_dir * head_size + perp, arrow_color, thickness)
	draw_line(end_pos, end_pos - arrow_dir * head_size - perp, arrow_color, thickness)
		

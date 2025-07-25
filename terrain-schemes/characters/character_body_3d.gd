extends CharacterBody3D

# Movement & physics
var speed := 75.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_visible := false
var mouse_sensitivity := 0.1
var yaw := 0.0

# Tilt styling
var tilt_strength := 4.0  # degrees of pitch/roll
var tilt_smoothing := 5.0  # interpolation speed

func _ready():
	print("this bad boy needs some work")
	print("my homework will be to make the changes")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event.is_action_pressed("toggle_mouse") or event.is_action_pressed("escape"):
		mouse_visible = !mouse_visible
	if mouse_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Directional input (WASD)
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Rotate input vector by -90 degrees around Z to cancel out player's rotation
	var input_vec = Vector3(input_dir.x, 0, input_dir.y)
	input_vec = input_vec.rotated(Vector3.UP, deg_to_rad(-90))
	var direction = transform.basis * input_vec.normalized()
	
	direction = direction.normalized()

	# Apply directional movement
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	# Tilt and roll effect
	var target_roll = -input_dir.x * tilt_strength
	var target_pitch = input_dir.y * tilt_strength

	rotation_degrees.x = lerp(rotation_degrees.x, target_pitch, delta * tilt_smoothing)
	rotation_degrees.z = lerp(rotation_degrees.z, target_roll, delta * tilt_smoothing)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = yaw

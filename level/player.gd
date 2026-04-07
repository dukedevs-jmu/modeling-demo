extends CharacterBody3D


const SPEED = 5.0
const ACCEL = 0.5
const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.002

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = ($Neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCEL)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCEL)
		
	else:
		velocity.x = move_toward(velocity.x, 0.0, ACCEL)
		velocity.z = move_toward(velocity.z, 0.0, ACCEL)
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			$Neck.rotate_y(-event.relative.x * LOOK_SENSITIVITY)
			$Neck/Camera3D.rotate_x(-event.relative.y * LOOK_SENSITIVITY)
			$Neck/Camera3D.rotation.x = clamp($Neck/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))

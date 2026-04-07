extends Node3D

var rotation_speed = 0.0
const MAX_ROTATION_SPEED = 0.05
const ROTATION_ACCEL = 10

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		rotation_speed = lerp(rotation_speed, -MAX_ROTATION_SPEED,  ROTATION_ACCEL * delta)
		rotate(Vector3.UP, rotation_speed)
	elif Input.is_action_pressed("right"):
		rotation_speed = lerp(rotation_speed, MAX_ROTATION_SPEED,  ROTATION_ACCEL * delta)
		rotate(Vector3.UP, rotation_speed)
	else:
		rotation_speed = lerp(rotation_speed, 0.0,  ROTATION_ACCEL * delta * 0.5)
		rotate(Vector3.UP, rotation_speed)

extends CharacterBody3D

class_name Animal

enum {IDLE, WANDER}

# := restricts a type of a variable
# Exported variables do this automatically
var state := WANDER

@onready var nav_agent = $NavigationAgent3D

@export var speed = 2.0
@export var wander_cooldown = 3.0
@export var squash_anim = true
@export var random_size = true
@export var target : CharacterBody3D = null
@export var model : Node3D

var nav_region : RID

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	speed += randf_range(-0.5, 0.5)
	$WanderCooldown.wait_time = max(1, randf_range(-2, 2) + wander_cooldown)
	$WanderCooldown.start()
	
	if squash_anim:
		$SquashAnimation.play("idle")
		$SquashAnimation.seek(randf_range(0, 2))
	rotate_y(randi_range(0, 2 * PI))
	
func _physics_process(delta) -> void:
	if $WanderCooldown.is_stopped():
		move()
	else:
		velocity = lerp(velocity, Vector3.ZERO, 0.1)
	move_and_slide()
	
	
func move():
	var next_position = nav_agent.get_next_path_position()
	velocity = lerp(velocity, (next_position - global_transform.origin).normalized() * speed, 0.2)
	velocity.y = 0
	if global_position != next_position:
		look_at(next_position)
	rotation.x = 0
	rotation.z = 0


func update_target(target_position) -> void:
	nav_agent.set_target_position(target_position)

func pick_random_move_target():
	update_target(NavigationServer3D.region_get_random_point(nav_region, 0, true))

func _on_navigation_agent_3d_target_reached() -> void:
	$WanderCooldown.wait_time = randf_range(wander_cooldown - 1, wander_cooldown + 1)
	$WanderCooldown.start()


func _on_wander_cooldown_timeout() -> void:
	pick_random_move_target()

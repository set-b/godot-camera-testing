extends CharacterBody3D

@export_category("Player Movement")
@export var speed := 5.0
@export var jump_velocity := 4.5
@export var jump_cut_factor := 0.6
@export var fall_gravity_multiplier := 2.0
const ROTATION_SPEED := 6.0

# TODO: add coyote time and jump buffer soon

#slowly rotate the charcter to point in the direction of the camera_pivot
#@onready var camera_pivot : Node3D = $camera_pivot
@onready var playermodel : Node3D = $playermodel
@onready var room_camera : Camera3D = get_viewport().get_camera_3d()
@onready var camera_pivot: Node3D = $"../camera_pivot"

enum animation_state {IDLE,RUNNING,JUMPING}
var player_animation_state : animation_state = animation_state.IDLE
@onready var animation_player : AnimationPlayer = $"playermodel/character-male-e2/AnimationPlayer"

func _physics_process(delta: float) -> void:
	# Asymmetric gravity.
	# gravity is heavier when the velocity.y is decreasing. slower rise, faster descent
	if not is_on_floor():
		if velocity.y < 0.0:
			velocity += get_gravity() * fall_gravity_multiplier * delta
		else:
			velocity += get_gravity() * delta

	# Handle jump. We used is_action_just_pressed because is_action_pressed would create continuous jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# when player releases the jump button, the velocity.y is multiplied by a decimal to shorten the jump arc
	# this creates variable jumping
	# we use velocity.y > 0.0 because we want to cut the jump. if the velocity is negative (falling)
	# then this would actually make the player linger in the air, cutting the fall instead of the jump
	if Input.is_action_just_released("ui_accept") and velocity.y > 0.0:
		velocity.y *= jump_cut_factor

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var input_strength : float = minf(input_dir.length(), 1.0)

	var direction = (camera_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		# makes speed of movement sensitive to how far down the stick is being tilted
		var target_speed := speed * input_strength
		
		velocity.x = direction.x * target_speed
		velocity.z = direction.z * target_speed
		
		#now rotate the model
		rotate_model(direction, delta)
		player_animation_state = animation_state.RUNNING
	else:
		# this is to make it slow down by the speed
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		player_animation_state = animation_state.IDLE
	
	if not is_on_floor():
		player_animation_state = animation_state.JUMPING
	
	move_and_slide()
	#tell the playeranimationcontroller about the animation state
	match player_animation_state:
		animation_state.IDLE:
			animation_player.play("idle")
		animation_state.RUNNING:
			animation_player.play("sprint")
		animation_state.JUMPING:
			animation_player.play("jump")

	
func rotate_model(direction: Vector3, delta : float) -> void:
	#rotate the model to match the springarm
	playermodel.basis = lerp(playermodel.basis, Basis.looking_at(direction), 10.0 * delta)

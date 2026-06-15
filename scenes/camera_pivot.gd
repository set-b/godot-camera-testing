extends Node3D

const ROTATION_SPEED = 1.8
#const FOLLOW_SPEED = 4.0
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D
@onready var camera_3d: Camera3D = %Camera3D
const MAX_DISTANCE = 2.0
@onready var playermodel: Node3D = $"../Player/playermodel"
var inverted : bool = false
@onready var camera_inversion_text: Label3D = $"../../CameraInversion"

#const HEAD_HEIGHT := 1.0
#const JUMP_LAG_RECOVERY := 5.0
#var jump_lag := 0.0
#var last_player_y := 0.0
var snap_tween : Tween = null
const vertical_offset : Vector3 = Vector3(0,1,0)

var current_distance : float = MAX_DISTANCE

var rotate_input := 0.0
var snap_requested := false

#var target_radius := 0.01
#var default_radius := 0.3

func _process(delta: float) -> void:
	rotate_input = Input.get_axis("camera_left", "camera_right")
	if Input.is_action_just_pressed("snap_behind"):
		snap_requested = true
	
	if Input.is_action_just_pressed("invert"):
		inverted = !inverted
		
func _physics_process(delta: float) -> void:
	# temporarily disabled since not in main scene
	if inverted:
		camera_inversion_text.text = "Camera controls are inverted"
		camera_inversion_text.modulate = Color.GREEN
	else:
		camera_inversion_text.text = "Camera controls are not inverted"
		camera_inversion_text.modulate = Color.RED
	
	var shape := shape_cast_3d.shape
	# interpolation for jumping
	var current_y := playermodel.global_position.y
	
	# if the player is jumping, the y position minus 0 will yield more than 0
	# global coordinates have a standard y axis, where positive is up and negative is down!!
	#var delta_y := current_y - last_player_y
	
	# the difference is added to the jump_lag (0.0)
	#if delta_y > 0.0:
	# trying absolute value to try and make it so there's interpolation when jumping and falling
	#if abs(delta_y) > 0.0:
		#jump_lag += delta_y
	
	# we interpolate the jump lag to 0 by the jump lag recovery times delta
	#jump_lag = lerp(jump_lag, 0.0, JUMP_LAG_RECOVERY * delta)
	# we then set the last_player_y the current_y to prevent unexpectedly increasing the jump_lag
	# and unintentionally creating weird interpolation effects
	#last_player_y = current_y
	# the head height 1.0 has the jump_lag subtracted from it to make the camera pivot
	# temporarily increase in height a little bit until the jump_lag turns to 0.0 again
	#self.position.y = HEAD_HEIGHT - jump_lag
	# end of interpolation for jumping
	
	var forward_vector := playermodel.basis.z
	var target_yaw := atan2(forward_vector.x, forward_vector.z)
	var target_distance := MAX_DISTANCE
	
	# collision behavior
	if shape_cast_3d.is_colliding():
		var fraction := shape_cast_3d.get_closest_collision_unsafe_fraction()
		target_distance = MAX_DISTANCE * fraction
	else:
		target_distance = MAX_DISTANCE
	
	# how to get player direction? NOT USING. JUST KEEPING AS REFERENCE
	# var camera_forward := -self.global_transform.basis.z
	
	#var player_direction = -playermodel.global_transform.basis.z
	#
	#var alignment = player_direction.dot(camera_forward)
	## get rid of magic number
	#if alignment < -0.7:
		#shape.radius = lerp(shape.radius, target_radius, 0.20)
	#else:
		#shape.radius = lerp(shape.radius, default_radius, 0.20)
	
	# perhaps take the direction from the player script? which i think is direction.z
	# then if direction.z > 0.0 (since negative z is facing forward)
	# either shrink sphereshape3d radius, change the shape, disable shapecast3d 
	# collide with bodies property and/or gentle auto focus through tween
	
	self.global_position = lerp(self.global_position, playermodel.global_position + vertical_offset, 0.30)
		
	current_distance = lerp(current_distance, target_distance, 10.0 * delta)
	camera_3d.position = Vector3(0,0,current_distance)
	
	# replace tween with a lerp
	if snap_requested == true:
		# this works
		#self.rotation = Vector3(self.rotation.x, target_yaw, self.rotation.z)
		
		self.rotation.y = lerp(self.rotation.y, target_yaw, 0.10)
		
		if abs(self.rotation.y - target_yaw) < 0.1:
			reset_physics_interpolation()
			snap_requested = false
	
	if inverted:
		rotate_input = rotate_input * -1.0
	
	rotate_y(rotate_input * ROTATION_SPEED * delta)
	

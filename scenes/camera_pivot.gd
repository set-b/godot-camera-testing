extends Node3D

const ROTATION_SPEED = 1.8
@onready var playermodel: Node3D = $"../playermodel"
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D
@onready var camera_3d: Camera3D = %Camera3D
const MAX_DISTANCE = 2.0

const HEAD_HEIGHT := 1.0
const JUMP_LAG_RECOVERY := 5.0
var jump_lag := 0.0
var last_player_y := 0.0

var current_distance : float = MAX_DISTANCE

var rotate_input := 0.0
var snap_requested := false

func _process(delta: float) -> void:
	rotate_input = Input.get_axis("camera_left", "camera_right")
	if Input.is_action_just_pressed("snap_behind"):
		snap_requested = true
		
func _physics_process(delta: float) -> void:
	# interpolation for jumping
	var current_y := playermodel.global_position.y
	# if the player is jumping, the y position minus 0 will yield more than 0
	# global coordinates have a standard y axis, where positive is up and negative is down!!
	var delta_y := current_y - last_player_y
	
	# the difference is added to the jump_lag (0.0)
	if delta_y > 0.0:
		jump_lag += delta_y
	
	# we interpolate the jump lag to 0 by the jump lag recovery times delta
	jump_lag = lerp(jump_lag, 0.0, JUMP_LAG_RECOVERY * delta)
	
	# we then set the last_player_y the current_y to prevent unexpectedly increasing the jump_lag
	# and unintentionally creating weird interpolation effects
	last_player_y = current_y
	# the head height 1.0 has the jump_lag subtracted from it to make the camera pivot
	# temporarily increase in height a little bit until the jump_lag turns to 0.0 again
	self.position.y = HEAD_HEIGHT - jump_lag
	# end of interpolation for jumping
	
	var forward_vector := playermodel.basis.z
	var target_yaw := atan2(forward_vector.x, forward_vector.z)
	var target_distance := MAX_DISTANCE
	
	if shape_cast_3d.is_colliding():
		# the heck is index 0?
		var fraction := shape_cast_3d.get_closest_collision_unsafe_fraction()
		target_distance = MAX_DISTANCE * fraction
	else:
		target_distance = MAX_DISTANCE
		
	current_distance = lerp(current_distance, target_distance, 10.0 * delta)
	camera_3d.position = Vector3(0,0,current_distance)
	
	if snap_requested == true:
		# this works
		self.rotation = Vector3(self.rotation.x, target_yaw, self.rotation.z)
		reset_physics_interpolation()
		snap_requested = false
		
	rotate_y(rotate_input * ROTATION_SPEED * delta)

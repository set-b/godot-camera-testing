class_name Minotaur extends CharacterBody3D
@onready var playermodel : Node3D
@onready var animation_player: AnimationPlayer = $ChargerTaur/AnimationPlayer
var play : bool = true
var turn_speed = 4.0
var finished : bool = false
@onready var charge_timer: Timer = $"ChargerTaur/Timer"
var charging : bool = false
var charging_speed : float = 10.0
var returning : bool = false
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var area_3d: Area3D = $Area3D
@onready var original_position : Vector3 = self.global_position
@export var return_speed : float = 8.0
var dying = false
var damage = 0
var victory_script = preload("res://scenes/victory.gd")
var is_hurt = false
var not_here = true
@onready var detect_player_here: Area3D = $"../Here"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charge_timer.timeout.connect(charge)
	
	area_3d.body_entered.connect(return_to_position)
	animation_player.speed_scale = 0.25
	detect_player_here.body_entered.connect(func(body: Node3D) -> void:
		if body is Player:
			print("here!")
			not_here = false
			playermodel = body
			charge_timer.start()
	)

func _physics_process(delta: float) -> void:
	if playermodel == null or is_hurt == true or not_here:
		return
	if damage >= 3:
		# not playing hurt animation
		velocity = Vector3.ZERO
		if animation_player.current_animation != "Hurt":
			animation_player.play_section("Hurt", 0.0, 1.0)
		var victory_message = Label3D.new()
		victory_message.text = "You Win!"
		victory_message.font_size = 90
		victory_message.global_position = original_position + Vector3(0, 1,0)
		victory_message.set_script(victory_script)
		get_tree().current_scene.add_child(victory_message)
		self.queue_free()
	if returning:
		if animation_player.current_animation != "Charging":
			animation_player.speed_scale = 1.0
			animation_player.play("Charging")
		# move toward original spot; physics owns the body, no external tween
		global_position = global_position.move_toward(original_position, return_speed * delta)
		velocity = Vector3.ZERO
		if global_position.distance_to(original_position) < 0.1:
			returning = false
			charge_timer.start()
	elif charging:
		if animation_player.current_animation != "Charging":
			animation_player.speed_scale = 1.0
			animation_player.play("Charging")
		velocity = -global_basis.z * charging_speed
		move_and_slide()
	else:  # idle / aiming
		if animation_player.current_animation != "Idle":
			animation_player.speed_scale = 0.50
			animation_player.play("Idle")
		var target := playermodel.global_position
		target.y = global_position.y
		look_at(target, Vector3.UP)
		velocity = Vector3.ZERO
	
func charge() -> void:
	charging = true
	# minotaur runs forward direction until it collides with either wall or pot

func return_to_position(body: Node) -> void:
	if returning:
		return
	returning = true
	charging = false
	
func hurt() -> void:
	is_hurt = true
	damage += 1
	if animation_player.current_animation != "Hurt":
		animation_player.play("Hurt")
	await animation_player.animation_finished
	is_hurt = false
	return_to_position(self)

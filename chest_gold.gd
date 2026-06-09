extends Node3D

@onready var area_3d: Area3D = $Area3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var openable : bool = false
var used : bool = false

func _ready() -> void:
	area_3d.body_entered.connect(func(body: Node) -> void:
			if body is Player:
				print("ready to be opened!")
				openable = true
	)
	
func _process(delta: float) -> void:
	if openable and not used:
		if Input.is_action_just_pressed("ui_accept"):
			animation_player.play("open")
			collision_shape_3d.set_deferred_thread_group("disabled", true)
			used = true

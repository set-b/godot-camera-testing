extends Node3D

@onready var area_3d: Area3D = $Area3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var openable : bool = false
var used : bool = false
@onready var win_message: Label3D = $WinMessage

func _ready() -> void:
	area_3d.body_entered.connect(func(body: Node) -> void:
			if body is Player:
				openable = true
	)
	
	area_3d.body_exited.connect(func(body: Node) -> void:
			if body is Player:
				openable = false
	)
	
func _process(delta: float) -> void:
	if openable and not used:
		if Input.is_action_just_pressed("ui_accept"):
			animation_player.play("open")
			collision_shape_3d.set_deferred_thread_group("disabled", true)
			win_message.visible = true
			used = true
			get_tree().create_timer(3.0).timeout.connect(func() -> void:
				get_tree().reload_current_scene()
			)

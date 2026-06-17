extends Node3D
@onready var switch: Node3D = $"."
@onready var area_3d: Area3D = $Area3D
var pot_scene = null
@export var tile : Node3D
@export var pot_camera : Camera3D
@onready var pot = preload("res://pot_asset.tscn")
@onready var pot_broken = preload("res://assets/dungeon-pieces/Pot1_Broken.fbx")

var interactive : bool = false
var player_is_here : bool = false
var rotation_animation_time : float = 0.4
# Called when the node enters the scene tree for the first time.
signal pressed
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
var used : bool = false

func _ready() -> void:
	area_3d.body_entered.connect(func(body: Node) -> void:
		#print("entered: ", body, " | class: ", body.get_class())
		if body is Player:
			interactive = true
			player_is_here = true
	)
	
	area_3d.body_exited.connect(func(body: Node) -> void:
		if body is Player:
			interactive = false
			player_is_here = false
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if interactive and player_is_here:
		if Input.is_action_just_pressed("ui_accept"):
			interactive = false
			var initial_rotation := rotation.z
			# will replace "used" with pot in place
			#used = true
			var rotation_tween = create_tween()
			rotation_tween.set_ease(Tween.EASE_OUT)
			rotation_tween.tween_property(self, "rotation:z", 0.0, rotation_animation_time)
			
			rotation_tween.tween_property(self, "rotation:z", initial_rotation, rotation_animation_time)
			audio_stream_player_3d.play(0.0)
			rotation_tween.finished.connect(func() -> void:
				await pot_check()
				pressed.emit()
				interactive = true
				
				# just needed to add a timer because changing the camera was too fast!
				await get_tree().create_timer(1.0).timeout

				if get_viewport().get_camera_3d() == pot_camera:
					get_viewport().get_camera_3d().clear_current()
				get_tree().paused = false
			)
			

func pot_check() -> void:
	if pot_scene == null:
		get_tree().paused = true
		pot_camera.make_current()
		pot_scene = pot.instantiate()
				
		pot_scene.global_position = tile.global_position
				# need to add pot behavior by adding area3d, collision shape, and script
				
		get_tree().current_scene.add_child(pot_scene)

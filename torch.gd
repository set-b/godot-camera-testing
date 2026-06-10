extends Node3D
@onready var bookcase_camera: Camera3D = $"../BookcaseCamera"
@onready var switch: Node3D = $"."
@onready var area_3d: Area3D = $Area3D
var interactive : bool = false
# Called when the node enters the scene tree for the first time.
signal pressed
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
var used : bool = false

func _ready() -> void:
	area_3d.body_entered.connect(func(body: Node) -> void:
		#print("entered: ", body, " | class: ", body.get_class())
		if body is Player:
			interactive = true
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if interactive:
		if Input.is_action_just_pressed("ui_accept") and not used:
			used = true
			var rotation_tween : Tween = create_tween()
			rotation_tween.set_ease(Tween.EASE_OUT)
			rotation_tween.tween_property(self, "rotation:z", 0.0, 2.0)
			audio_stream_player_3d.play(0.0)
			interactive = false
			rotation_tween.finished.connect(func() -> void:
				get_tree().paused = true
				pressed.emit()
				# disable collision shape
				$Area3D/CollisionShape3D.set_deferred("disabled", true)
				bookcase_camera.make_current()
			)

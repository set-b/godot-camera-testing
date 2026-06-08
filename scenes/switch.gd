extends Node3D
@onready var switch: Node3D = $"."
@onready var area_3d: Area3D = $Area3D
var interactive : bool = false
@onready var csg_cylinder_3d: CSGCylinder3D = $CSGCylinder3D
# Called when the node enters the scene tree for the first time.
signal pressed
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	area_3d.body_entered.connect(func(body: Node) -> void:
		#print("entered: ", body, " | class: ", body.get_class())
		if body is Player:
			interactive = true
			#print("ready for interaction!")
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if interactive:
		if Input.is_action_just_pressed("ui_accept"):
			translate(Vector3(0, -0.2, 0))
			pressed.emit()
			audio_stream_player_3d.play(0.0)
			interactive = false

#func _on_area_entered():
	#pass

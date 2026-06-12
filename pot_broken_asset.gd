class_name BrokenPot extends Node3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_3d.play(0.0)
	get_tree().create_timer(1.3).timeout.connect(
		self.queue_free
	)

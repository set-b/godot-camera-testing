extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(8.0).timeout.connect(func() -> void:
		get_tree().reload_current_scene()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.rotate_y(1.0 * delta)

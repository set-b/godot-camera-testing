extends Node3D
@onready var area_3d: Area3D = $Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.body_entered.connect(func(body: Node) -> void:
		if body is Player:
			var disappearance_tween : Tween = create_tween()
			disappearance_tween.set_trans(Tween.TRANS_ELASTIC)
			disappearance_tween.set_ease(Tween.EASE_IN_OUT)
			disappearance_tween.tween_property(self, "scale", Vector3(0.3,0.3,0.3), 0.4)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

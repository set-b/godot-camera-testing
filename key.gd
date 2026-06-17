extends MeshInstance3D

@onready var area_3d: Area3D = $"../Area3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.body_entered.connect(func(body: Node) -> void: 
		if body is Player:
			var got_key = Label3D.new()
			got_key.text = "You got the key!"
			got_key.font_size = 30
			got_key.global_position = self.global_position + Vector3(0,1,0)
			got_key.rotate_y(30.0)
			get_tree().current_scene.add_child(got_key)
			self.queue_free()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(2.0 * delta)

extends Camera3D

@onready var player: CharacterBody3D = $"../Player"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# rotate along x and y axis to keep player in view
func _physics_process(delta: float) -> void:
	#self.look_at(player.global_position)
	pass

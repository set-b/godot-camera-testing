extends Node3D

@onready var torch_switch: Node3D = $"../TorchSwitch"
@onready var bookcase_camera: Camera3D = $"../BookcaseCamera"

var move_bookcase : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	torch_switch.pressed.connect(func() -> void:
		move_bookcase = true
	)
	# add signal for move_bookcase stuff

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_bookcase:
		move()
	
func move():
	var move_tween : Tween = create_tween()
	move_tween.set_trans(Tween.TRANS_SINE)
	move_tween.set_ease(Tween.EASE_IN_OUT)
	# might want to do either multiple tweens or set initial bookcase position farther away
	# to prevent bookcase from initially clipping with the ground
	move_tween.tween_property(self, "position", Vector3(0.5,-2.54,0.9), 5.0)
	move_tween.finished.connect(func() -> void:
		get_tree().paused = false
		bookcase_camera.clear_current()
	)
	move_bookcase = false

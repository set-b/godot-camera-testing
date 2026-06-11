extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var play : bool = true
var finished : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("minotaur ready")
	animation_player.play("Action")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	# play is true upon startup
	# play is false after the animation is finished
	# finished is true at the beginning of this executed code block
	#if play and not finished:
		#finished = true
		#animation_player.play("Action")
		#animation_player.animation_finished.connect(func() -> void:
			#play = false
		#)

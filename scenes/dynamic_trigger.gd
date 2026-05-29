extends Area3D

@onready var player: CharacterBody3D = $"../Player"
@onready var dynamic_fixed_2: Camera3D = $"../DynamicFixed2"
@onready var dynamic_fixed_1: Camera3D = $"../DynamicFixed1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(
		func(body: Node3D) -> void:
			if body == player:
				dynamic_fixed_2.make_current()
	)
	
	# might need to change camera basis for player
	body_exited.connect(
		func(body: Node3D) -> void:
			if body == player:
				dynamic_fixed_1.make_current()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

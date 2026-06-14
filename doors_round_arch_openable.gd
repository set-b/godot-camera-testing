extends Node3D
@onready var chest_gold: Node3D = $"../../Chest_Gold"
@onready var animation_player : AnimationPlayer = $"AnimationPlayer"
@onready var area_3d: Area3D = $Area3D
@onready var exit_area: Area3D = $ExitArea

var openable : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.body_entered.connect(func(body: Node3D) -> void:
		if body is Player and !openable:
			print("openable!")
			openable = true
			animation_player.play("open")
	)
	
	exit_area.body_entered.connect(func(body: Node3D) -> void:
		if body is Player and openable == true:
			animation_player.play_backwards("open")
			openable = false
			$Area3D/CollisionShape3D.set_deferred("disabled", true)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

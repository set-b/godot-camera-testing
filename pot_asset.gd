class_name Pot extends Node3D
@onready var area_3d: Area3D = $Area3D
@onready var broken_pot = preload("res://pot_broken_asset.tscn")
signal damage
# Called when the node enters the scene tree for the first time	.
func _ready() -> void:
	area_3d.body_entered.connect(pot_check)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pot_check(body: Node) -> void:
	if body is Minotaur:
		var broken_pot_instance := broken_pot.instantiate()
		broken_pot_instance.global_position = self.global_position
		# will this trigger?
		get_tree().current_scene.add_child(broken_pot_instance)
		body.hurt()
		self.queue_free()

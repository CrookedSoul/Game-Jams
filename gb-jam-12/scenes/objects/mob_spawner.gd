extends Node2D
class_name MobSpawner

@export var mob_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func spawn():
	var mob_instantiated = mob_scene.instantiate()
	mob_instantiated.global_position = global_position
	get_tree().get_first_node_in_group("foreground_layer").add_child(mob_instantiated)
	
	Callable(queue_free).call_deferred();
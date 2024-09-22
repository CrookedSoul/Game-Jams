extends Node2D

@onready var stepped_on_component = $SteppedOnComponent

@export var spawners_connected : Array[Node2D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stepped_on_component.stepped_on.connect(on_stepped_on)


func on_stepped_on():
	for spawner in spawners_connected:
		if spawner is MobSpawner:
			(spawner as MobSpawner).spawn() 
			
		if spawner is Boss:
			(spawner as Boss).start_transforming() 
	
	queue_free()
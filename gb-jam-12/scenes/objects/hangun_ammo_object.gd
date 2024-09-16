extends Node2D

@onready var interactable_component = $InteractableComponent
@export var item_data : ItemData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)


func on_interaction():
	GameEvents.emit_take_item(item_data)
	queue_free()
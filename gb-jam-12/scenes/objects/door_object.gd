extends StaticBody2D

@onready var interactable_component = $InteractableComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)


func on_interaction():
	GameEvents.emit_level_change(PlayerStats.current_level + 1)
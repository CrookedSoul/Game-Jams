extends Node2D

@onready var interactable_component = $InteractableComponent
@export var item_data : ItemData

var dialog_text : Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)
	dialog_text.append("Footsteps, let's follow.")


func on_interaction():
	GameEvents.emit_start_dialog(dialog_text);

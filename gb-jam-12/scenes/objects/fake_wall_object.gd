extends StaticBody2D
class_name FakeWallObject

@onready var interactable_component = $InteractableComponent

var dialog_text : Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)
	dialog_text.append("Something suspicious,")
	dialog_text.append("About this wall i mean.")


func on_interaction():
	GameEvents.emit_start_dialog(dialog_text);

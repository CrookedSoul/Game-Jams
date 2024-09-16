extends StaticBody2D

@onready var interactable_component = $InteractableComponent

var dialog_text : Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)
	dialog_text.append("This is where it all happened,")
	dialog_text.append("Wait for me Anna, i am coming!")


func on_interaction():
	GameEvents.emit_start_dialog(dialog_text);
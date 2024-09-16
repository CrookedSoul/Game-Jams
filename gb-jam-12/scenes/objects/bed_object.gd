extends StaticBody2D

@onready var interactable_component = $InteractableComponent
@onready var interactable_collision = $InteractableComponent/CollisionShape2D

var dialog_text : Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)
	dialog_text.append("This is my bed,")
	dialog_text.append("i should search for Anna")


func on_interaction():
	GameEvents.emit_start_dialog(dialog_text);
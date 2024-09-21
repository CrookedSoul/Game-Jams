extends Node2D

@onready var interactable_component = $InteractableComponent
@export var objects_to_switch : Array[Node2D]

var dialog_text : Array[String]
var dialog_text_used : Array[String]
var switch_used : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)
	dialog_text.append("Something,")
	dialog_text.append("Somewhere,")
	dialog_text.append("Happened.")
	dialog_text_used.append("I already used this.")

func on_interaction():
	if switch_used:
		GameEvents.emit_start_dialog(dialog_text_used);
	else:
		GameEvents.emit_start_dialog(dialog_text);

	if objects_to_switch != null:
		for object in objects_to_switch:
			if object is WallTrapObject:
				(object as WallTrapObject).slow_down()
			elif object is FakeWallObject:
				object.queue_free()


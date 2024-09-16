extends Node2D

@onready var interactable_component = $InteractableComponent
@export var item_data : ItemData

var dialog_text_item : Array[String]
var dialog_text_no_item : Array[String]
var has_item: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)
	dialog_text_item.append("Ah, my water gun,")
	dialog_text_item.append("could be useful with holy water.")
	dialog_text_no_item.append("Empty drawer.")


func on_interaction():
	if has_item:
		GameEvents.emit_start_dialog(dialog_text_item);
		GameEvents.emit_take_item(item_data)
		has_item = false
	else:
		GameEvents.emit_start_dialog(dialog_text_no_item);

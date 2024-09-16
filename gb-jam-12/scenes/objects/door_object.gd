extends StaticBody2D

@onready var interactable_component = $InteractableComponent

var dialog_text_no_weapon : Array[String]
var dialog_text_no_ammo : Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_component.interactable.connect(on_interaction)
	dialog_text_no_weapon.append("I need a weapon,")
	dialog_text_no_weapon.append("Check in that drawer!")
	dialog_text_no_ammo.append("I have no ammo,")
	dialog_text_no_ammo.append("Search for some ammo!")


func on_interaction():
	if PlayerStats.current_level == 1 && !PlayerStats.has_weapon:
		GameEvents.emit_start_dialog(dialog_text_no_weapon);	
	elif PlayerStats.current_level == 1 && !PlayerStats.has_ammo:
		GameEvents.emit_start_dialog(dialog_text_no_ammo);
	else:
		GameEvents.emit_level_change(PlayerStats.current_level + 1)
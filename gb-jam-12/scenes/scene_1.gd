extends Node2D

var start_text : Array[String]
var start_text_shown : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !start_text_shown && GameEvents.ui_visible:
		start_text_shown = true
		start_text.append("They took my sister...")
		start_text.append("One moment she was there,")
		start_text.append("the next—gone.")
		GameEvents.emit_start_dialog(start_text);
	pass

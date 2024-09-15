extends Node

@export var ui_margin_container : MarginContainer
@export var game_view : Node
var scene_1 = preload("res://scenes/scene_1.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_margin_container.visible = false
	GameEvents.set_ui_visibility.connect(on_set_ui_visibility)
	GameEvents.level_change.connect(on_level_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_set_ui_visibility(visible: bool):
	ui_margin_container.visible = visible

func on_level_change(level: int):
	var children = game_view.get_children()
	if children == null:
		return;

	for child in children:
		child.queue_free();
	
	if level == 0:
		pass # should go to start screen
	elif level == 1:
		game_view.add_child(scene_1)
	
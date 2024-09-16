extends Node

@export var ui_margin_container : MarginContainer
@export var dialog_margin_container : MarginContainer
@export var game_view : Node
@export var animation_player : AnimationPlayer
var scene_1 = preload("res://scenes/scene_1.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_margin_container.visible = false
	dialog_margin_container.visible = false
	GameEvents.set_ui_visibility.connect(on_set_ui_visibility)
	GameEvents.set_dialog_visibility.connect(on_set_dialog_visibility)
	GameEvents.level_change.connect(on_level_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_set_ui_visibility(visible: bool):
	ui_margin_container.visible = visible

	
func on_set_dialog_visibility(visible: bool):
	dialog_margin_container.visible = visible

var level_loading: int
func on_level_change(level: int):
	level_loading = level

	ui_margin_container.visible = false
	animation_player.play("close_in")

func change_level():
	if !level_loading:
		return
	animation_player.play("open_up")

	var children = game_view.get_children()
	if children == null:
		return;

	for child in children:
		child.queue_free();
	
	if level_loading == 0:
		pass # should go to start screen
	elif level_loading == 1:
		game_view.add_child(scene_1)
	
	level_loading = 9999
	
func show_ui():
	ui_margin_container.visible = true
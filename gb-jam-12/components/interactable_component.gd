extends Area2D

signal interactable()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_body_entered(other_body: Node2D):
	GameEvents.interact_with_item.connect(on_interact_with_item)
	GameEvents.emit_player_can_interact(true)
	
	
func on_body_exited(other_body: Node2D):
	GameEvents.interact_with_item.disconnect(on_interact_with_item)
	GameEvents.emit_player_can_interact(false)


func on_interact_with_item():
	interactable.emit()
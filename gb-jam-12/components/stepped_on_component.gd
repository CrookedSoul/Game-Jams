extends Area2D

signal stepped_on()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(other_body: Node2D):
	stepped_on.emit()
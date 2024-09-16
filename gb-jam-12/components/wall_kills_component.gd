extends Area2D
class_name WallKillsComponent


func _ready():
	body_entered.connect(on_area_entered)


func on_area_entered(other_area: Node2D):
	if (other_area.is_in_group("wall")):
		get_parent().queue_free();

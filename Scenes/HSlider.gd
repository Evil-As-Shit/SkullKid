extends HSlider
@export var path : PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_value_changed(valuez):
	path.progress = valuez
	pass # Replace with function body.

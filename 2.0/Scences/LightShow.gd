extends BackBufferCopy

@export var light1 : PathFollow2D
@export var light2 : PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	light1.progress += 10
	light2.progress += 12

extends Node


enum STATE {START, MAP, GAME}
var current_state = STATE.START : set = set_current_state

func set_current_state(new_state):
	if(new_state == current_state):
		return
	match(new_state):
		STATE.START:
			pass
		STATE.MAP:
			pass
		STATE.GAME:
			pass

	current_state = new_state
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

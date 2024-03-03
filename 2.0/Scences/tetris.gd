extends Node2D

var speed : int = 5
var object
var flip_level = 20
var fast_level = 60



func _ready():
	pass 

func spawn_piece(tempobject):
	var pieces = preload("res://2.0/Scences/tetris_pieces.tscn")
	var piece = pieces.instantiate()
	add_child(piece)
	piece.play(str(randi_range(0,5)))
	piece.stop()
	piece.set_frame(randi_range(0,1))
	piece.position = Vector2(randi_range(10,91),-40)
	tempobject = piece.name
	return tempobject

func _on_fall_timeout():
	var pieces = get_children()
	for child in pieces:
		child.position.y += 7

func move_piece(temp_object):
	var pieces = get_children()
	for child in pieces:
		child.position.y += 7

func _on_spawn_timeout():
	spawn_piece(object)
	pass # Replace with function body.

func _on_fast_fall_timeout():
	var pieces = get_children()
	for child in pieces:
		if child.position.y > fast_level:
			child.position.y += 7


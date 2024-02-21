extends Node

@export var border_layer : CanvasLayer
@export var map_layer : Node2D
@export var start_layer : CanvasLayer
@export var pixel_fade: AnimationPlayer
@export var map_path : AnimatedSprite2D
@export var char_mover : AnimationPlayer
@export var level_nubs : Node2D
@export var text_label : RichTextLabel
@export var debug_label : RichTextLabel
@export var set_list_controller : Control

var game_num= 0   #game number
var song_num = 0   #song number
var text_list = []
var game_list = []
var songs_list = []
var set_list = {}
var temp_list = {}
var games_order = []
var songs_order = []
var set_start = false
var level_offset = 0

enum STATE {START, MAP, GAME}

var current_state : set = set_current_state

func set_current_state(new_state):
	if(new_state == current_state):
		return
	match(new_state):
		STATE.START:
			map_layer.hide()
			border_layer.hide()
			start_layer.show()
#			get_tree().get_root().set_transparent_background(false)
		STATE.MAP:
			debug_label.hide()
			map_layer.show()
			border_layer.show()
			pixel_fade.play_backwards("Pixel_Fade")
			await pixel_fade.animation_finished
			map_path.play(str(game_num + level_offset))
			await map_path.animation_finished
			print("path updated")
			var nubby = level_nubs.get_node(str(game_num+level_offset))
			nubby.show()
			nubby.play("appear")
			await nubby.animation_finished
			print("nubby appeared")
			nubby.play("default")
			char_mover.play(str(game_num+level_offset))
			await char_mover.animation_finished
			print("char move updated")
			text_label.clear()
			text_label.set_text("[center]%s[/center]" % game_list[game_num].to_upper())
			text_label.show()
			set_process_input(true)
		STATE.GAME:
			map_layer.hide()
			border_layer.hide()
			the_program()

	current_state = new_state

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("Set_List"):
		if set_list_controller.is_visible():
			set_list_controller.hide()
		else:
			set_list_controller.show()

	if event.is_action_pressed("Next_Song"):
		if current_state == STATE.GAME:
			if(songs_list[game_num].size() - 1 != song_num):
				song_num = song_num + 1
				the_program()
				return
			else:
				game_num = game_num + 1
				song_num = 0
				if(game_num> game_list.size()-1):
					print("game over")
					OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_Dolphin.bat",[])
					game_num = 0
					song_num = 0
					current_state = STATE.START
					set_process_input(true)
				else:
					set_process_input(false)
					current_state = STATE.MAP

		if current_state == STATE.MAP:
			set_process_input(false)
			text_label.hide()
			pixel_fade.play("Pixel_Fade")
			await pixel_fade.animation_finished
			print("finished fade")
			set_process_input(true)
			current_state = STATE.GAME

		if current_state == STATE.START:
			start_layer.hide()
			load_setlist()

			current_state = STATE.MAP

	if event.is_action_pressed("Previous_Song"):
		pass


func the_program():
	debug_label.show()
	debug_label.clear()
	debug_label.append_text("[center]%s[/center]" % game_list[game_num].to_upper() + "\n[center]%s[/center]" % songs_list[game_num][song_num].to_upper())
	print(game_list[game_num]," - ",songs_list[game_num][song_num])



func _ready():
	OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Song_Controller.bat",[])
	current_state = STATE.START

func load_JSON(path):
	var file = FileAccess.open(path,FileAccess.READ)
	var text = file.get_as_text()
	var json = JSON.new()
	json.parse(text)
	var target = json.get_data()
	return target

func load_setlist():
	temp_list = load_JSON("res://Godot_Scripts/Set_List.json")
	games_order = temp_list["GamesList"]
	temp_list.erase("GamesList")
	songs_order = temp_list["SongsList"]
	temp_list.erase("SongsList")
	#Set the Set List Up in Order using the ordered r
	for k in games_order.size():
		set_list[games_order[k]] = temp_list[games_order[k]]
		for l in songs_order[k].size():
			set_list[games_order[k]]["Games"][songs_order[k][l]] = temp_list[games_order[k]]["Games"][songs_order[k][l]]

	#Remove Games not in Set List
	var remove_list = []
	for game in set_list.keys():
		if(!set_list[game]["In_Set"]):
			remove_list.append(game)
	for game in remove_list:
		var index = games_order.find(game)
		games_order.erase(game)
		songs_order.remove_at(index)

	#Remove Songs from Games not in Set List
	remove_list = []
	for game in games_order.size():
		for song in songs_order[game].size():
			if(!set_list[games_order[game]]["Games"][songs_order[game][song]]["In_Set"]):
				if not [games_order[game]] in remove_list:
					remove_list.append(Vector2(game,song))
	remove_list.reverse()
	for vector in remove_list:
		songs_order[vector.x].remove_at(vector.y)

	game_list = games_order
	songs_list = songs_order
	#Initialize Skull Kid Starting Level if less than 10 games
	level_offset = abs(game_list.size()-10)
	map_path.play(str(level_offset))
	map_path.stop()
	char_mover.play(str(level_offset))
	char_mover.stop()

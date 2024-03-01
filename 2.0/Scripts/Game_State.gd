extends Node

@export var border_layer : CanvasLayer
@export var map_layer : Node2D
@export var start_layer : CanvasLayer
@export var pixel_fade: AnimationPlayer
@export var map_path : AnimatedSprite2D
@export var char_mover : AnimationPlayer
@export var level_nubs : Node2D
@export var text_label : RichTextLabel
@export var practice_label : RichTextLabel
@export var set_list_controller : CanvasLayer
@export var music_player : AudioStreamPlayer
@export var intro_animation : AnimationPlayer

var curtain_down : bool = true
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
var loaded_mp3 : AudioStream = null
var practice_mode = false
var music_position : float
var last_rom : String = ""
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
			if practice_mode == false:
				OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_Dolphin.bat",[])
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
	if event.is_action_pressed("pause_play"):
		if music_player.is_playing():
			music_position = music_player.get_playback_position()
			music_player.stop()
		else:
			music_player.play(music_position)

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event.is_action_pressed("Set_List"):
		if set_list_controller.is_visible():
			set_list_controller.hide()
			
		else:
			set_list_controller.show()

	if event.is_action_pressed("Next_Song"):
		if curtain_down == false:
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
	#					OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_Dolphin.bat",[])
						game_num = 0
						song_num = 0
						current_state = STATE.START
						set_process_input(true)
					else:
						set_process_input(false)
						current_state = STATE.MAP
		else:
			intro_animation.play("intro")
			curtain_down = false
			return

		if current_state == STATE.MAP:
			if practice_mode == false:
				set_process_input(false)
				text_label.hide()
				pixel_fade.play("Pixel_Fade")
				await pixel_fade.animation_finished
				print("finished fade")
				set_process_input(true)
			current_state = STATE.GAME

		if curtain_down == false:
			if current_state == STATE.START:
				start_layer.hide()
				load_setlist()
				current_state = STATE.MAP
				if practice_mode == false:
					set_process_input(false)

	if event.is_action_pressed("Previous_Song"):
		if(song_num != 0):
			song_num = song_num-1
		else:
			game_num= game_num- 1
			song_num = songs_list[game_num].size()-1
		the_program()
	
	if event.is_action_pressed("Restart_Song"):
		print("restarting song")
		if practice_mode == false:
			pass
	#		if(set_list[game_list[game_num]]["Games"][songs_list[game_num][song_num]]["Rom"].get_extension() != ".iso"):
	#			OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_Dolphin.bat",[])
	#		OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Game_Loader.bat",[])
		the_program()

func the_program():
	if practice_mode == true:
		practice_label.show()
		practice_label.clear()
		practice_label.append_text("[center]%s[/center]" % game_list[game_num].to_upper() + "\n[center]%s[/center]" % songs_list[game_num][song_num].to_upper())
		var file = "res://Assets/Music/"+str(game_list[game_num])+"/"+str(songs_list[game_num][song_num])+".mp3"
		music_player.set_stream(load_mp3(file))
		music_player.play()
	else:
		var rom = set_list[game_list[game_num]]["Games"][songs_list[game_num][song_num]]["Rom"]
		var state = set_list[game_list[game_num]]["Games"][songs_list[game_num][song_num]]["State"]
		if(last_rom.get_extension() == "iso" and last_rom != rom):
			print("closing")
			OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_Dolphin.bat",[])
		print(game_list[game_num]," - ",songs_list[game_num][song_num])
		load_bat(rom,state)
		OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Game_Loader.bat",[])

func load_mp3(path:String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file != null:
		var music = AudioStreamMP3.new()
		music.data = file.get_buffer(file.get_length())
		return music

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
	
func load_bat(rom,f_key):
	var file = FileAccess.open("C:/SkullKid/SkullKidGame/Win_Scripts/GameLoader.ahk",FileAccess.WRITE)
	print(rom.get_extension())
	if(last_rom == rom):
		print("same rom")
		if(rom.get_extension() == "iso"):
			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nSend, {F"+str(f_key)+" down}\nsleep 10\nSend, {F"+str(f_key)+" up}\nWinActivate, ahk_exe Dolphin.exe\nreturn")
		else:
			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nSend {F"+str(f_key)+"}\nSleep,200\nWinActivate, ahk_exe EmuHawk.exe\nreturn")
	else:
		if(rom.get_extension() == "iso"):
			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nRun, C:/SkullKid/Roms/"+rom+",,Min\nWinWaitActive, ahk_exe Dolphin.exe\nsleep, 1000\nSend, {F"+str(f_key)+" down}\nsleep 10\nSend, {F"+str(f_key)+" up}\nreturn")
#			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nRun, C:/SkullKid/Roms/"+rom+"\nWinWaitActive, Dolphin 5.0-16627 | JIT64 DC\nSend, {F"+str(f_key)+" down}\nsleep 10\nSend, {F"+str(f_key)+" up}\nWinSet, AlwaysOnTop, On, Dolphin 5.0-16627 | JIT64 DC\nWinActivate, Dolphin 5.0-16627 | JIT64 DC\nreturn")
		elif(rom.get_extension() == "v64" or rom.get_extension() == "z64"):
			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nRun, C:/SkullKid/Roms/"+rom+"\nsleep, 1500\nSend {F"+str(f_key)+"}\nWinActivate, ahk_exe EmuHawk.exe\nreturn")
		else:
			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nRun, C:/SkullKid/Roms/"+rom+"\nsleep, 1000\nSend {F"+str(f_key)+"}\nsleep, 300\nWinActivate, ahk_exe EmuHawk.exe\nreturn")
	last_rom = rom
	
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

func _on_check_button_toggled(_button_pressed):
	if practice_mode == false:
		practice_mode = true
		practice_label.show()
	else:
		practice_mode = false
		practice_label.hide()

extends Node2D

var game_num= 0   #game number
var song_num = 0   #song number
var text_list = []
var game_list = []
var songs_list = []
var set_list = {}
var last_rom = ""
signal next_song_signal
var temp_list = {}
var games_order = []
var songs_order = []
var set_start = false

func _ready():
#	get_tree().get_root().set_transparent_background(true)
	get_node("CanvasLayer/SkullKid64").play("default")
	OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Song_Controller.bat",[])

func start_program():
	get_node("CheckButton").hide()
	temp_list = load_songlist("res://Godot_Scripts/Set_List.json")
	games_order = temp_list["GamesList"]
	temp_list.erase("GamesList")
	songs_order = temp_list["SongsList"]
	temp_list.erase("SongsList")
	#Set the Set List Up in Order using the ordered r
	for k in games_order.size():
#		print(games_order[k])
		set_list[games_order[k]] = temp_list[games_order[k]]
		for l in songs_order[k].size():
#			print(songs_order[k][l])
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

#func _ready():
#	#Start the Song Controller Script
#	OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Song_Controller.bat",[])
#
#	#Load EmuHawk and Dolphin 
##	OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Open_Emulators.bat",[])
#
#	#Load song list from JSON
#	temp_list = load_songlist("res://Godot_Scripts/Set_List.json")
#
#	games_order = temp_list["GamesList"]
#	temp_list.erase("GamesList")
#	songs_order = temp_list["SongsList"]
#	temp_list.erase("SongsList")
#
#	#Set the Set List Up in Order using the ordered r
#	for k in games_order.size():
##		print(games_order[k])
#		set_list[games_order[k]] = temp_list[games_order[k]]
#		for l in songs_order[k].size():
##			print(songs_order[k][l])
#			set_list[games_order[k]]["Games"][songs_order[k][l]] = temp_list[games_order[k]]["Games"][songs_order[k][l]]
#
#	#Remove Games not in Set List
#	var remove_list = []
#	for game in set_list.keys():
#		if(!set_list[game]["In_Set"]):
#			remove_list.append(game)
#	for game in remove_list:
#		var index = games_order.find(game)
#		games_order.erase(game)
#		songs_order.remove_at(index)
#
#	#Remove Songs from Games not in Set List
#	remove_list = []
#	for game in games_order.size():
#		for song in songs_order[game].size():
#			if(!set_list[games_order[game]]["Games"][songs_order[game][song]]["In_Set"]):
#				if not [games_order[game]] in remove_list:
#					remove_list.append(Vector2(game,song))
#	remove_list.reverse()
#	for vector in remove_list:
#		songs_order[vector.x].remove_at(vector.y)
#
#	game_list = games_order
#	songs_list = songs_order
#
##	for game in game_list.size():
##		print(game_list[game])
##		for song in songs_list[game].size():
##			print(songs_list[game][song])
#
##	for game in set_list.keys():
##		for song in set_list[game]["Games"].keys():
##			if set_list[game]["Games"][song]["In_Set"] == false:
###				set_list[game]["Games"].erase(song)
##				pass
##
##	#Create two arrays for the game list (i) and songs list (j) for each game in game list
##	var x = 0
##	for game in set_list.keys():
##		game_list.append(game)
##		songs_list.append([])
##	for game in set_list.keys():
##		for song in set_list[game]["Games"].keys():
##			songs_list[x].append(song)
##		x = x + 1

func _input(_event):
		if(Input.is_action_just_pressed("Next_Song")): # The "p" Button is Pressed *When 'c' is pressed AHK switches to godot and sends the 'C' key.
			if(set_start == true):
				if(songs_list[game_num].size()-1 != song_num):
					song_num = song_num+1
					program()
				else:
					game_num= game_num+ 1
					song_num = 0
					if(game_num> game_list.size()-1):
						print("game over")
						OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_Dolphin.bat",[])
						game_num = 0
						song_num = 0
						return
					else:
						#Insert Map Code Here
						#Pixel fade in MapStuff from black
						#Pause for a second or two, Revel Map Path, Animate Level Nub appear
						#Animate progress in ParthFollow2D to next game level
						#Pause for a second or two
						#Pixel fade out MapStuff to black
						#Resume program
						program()
			else:
				_on_button_pressed()

		if(Input.is_action_just_pressed("Previous_Song")): # The "o" Button is Pressed *When 'a' is pressed AHK switches to godot and sends the '' key.
			if(set_start == true):
				if(song_num != 0):
					song_num = song_num-1
				else:
					game_num= game_num- 1
					song_num = songs_list[game_num].size()-1
				program()
			else:
				_on_button_pressed()
		if(Input.is_action_just_pressed("Restart_Song")):
			print("restarting song")
			if(set_list[game_list[game_num]]["Games"][songs_list[game_num][song_num]]["Rom"].get_extension() != ".iso"):
				OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_Dolphin.bat",[])
			OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Game_Loader.bat",[])

func load_songlist(path):
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
#	if(newgame == true):
#		if(rom.get_extension() != "iso"):
#			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nRun, C:/SkullKid/Roms/"+rom+"\nWinWait, ahk_exe EmuHawk.exe\nSend {F"+str(f_key)+"}\nWinActivate, ahk_exe EmuHawk.exe\nreturn")
#		else:
##			OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_EmuHawk.bat",[])
#			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nRun, C:/SkullKid/Roms/"+rom+"\nWinWaitActive, Dolphin 5.0-16627 | JIT64 DC\nSend, {F"+str(f_key)+" down}\nsleep 10\nSend, {F"+str(f_key)+" up}\nWinSet, AlwaysOnTop, On, Dolphin 5.0-16627 | JIT64 DC\nWinActivate, Dolphin 5.0-16627 | JIT64 DC\nreturn")
#	else:
#		if(rom.get_extension() != "iso"):
#			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nSend, {F"+str(f_key)+"}\nWinSet, AlwaysOnTop, On, ahk_exe EmuHawk.exe\nWinActivate, ahk_exe EmuHawk.exe\nreturn")
#		else:
#			file.store_string("SendMode Input\nSetWorkingDir %A_ScriptDir%\nWinSet, AlwaysOnTop, On, Dolphin 5.0-16627 | JIT64 DC\nWinActivate, Dolphin 5.0-16627 | JIT64 DC\nSend, {F"+str(f_key)+" down}\nsleep 10\nSend, {F"+str(f_key)+" up}\nreturn")

func _on_button_pressed():
	get_node("Main_Menu").hide()
#	get_node("SkullKidMasksSticker").show()
#	get_viewport().transparent_bg = false
#	get_tree().get_root().set_transparent_background(true)
#	OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/C.bat",[])
#	OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Open_EmuHawk.bat",[])
	set_start = true
	start_program()
	program()

func press_f_key(state):
	var path = "C:/SkullKid/SkullKidGame/Win_Scripts/F_Keys/F"+str(state)+".bat"
	OS.execute(path,[])
#	print("F",state," pressed")

func program():
#	OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Open_EmuHawk.bat",[])
	
	var rom = set_list[game_list[game_num]]["Games"][songs_list[game_num][song_num]]["Rom"]
	var state = set_list[game_list[game_num]]["Games"][songs_list[game_num][song_num]]["State"]
	if(last_rom.get_extension() == "iso" and last_rom != rom):
		print("closing")
		OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Close_Dolphin.bat",[])
		pass
	print(game_list[game_num]," - ",songs_list[game_num][song_num])
	load_bat(rom,state)
	OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Game_Loader.bat",[])

#	for game_numin range(game_list.size()):
#		print(game_list[i])
#		for j in range(songs_list[j].size()):
#			print(songs_list[i][j])
#			await self.next_song_signal

#	for game in set_list:
#		print(" - ",game," - ")
#		for song in set_list[game]["Games"]:
#			print(song)
#			rom  = set_list[game]["Games"][song]["Rom"]
#			state = set_list[game]["Games"][song]["State"]
#			if(last_rom != rom):
#				new_game = true
#			else:
#				new_game = false
#			if(last_rom.get_extension() == "iso"):
#				if(rom.get_extension() != "iso"):
#					OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Open_Close_Dolphin.bat",[])
#					OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Open_Close_Dolphin.bat",[])
#			load_bat(rom,state,new_game)
#			OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Game_Loader.bat",[])
#			await self.next_song_signal
#			last_rom = rom
##			if(rom.get_extension() == "iso"):
##				if(new_game == true):
##					OS.execute("C:/SkullKid/SkullKidGame/Win_Scripts/Open_Close_Dolphin.bat",[])



#		for song in set_list[game]["Games"]:
#			print(song)
#			if set_list[game]["Games"][song]["Title"] == true:
#				if rom == set_list[game]["Games"][song]["Path"]:
#					pass
#				else:
#					rom = set_list[game]["Games"][song]["Path"]
#					OS.execute(rom,[])
#					await self.next_song_signal
#			else:
#				if rom == set_list[game]["Games"][song]["Path"]:
#					pass
#				else:
#					rom = set_list[game]["Games"][song]["Path"]
#					OS.execute(rom,[])
##				await get_tree().create_timer(3).timeout
#			if set_list[game]["Games"][song]["Title"] == true:
#				state = set_list[game]["Games"][song]["State"]
#				press_f_key(state)
#			await self.next_song_signal


func _on_check_button_pressed():
	var list = get_node("Control")
	if list.visible == true:
		list.visible = false
	else:
		list.visible = true
	pass # Replace with function body.

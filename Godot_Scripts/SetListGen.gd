extends ScrollContainer

var gamebox = null
var set_list = {}
var temp_list = {}
var games_order = []
var songs_order = []

func _ready():
	gamebox = get_node("VBoxContainer")
#	temp_list = load_songlist("res://Godot_Scripts/Set_List.json")
	games_order = temp_list["GamesList"]
#	temp_list.erase("GamesList")
	songs_order = temp_list["SongsList"]
#	temp_list.erase("SongsList")

	for k in games_order.size():
#		print(games_order[k])
		set_list[games_order[k]] = temp_list[games_order[k]]
		for l in songs_order[k].size():
#			print(songs_order[k][l])
			set_list[games_order[k]]["Games"][songs_order[k][l]] = temp_list[games_order[k]]["Games"][songs_order[k][l]]

	for k in games_order.size():
		var checkbox = CheckBox.new()
		gamebox.add_child(checkbox)
		checkbox.button_pressed = set_list[games_order[k]]["In_Set"]
		checkbox.text = games_order[k]
		var margin = MarginContainer.new()
		gamebox.add_child(margin)
		margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin.name = "margin"
		var songbox = VBoxContainer.new()
		checkbox.add_child(songbox)
		songbox.position = checkbox.position + Vector2(31,31)
		songbox.name = "box"
		for l in songs_order[k].size():
			var checkbox2 = CheckBox.new()
			songbox.add_child(checkbox2)
			checkbox2.button_pressed = set_list[games_order[k]]["Games"][songs_order[k][l]]["In_Set"]
			checkbox2.text = songs_order[k][l]
			margin.custom_minimum_size = margin.custom_minimum_size + Vector2(0,33)

#func save_to_set_list():
#	for game in gamebox.get_children():
#		if not "margin" in game.name:
#			set_list[game.text]["In_Set"] = (game.button_pressed)
#			for box in game.get_children():
#				for song in box.get_children():
#					set_list[game.text]["Games"][song.text]["In_Set"] = (song.button_pressed)
#	save_songlist("res://Godot_Scripts/Set_List.json")
#
#func load_songlist(path):
#	var file = FileAccess.open(path,FileAccess.READ)
#	var text = file.get_as_text()
#	var json = JSON.new()
#	json.parse(text)
#	var target = json.get_data()
#	return target
#
#func save_songlist(path):
#	set_list["GamesList"]=temp_list["GamesList"]
#	set_list["SongsList"]=temp_list["SongsList"]
#	var file = FileAccess.open(path,FileAccess.WRITE)
#	file.store_line(JSON.stringify(set_list,"\t"))
#	file.close()
#	pass
#
#func _on_button_pressed():
#	save_to_set_list()

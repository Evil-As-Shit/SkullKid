extends Control
var set_list = {}
var list = null
var control = null
var start_drop = null
var end_drop = null
var games_order = []
var songs_order = []
@export var font : FontFile
func _ready():
	reload_setlist()

func reload_setlist():
	list = get_node("Tree")
	list.clear()
	var temp_list = load_songlist("C:/SkullKid/SkullKidGame/Godot_Scripts/Set_List.json")
	games_order = temp_list["GamesList"]
#	temp_list.erase("GamesList")
	songs_order = temp_list["SongsList"]
#	temp_list.erase("SongsList")

	for k in games_order.size():
		print(games_order[k])
		set_list[games_order[k]] = temp_list[games_order[k]]
		for l in songs_order[k].size():
			print(songs_order[k][l])
			set_list[games_order[k]]["Games"][songs_order[k][l]] = temp_list[games_order[k]]["Games"][songs_order[k][l]]
	list.set_columns(2)
	
	var root = list.create_item()
	for k in games_order.size():
		var game = list.create_item(root)
		game.set_text(0,games_order[k])
		game.set_custom_font(0,font)
		game.set_cell_mode(1, game.CELL_MODE_CHECK)
		game.set_checked(1,set_list[games_order[k]]["In_Set"])
		game.set_editable(1, true)
		game.set_collapsed(true)
#		checkbox.button_pressed = set_list[games_order[k]]["In_Set"]
		for l in songs_order[k].size():
			var song = list.create_item(game)
			song.set_text(0,songs_order[k][l])
			song.set_custom_font(0,font)
#			song.set_text(1,str(set_list[games_order[k]]["Games"][songs_order[k][l]]["In_Set"]))
			song.set_cell_mode(1,song.CELL_MODE_CHECK)
			song.set_checked(1,set_list[games_order[k]]["Games"][songs_order[k][l]]["In_Set"])
			song.set_editable(1, true)
			song.set_collapsed(true)
#			checkbox2.button_pressed = set_list[games_order[k]]["Games"][songs_order[k][l]]["In_Set"]
#			checkbox2.text = songs_order[k][l]
#			margin.custom_minimum_size = margin.custom_minimum_size + Vector2(0,33)
	list.set_hide_root(true)

func load_songlist(path):
	var file = FileAccess.open(path,FileAccess.READ)
	var text = file.get_as_text()
	var json = JSON.new()
	json.parse(text)
	var target = json.get_data()
	return target

func _input(event):
	if event is InputEventMouseButton and event.is_action_released("click"):
		print("released")
		var posi = (self.get_local_mouse_position())
		end_drop = list.get_item_at_position(posi)
#		print(list.get_drop_section_at_position(position).get_index())
		var drop_value = list.get_drop_section_at_position(posi)
		list.set_drop_mode_flags(0)
		if (start_drop != null):
			if drop_value == 1:
				start_drop.move_after(end_drop)
				pass
			elif drop_value == -1:
				start_drop.move_before(end_drop)
			else:
				pass
			start_drop = null
			end_drop = null
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		print("pressed")
		list.set_drop_mode_flags(2)

func save_to_set_list():
	games_order.clear()
	songs_order.clear()
	var i = -1
	print("button pressed")
	var root = list.get_root()
	for game in root.get_children():
		i = i + 1
		songs_order.append([])
		games_order.append(game.get_text(0))
		set_list[game.get_text(0)]["In_Set"] = game.is_checked(1)
		for song in game.get_children():
			songs_order[i].append(song.get_text(0))
			set_list[game.get_text(0)]["Games"][song.get_text(0)]["In_Set"] = song.is_checked(1)
#		set_list[game.text]["In_Set"] = (game.button_pressed)
#		for box in game.get_children():
#			for song in box.get_children():
#				set_list[game.text]["Games"][song.text]["In_Set"] = (song.button_pressed)
	save_songlist("C:/SkullKid/SkullKidGame/Godot_Scripts/Set_List.json")

func save_songlist(path):
	set_list["GamesList"]=games_order
	set_list["SongsList"]=songs_order
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_line(JSON.stringify(set_list,"\t"))
	file.close()

func _on_tree_item_mouse_selected(posi, _mouse_button_index):
	print(posi)
	print(list.get_item_at_position(posi).get_index())
	start_drop = list.get_item_at_position(posi)

func _on_button_pressed():
	save_to_set_list()
	reload_setlist()

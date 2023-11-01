extends Control


var save_path = "user://data.cfg"
var part = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	
	part = load_game("part_league", save_path, 0)
	if load_game("random_level" + str(part), "user://files.cfg", []).size() <= 20:
		choice_levels()
	add_level_btn()
func save(_name, num, path):
	var confige = ConfigFile.new()
	confige.load(path)
	confige.set_value("user", _name, num)
	confige.save(path)
func load_game(_name, path, defaulte = null):
	var confige = ConfigFile.new()
	confige.load(path)
	return confige.get_value("user", _name, defaulte)
func choice_levels():
	var levels = load_game("levels_league_" + str(part + 1), "user://files.cfg", [])
	var levels2 = []
	if levels.size() > 20:
		var list = choice_num(range(len(levels)), 20)
		for x in list:
			levels2.append(levels[x])
	else:
		levels2 = levels
	var list = []
	for x in range(len(levels2)):
		list.append(1)
	save("state_levels" + str(part), list, save_path)
	save("random_level" + str(part), levels2, "user://files.cfg")
func choice_num(_range, num):
	randomize()
	var list = []
	for x in _range:
		list.append(x)
	var list2 = []
	for x in range(num):
		var z = randi_range(0, len(list) - 1)
		list2.append(list[z])
		list.remove_at(z)
	return list2
func add_level_btn():
	var levels = load_game("random_level" + str(part), "user://files.cfg", [])
	var tilemap = $TileMap.get_used_cells(0)
	
	for x in range(len(levels)):
		var btn = Button.new()
		btn.text = str(x + 1)
		btn.size = Vector2(50, 50)
		btn.global_position = (tilemap[x] * $TileMap.tile_set.tile_size) + ($TileMap.tile_set.tile_size / 2) - (Vector2i(btn.size) / 2) 
		btn.pressed.connect(_on_level_btn_pressed.bind(x))
		$levels.add_child(btn)


func _on_level_btn_pressed(lv):
	save("league_level", lv, save_path)
	for child in get_tree().get_root().get_children():
		if child != AddBee and child != Exit and child != GlobalTime:
			child.queue_free()
	get_tree().change_scene_to_file("res://scenes/league.tscn")


func _on_button_pressed():
	queue_free()

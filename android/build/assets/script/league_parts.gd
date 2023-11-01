extends Control
var save_path = "user://data.cfg"
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func load_game(_name, defaulte = null):
	var confige = ConfigFile.new()
	confige.load(save_path)
	return confige.get_value("user", _name, defaulte)

func _on_button_pressed(mode):
	save("part_league", mode)
	var levels = preload("res://scenes/league_levels.tscn").instantiate()
	get_tree().get_root().add_child(levels)


func _on_button_6_pressed():
	queue_free()
	get_tree().change_scene_to_file("res://scenes/league_menu.tscn")

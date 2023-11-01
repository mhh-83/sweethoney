extends Node


var save_path = "user://data.cfg"
var timer
func _process(delta):
	if get_tree().has_group("timer"):
		if timer == null:
			timer = get_tree().get_nodes_in_group("timer")[0]
	else:
		timer = null
func _notification(what):
	if (what == NOTIFICATION_WM_GO_BACK_REQUEST or what == NOTIFICATION_WM_CLOSE_REQUEST) and timer:
		save("last_time_gift", timer.current_time)
		if get_tree().has_group("hive"):
			for hive in get_tree().get_nodes_in_group("hive"):
				save("last_time_hive"+ str(hive.num), timer.curren_time)
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)

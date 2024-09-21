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
		if get_tree().has_group("honey_hive"):
			for hive in get_tree().get_nodes_in_group("honey_hive"):
				save("last_time_hive"+ str(hive.num), timer.curren_time)
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func change_scene(path):
	for child in get_tree().get_root().get_children():
		if child != AddBee and child != self and child != GlobalTime and child != CheckInternet:
			child.queue_free()
	if get_tree().has_group("timer"):
		save("last_time_gift", get_tree().get_nodes_in_group("timer")[0].current_time)
	get_tree().get_root().add_child(load(path).instantiate())
	

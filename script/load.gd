extends Control
var scene = "res://scenes/start.tscn"
var progress = []
var scene_load_state = 0
var save_path = "user://data.cfg"
var save_img_path = "user://files.cfg"
var load_complate = false
var update_game2 = false
var current_load = 0
var version = "1.4"
var load_list = []
var http
var job_complate = false
var job_complate2 = true
func save(_name, num, path):
	var confige = ConfigFile.new()
	confige.load(path)
	confige.set_value("user", _name, num)
	confige.save(path)
func load_game(_name, path, defaulte=null):
	var confige = ConfigFile.new()
	confige.load(path)
	return confige.get_value("user", _name, defaulte)
# Called when the node enters the scene tree for the first time.
func _ready():
	if load_game("begin", save_img_path, []).size() != 0:
		var image = Image.load_from_file("user://begin/" + load_game("begin", save_img_path, [])[0])
		if image != null:
			$TextureRect.texture = ImageTexture.create_from_image(image)
	if !FileAccess.file_exists(save_path):
		var confige = ConfigFile.new()
		confige.save(save_path)
	if !FileAccess.file_exists(save_img_path):
		var confige = ConfigFile.new()
		confige.save(save_img_path)
	save("version", version, save_path)
	$Panel2.link = load_game("link", save_path, "")
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(request_complated)
	http.request("https://mock.apidog.com/m2/363774-0-default/3969898?apidogApiId=3969898")

func request_complated(result, response_code, header, body):
	if response_code == 0:
		
		no_internet()
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var list = json.get_data()
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(request_complated2)
	http.request(list["1"])

func request_complated2(result, response_code, header, body):
	
	if response_code == 0:
		no_internet()
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	load_list = json.get_data()
	for x in range(load_list.size()):
		if !load_list[x].is_empty():
			_on_http_request_request_completed(load_list[x])
	job_complate = true
func _http_request_completed(body, url:String, _name2, array=false):
	$Timer.start()
	var err
	if body != null:
		err = OK
	var list = load_game(_name2, save_img_path, [])
	var image = body
	if !DirAccess.dir_exists_absolute("user://"+_name2):
		DirAccess.make_dir_absolute("user://"+_name2)
	if url.get_extension().left(4) != "json":
		if url.get_extension().left(3) == "png":
			image.save_png("user://" +_name2+ "/" + url.get_file().get_basename() + "." + url.get_extension().left(3))
		else:
			image.save_jpg("user://" +_name2+ "/" + url.get_file().get_basename() + "." + url.get_extension().left(3))
		list.append(url.get_file().get_basename() + "." + url.get_extension().left(3))
	else:
		var json = JSON.new()
		var file = FileAccess.open("user://"+_name2+"/"+url.get_file().get_basename() + ".json", FileAccess.WRITE)
		file.store_line(JSON.stringify(body))
		file.close()
		list.append(url.get_file().get_basename() + ".json")
	if err == OK:
		if _name2 == "begin":
			$TextureRect.texture = ImageTexture.create_from_image(image)
		if !array:
			save(_name2, list, save_img_path)
			var icons = load_game(_name2, save_path, [])
			icons.append(url)
			save(_name2, icons, save_path)
func _input(event):
	if event is InputEventScreenTouch and load_complate:
		Exit.change_scene(scene)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "load_complate":
		$AnimationPlayer.play_backwards("effect")

func _on_http_request_request_completed(body:Array):
	var _name = body[0]
	$Timer.start()
	var change_list = []
	if body != null and body.size() > 0:
		if _name == "version":
			if load_game("version", save_path) != body[1]:
				update_game()
				update_game2 = true
				$HTTPManager.queue_free()
				if get_tree().has_group("loader"):
					get_tree().get_nodes_in_group("loader")[0].queue_free()
				return
		elif _name == "link":
			save(_name, body[1], save_path)
		else:
			if typeof(body[1]) == TYPE_ARRAY and body[1].size() > 0:
				if typeof(body[1][0]) != TYPE_ARRAY:
					if load_game(_name, save_path, []).size() == 0 or typeof(load_game(_name, save_path, [])[0]) == TYPE_ARRAY:
						var list = []
						save(_name, list, save_path)
						save(_name, list, save_img_path)
					for x in range(body[1].size()):
						if !load_game(_name, save_path, []).has(body[1][x]):
							change_list.append(body[1][x])
					for x in range(load_game(_name, save_path, []).size()):
						if !body[1].has(load_game(_name, save_path, [])[x]):
							var icons = load_game(_name, save_path, [])
							var icons_i = load_game(_name, save_img_path, [])
							var url = icons[x]
							if url.get_extension().left(4) != "json":
								DirAccess.remove_absolute("user://" + _name + "/" + url.get_file().get_basename() + "." + url.get_extension().left(3))
								icons_i.erase(url.get_file().get_basename() + "." + url.get_extension().left(3))
							else:
								DirAccess.remove_absolute("user://" + _name + "/" + url.get_file().get_basename() + ".json")
								icons_i.erase(url.get_file().get_basename() + ".json")
								if _name == "time_league":
									save("begin_league", false, save_path)
									save("close_league", false, save_path)
									save("begin_league", false, save_path)
							icons.erase(url)
							save(_name, icons, save_path)
							save(_name, icons_i, save_img_path)
				else:
					change_list = []
					for x in range(body[1].size()):
						if load_game(_name, save_path, []).size() == 0 or typeof(load_game(_name, save_path, [])[x % load_game(_name, save_path, []).size()]) != TYPE_ARRAY:
							var list = []
							for z in range(body[1].size()):
								list.append([])
							save(_name, list, save_path)
							save(_name, list, save_img_path)
						if load_game(_name, save_path, []).size() < body[1].size():
							var list = load_game(_name, save_path, [])
							var list2 = load_game(_name, save_img_path, [])
							for z in range(-load_game(_name, save_path, []).size() + body[1].size()):
								list.append([])
								list2.append([])
							save(_name, list, save_path)
							save(_name, list, save_img_path)
					var l = load_game(_name, save_img_path, [])
					var l2 = load_game(_name, save_path, [])
					for x in range(load_game(_name, save_img_path, []).size()):
						for y in range(load_game(_name, save_img_path, [])[x].size()):
							var file = load_game(_name, save_img_path, [])[x][y]
							var file2 = load_game(_name, save_path, [])[x][y]
							if !FileAccess.file_exists("user://"+ _name + "/" + file):
								l[x].erase(file)
								l2[x].erase(file2)
					save(_name, l2, save_path)
					save(_name, l, save_img_path)
					for x in range(body[1].size()):
						for y in range(body[1][x].size()):
							var list = load_game(_name, save_path, [])
							var list2 = load_game(_name, save_img_path, [])
							if !load_game(_name, save_path, [])[x].has(body[1][x][y]):
								change_list.append(body[1][x][y])
								list[x].append(body[1][x][y])
								list2[x].append(body[1][x][y].get_file().get_basename() + ".json")
							save(_name, list, save_path)
							save(_name, list2, save_img_path)
					for x in range(load_game(_name, save_path, []).size()):
						for y in range(load_game(_name, save_path, [])[x].size()): 
							if !body[1][x].has(load_game(_name, save_path, [])[x][y]):
								var icons = load_game(_name, save_path, [])
								var icons_i = load_game(_name, save_img_path, [])
								var url = icons[x][y]
								DirAccess.remove_absolute("user://" + _name + "/" + url.get_file().get_basename() + ".json")
								icons_i[x].erase(url.get_file().get_basename() + ".json")
								if _name == "time_league":
									save("begin_league", false, save_path)
									save("close_league", false, save_path)
									save("begin_league", false, save_path)
								icons[x].erase(url)
								save(_name, icons, save_path)
								save(_name, icons_i, save_img_path)
					var list : Array= load_game(_name, save_path, [])
					var list2 : Array = load_game(_name, save_img_path, [])
					for z in list:
						if z.is_empty():
							list.erase(z)
					for z in list2:
						if z.is_empty():
							list2.erase(z)
					save(_name, list, save_path)
					save(_name, list2, save_img_path)
	if change_list.size() > 0:
		for x in range(change_list.size()):
			job_complate2 = false
			$HTTPManager2.job(
			change_list[x]
			).on_success( 
				func(response): pass; _http_request_completed(response.fetch(), change_list[x], _name, typeof(body[1][0]) == TYPE_ARRAY)
			).get()

func _process(delta):
	if !update_game2 and job_complate and job_complate2:
		load_complate = true
		$Timer.stop()
		if $AnimationPlayer.current_animation != "effect":
			$AnimationPlayer.play("effect")
	
func no_internet():
	$Timer.stop()
	$AnimationPlayer.play("RESET")
	$Panel.show()

func _on_button_pressed():
	queue_free()
	get_tree().reload_current_scene()
func update_game():
	$Timer.stop()
	$Panel2.show()
	$Node2D.hide()
func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()
func _on_http_manager_job_failed(object):
	$HTTPManager.queue_free()
	if get_tree().has_group("loader"):
		get_tree().get_nodes_in_group("loader")[0].queue_free()
	no_internet()

func _on_http_manager_completed():
	job_complate = true

func _on_http_manager_2_completed():
	job_complate2 = true

func _on_timer_timeout():
	$Weak_internet.popup()

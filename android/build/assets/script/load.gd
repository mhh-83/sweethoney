extends Control

@onready var scene = "res://scenes/start.tscn"

var progress = []
var scene_load_state = 0
var save_path = "user://data.cfg"
var save_img_path = "user://files.cfg"
var load_complate = false
var update_game2 = false
var load_list = [
"https://mock.apidog.com/m2/363774-0-default/3750064?apidogApiId=3750064&apidogToken=ZHZunnawqfMRhDpCKzpBs3Zlwl1lKONl",
"https://mock.apidog.com/m2/363774-0-default/3969898?apidogApiId=3969898",
"https://mock.apidog.com/m2/363774-0-default/3747765?apidogApiId=3747765&apidogToken=ZHZunnawqfMRhDpCKzpBs3Zlwl1lKONl",
"https://mock.apidog.com/m2/363774-0-default/3730290?apidogApiId=3730290&apidogToken=ZHZunnawqfMRhDpCKzpBs3Zlwl1lKONl",
"https://mock.apidog.com/m2/363774-0-default/3742255?apidogApiId=3742255&apidogToken=ZHZunnawqfMRhDpCKzpBs3Zlwl1lKONl",
"https://mock.apidog.com/m2/363774-0-default/3742639?apidogApiId=3742639&apidogToken=ZHZunnawqfMRhDpCKzpBs3Zlwl1lKONl",
"https://mock.apidog.com/m2/363774-0-default/3742640?apidogApiId=3742640&apidogToken=ZHZunnawqfMRhDpCKzpBs3Zlwl1lKONl",
"https://mock.apidog.com/m2/363774-0-default/3742641?apidogApiId=3742641&apidogToken=ZHZunnawqfMRhDpCKzpBs3Zlwl1lKONl",
'https://mock.apidog.com/m2/363774-0-default/3928900?apidogApiId=3928900',
"https://mock.apidog.com/m2/363774-0-default/3928901?apidogApiId=3928901",
"https://mock.apidog.com/m2/363774-0-default/3928902?apidogApiId=3928902",
"https://mock.apidog.com/m2/363774-0-default/3928905?apidogApiId=3928905",
"https://mock.apidog.com/m2/363774-0-default/3928911?apidogApiId=3928911",
"https://mock.apidog.com/m2/363774-0-default/3745645?apidogApiId=3745645&apidogToken=ZHZunnawqfMRhDpCKzpBs3Zlwl1lKONl",
"https://mock.apidog.com/m2/363774-0-default/3938642?apidogApiId=3938642"
]
var load_name = ["version", "link", "begin", "icons", "levels_home", "levels_village", "levels_school", "levels_mosque", "levels_league_1", "levels_league_2", "levels_league_3", "levels_league_4", "levels_league_5", "daily_gift_time", "time_league"]
var load_name2 = ["بروزرسانی", "عکس صفحه شروع", "آیکون ها", "مراحل منزل", "مراحل محله", "مراحل مدرسه", "مراحل مسجد", "مراحل لیگ بخش 1", "مراحل لیگ بخش 2", "مراحل لیگ بخش 3", "مراحل لیگ بخش 4", "مراحل لیگ بخش 5","زمان جایزه روزانه", "زمان لیگ"]
var current_load = 0
var version = "1.3"
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
	for x in range(load_list.size()):
		$HTTPManager.job(
			load_list[x]
		).on_success( 
			func(response): pass; _on_http_request_request_completed(response.fetch(), load_name[x])
		).on_failure(func(response): no_internet()).get()


	
	
func _http_request_completed(body, url:String, _name2):

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
		save(_name2, list, save_img_path)
		var icons = load_game(_name2, save_path, [])
		icons.append(url)
		save(_name2, icons, save_path)
func _input(event):
	if event is InputEventScreenTouch and load_complate:
		queue_free()
		get_tree().change_scene_to_file(scene)
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "load_complate":
		$AnimationPlayer.play_backwards("effect")



func _on_http_request_request_completed(body, _name):

	
	var c = body
	var change_list = []
	if c != null and c.size() > 0:
		
		if _name == "version":
			if load_game("version", save_path) != c["1"]:
				update_game()
				update_game2 = true
				$HTTPManager.queue_free()
				if get_tree().has_group("loader"):
					get_tree().get_nodes_in_group("loader")[0].queue_free()
				return
		elif _name == "link":
			save(_name, c["1"], save_path)
		else:
			for x in range(c.size()):
				if !load_game(_name, save_path, []).has(c[str(x+1)]):
					change_list.append(c[str(x+1)])
			for x in range(load_game(_name, save_path, []).size()):
				if !c.values().has(load_game(_name, save_path, [])[x]):
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
	if change_list.size() > 0:
		for x in range(change_list.size()):
			job_complate2 = false
			$HTTPManager2.job(
			change_list[x]
			).on_success( 
				func(response): pass; _http_request_completed(response.fetch(), change_list[x], _name)
			).get()

func _process(delta):
	if !update_game2 and job_complate and job_complate2:
		load_complate = true
		if $AnimationPlayer.current_animation != "effect":
			$AnimationPlayer.play("effect")

func no_internet():
	$AnimationPlayer.play("RESET")
	$Panel.show()

func _on_button_pressed():
	queue_free()
	get_tree().reload_current_scene()
func update_game():
	$Panel2.show()


func _on_http_manager_job_failed(object):
	$HTTPManager.queue_free()
	if get_tree().has_group("loader"):
		get_tree().get_nodes_in_group("loader")[0].queue_free()
	no_internet()


func _on_http_manager_completed():
	job_complate = true
		


func _on_http_manager_2_completed():
	job_complate2 = true

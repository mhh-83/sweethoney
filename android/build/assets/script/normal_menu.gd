extends Control

var level = 1
var max_level = 1
var unlock_level = 1
var save_path = "user://data.cfg"
var part = 0
var teach = true
# Called when the node enters the scene tree for the first time.
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func load_game(_name, defaulte=null):
	var confige = ConfigFile.new()
	confige.load(save_path)
	return confige.get_value("user", _name, defaulte)
func load_game2(_name, defaulte=null):
	var confige = ConfigFile.new()
	confige.load("user://files.cfg")
	return confige.get_value("user", _name, defaulte)
func _ready():

	if FileAccess.file_exists(save_path):
		level = load_game("level", 1)
		teach = load_game("teach", true)
		$VBoxContainer/HBoxContainer4/Control/Panel/Label.text = load_game('name', "")
		$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = false
		var part_list = [["levels_home", "h"], ["levels_village", "v"], ["levels_school", "s"], ["levels_mosque", "m"]]
		for x in range(part_list.size()):
			save("max_level_"+part_list[x][1], len(load_game2(part_list[x][0], [])))
		part = load_game("part", 0)
	
	match part:
		0:
			max_level = load_game("max_level_h", 1)
			unlock_level = load_game("unlock_level_h", 1)
		1:
			max_level = load_game("max_level_v", 1)
			unlock_level = load_game("unlock_level_v", 1)
		2:
			max_level = load_game("max_level_s", 1)
			unlock_level = load_game("unlock_level_s", 1)
		3:
			max_level = load_game("max_level_m", 1)
			unlock_level = load_game("unlock_level_m", 1)
	
	if level > max_level:
		level = max_level
		save("level", level)
	
	if load_game("img", "") != "":
		$VBoxContainer/HBoxContainer4/Control/Panel/TextureButton2.show()
		$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/Label.hide()
		var tex = load("res://sprite/user_img.png")
		if FileAccess.file_exists("user://icons/" + load_game("img")):
			var image = Image.load_from_file("user://icons/" + load_game("img"))
			tex = ImageTexture.create_from_image(image)
		else:
			save("img", "")
			$VBoxContainer/HBoxContainer4/Control/Panel/TextureButton2.hide()
		$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.texture = tex
	else:
		$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.texture = load("res://sprite/user_img.png")
	$VBoxContainer/HBoxContainer4/Control/Panel/Label2.text = "امتیاز : "+ str(load_game("score", 0))
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect2.value = load_game("score", 0) * 100 / 5000
	$icons/icons.button_pressed.connect(_on_icons_button_pressed)






func _on_texture_button_pressed():
	$icons.show()
	

func _on_label_text_submitted(new_text):
	var t = new_text.split(" ")
	var text = ""
	for x in t:
		if x != "":
			text += x
	if text != "" and new_text != "":
		save("name", new_text)
		$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = false


func _on_edit_name_pressed():
	$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = true


func _on_icons_button_pressed(img):
	save("img_mode", 0)
	save("img", img)
	save("rotate_img", 0)
	var image = Image.load_from_file("user://icons/" + load_game("img"))
	var tex = ImageTexture.create_from_image(image)
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.texture = tex
	$icons.hide()
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/Label.hide()
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureButton2.show()


func _on_levels_pressed():
	add_child(preload("res://scenes/particles.tscn").instantiate())
	await get_tree().create_timer(3).timeout
	get_node("particles").queue_free()
	var m = preload("res://scenes/menu_levels.tscn").instantiate()
	m.teach = teach
	get_tree().get_root().add_child(m)


func _on_persian_button_pressed():
	add_child(preload("res://scenes/particles.tscn").instantiate())
	await get_tree().create_timer(3).timeout
	queue_free()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_persian_button_3_pressed():
	queue_free()
	get_tree().change_scene_to_file("res://scenes/start.tscn")
	
func _on_gui_input(event):
	if event is InputEventScreenTouch:
		var t = $VBoxContainer/HBoxContainer4/Control/Panel/Label.text.split(" ")
		var text = ""
		for x in t:
			if x != "":
				text += x
		if text != "" and $VBoxContainer/HBoxContainer4/Control/Panel/Label.text != "":
			save("name", $VBoxContainer/HBoxContainer4/Control/Panel/Label.text)
			$VBoxContainer/HBoxContainer4/Control/Panel/Label.editable = false

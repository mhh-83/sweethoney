extends Control
enum Mode{Home, Village, school, mosque}
var mode = Mode.Home
var max_level = 1
var unlock_level = 1
var save_path = "user://data.cfg"
var col = 5
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func load_game(_name, defaulte=null):
	var confige = ConfigFile.new()
	confige.load(save_path)
	return confige.get_value("user", _name, defaulte)
func _ready():
	mode = load_game("part", 0)
	
	match mode:
		Mode.Home:
			$TextureRect.texture = preload("res://sprite/home.jpg")
			max_level = load_game("max_level_h", 1)
			unlock_level = load_game("unlock_level_h", 1)
			
			
			$ScrollContainer/GridContainer.add_theme_constant_override("h_separation", 110)
			$ScrollContainer2/VBoxContainer.add_theme_constant_override("separation", 110)
			$ScrollContainer/GridContainer.add_theme_constant_override("v_separation", 110)
			$AnimationPlayer2.play("home")
		Mode.Village:
			$TextureRect.texture = preload("res://sprite/mahale5.jpg")
			max_level = load_game("max_level_v", 1)
			unlock_level = load_game("unlock_level_v", 1)
			$ScrollContainer2/VBoxContainer.add_theme_constant_override("separation", 110)
			$ScrollContainer/GridContainer.add_theme_constant_override("v_separation", 110)
			$ScrollContainer/GridContainer.add_theme_constant_override("h_separation", 110)
			$AnimationPlayer2.play("village")
		Mode.school:
			col = 7
			$AnimationPlayer2.play("school")
			max_level = load_game("max_level_s", 1)
			unlock_level = load_game("unlock_level_s", 1)
			$TextureRect.texture = preload("res://sprite/madrase2.jpg")
			$ScrollContainer/GridContainer.columns = col
			$ScrollContainer2/VBoxContainer.add_theme_constant_override("separation", 140)
			$ScrollContainer/GridContainer.add_theme_constant_override("v_separation", 140)
			$ScrollContainer/GridContainer.add_theme_constant_override("h_separation", 90)
		Mode.mosque:
			col = 6
			$ScrollContainer2/VBoxContainer.add_theme_constant_override("separation", 110)
			max_level = load_game("max_level_m", 1)
			$ScrollContainer/GridContainer.columns = col
			unlock_level = load_game("unlock_level_m", 1)
			$TextureRect.texture = preload("res://sprite/masjed9.jpg")
			$ScrollContainer/GridContainer.add_theme_constant_override("v_separation", 100)
			$ScrollContainer/GridContainer.add_theme_constant_override("h_separation", 100)
			$AnimationPlayer2.play("mosque")
	$ScrollContainer2.size = $ScrollContainer.size
	$ScrollContainer2.position = $ScrollContainer.position
	if OS.get_name() == "Windows":
		for x in range(max_level):
			add_btn(x)
	else:
		add_btn_mobile(max_level)
func write_num(_name, num):
	var file = FileAccess.open("user://files/"+_name+".txt", FileAccess.WRITE)
	file.store_var(num)
	file.close()
func add_btn(lv):
	var texturs_normal = ["res://sprite/honey.png", "res://sprite/iconmahale-.png", "res://sprite/gol3.png", "res://sprite/3.png"]
	var texturs_disabled = ["res://sprite/empty_honey.png", "res://sprite/iconmahale1-.png", "res://sprite/gol4.png", "res://sprite/5.png"]
	var texturs_pressed = ["res://sprite/honey (11).png", "res://sprite/iconmahale13-.png", "res://sprite/gol5.png", "res://sprite/4.png"]

	var btn = TextureButton.new()
	btn.texture_normal = load(texturs_normal[mode])
	btn.texture_disabled = load(texturs_disabled[mode])
	btn.texture_pressed = load(texturs_pressed[mode])
	btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	btn.ignore_texture_size = true
	btn.pressed.connect(on_btn_pressed.bind(lv + 1))
	btn.size = Vector2(100, 100)
	btn.add_theme_constant_override("outline_size", 10)
	var label = Label.new()
	label.add_theme_color_override("font_color", Color("1a6f4f"))
	label.add_theme_font_override("font", preload("res://fonts/B Titr Bold_0.ttf"))
	label.add_theme_color_override("font_outline_color", Color("fdfdfd"))
	label.text = str(lv + 1)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	match mode:
		0:
			label.add_theme_font_size_override("font_size", 45)
			label.add_theme_constant_override("outline", 5)
			btn.size = Vector2(100, 100)
		1:
			label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
			label.add_theme_font_size_override("font_size", 50)
			label.add_theme_constant_override("outline_size", 5)
			label.add_theme_color_override("font_outline_color", Color("ffffff"))
		2:
			btn.size = Vector2(80, 130)
			label.add_theme_constant_override("outline_size", 5)
			label.add_theme_color_override("font_outline_color", Color.BLACK)
			label.add_theme_color_override("font_color", Color.WHEAT)
			label.add_theme_font_size_override("font_size", 45)
			label.add_theme_constant_override("outline", 5)
		3:
			btn.size = Vector2(90, 90)
			label.add_theme_constant_override("outline_size", 5)
			label.add_theme_color_override("font_outline_color", Color.BLACK)
			label.add_theme_color_override("font_color", Color.RED)
			label.add_theme_font_size_override("font_size", 45)
			label.add_theme_constant_override("outline", 5)
	btn.add_child(label)
	if lv + 1 > unlock_level:
		btn.disabled = true
	var control = Control.new()
	control.add_child(btn)
	$ScrollContainer/GridContainer.add_child(control)
	if lv == max_level - 1:
		for x in range(max_level % col):
			$ScrollContainer/GridContainer.add_child(Control.new())
func add_btn_mobile(max_lv):
	var texturs_normal = ["res://sprite/honey.png", "res://sprite/iconmahale-.png", "res://sprite/gol3.png", "res://sprite/3.png"]
	var texturs_disabled = ["res://sprite/empty_honey.png", "res://sprite/iconmahale1-.png", "res://sprite/gol4.png", "res://sprite/5.png"]
	var texturs_pressed = ["res://sprite/honey (11).png", "res://sprite/iconmahale13-.png", "res://sprite/gol5.png", "res://sprite/4.png"]
	for x in range(int(max_lv / col) + 1):
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		match mode:
			0:
				hbox.add_theme_constant_override("separation", 110)
				
			1:
				hbox.add_theme_constant_override("separation", 110)
				
			2:
				hbox.add_theme_constant_override("separation", 90)
				
			3:
				hbox.add_theme_constant_override("separation", 100)
	
		$ScrollContainer2/VBoxContainer.add_child(hbox)
	for lv in range(max_lv):
		var btn = TextureButton.new()
		btn.texture_normal = load(texturs_normal[mode])
		btn.texture_disabled = load(texturs_disabled[mode])
		btn.texture_pressed = load(texturs_pressed[mode])
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.ignore_texture_size = true
		btn.pressed.connect(on_btn_pressed.bind(lv + 1))
		btn.size = Vector2(100, 100)
		btn.add_theme_constant_override("outline_size", 10)
		var label = Label.new()
		label.add_theme_color_override("font_color", Color("1a6f4f"))
		label.add_theme_font_override("font", preload("res://fonts/B Titr Bold_0.ttf"))
		label.add_theme_color_override("font_outline_color", Color("fdfdfd"))
		label.text = str(lv + 1)
		match mode:
			0:
				label.add_theme_font_size_override("font_size", 45)
				label.add_theme_constant_override("outline", 5)
				btn.size = Vector2(100, 100)
			1:
				label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
				label.add_theme_font_size_override("font_size", 50)
				label.add_theme_constant_override("outline_size", 5)
				label.add_theme_color_override("font_outline_color", Color("ffffff"))
			2:
				btn.size = Vector2(80, 130)
				label.add_theme_constant_override("outline_size", 5)
				label.add_theme_color_override("font_outline_color", Color.BLACK)
				label.add_theme_color_override("font_color", Color.WHEAT)
				label.add_theme_font_size_override("font_size", 45)
				label.add_theme_constant_override("outline", 5)
			3:
				btn.size = Vector2(90, 90)
				label.add_theme_constant_override("outline_size", 5)
				label.add_theme_color_override("font_outline_color", Color.BLACK)
				label.add_theme_color_override("font_color", Color.RED)
				label.add_theme_font_size_override("font_size", 45)
				label.add_theme_constant_override("outline", 5)
		label.set_anchors_preset(Control.PRESET_FULL_RECT)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		btn.add_child(label)
		if lv + 1 > unlock_level:
			btn.disabled = true
		var control = Control.new()
		control.add_child(btn)
		$ScrollContainer2/VBoxContainer.get_child(int(lv / col)).add_child(control)
		
func on_btn_pressed(lv):
	
	if load_game("level_data", [1, 0])[0] != lv or load_game("level_data", [1, 0])[1] != load_game("part", 0):
		save("answer_data", [])
	save("level", lv)
	for child in get_tree().get_root().get_children():
		
		if child != AddBee and child != Exit and child != GlobalTime:
			child.queue_free()
	if get_tree().has_group("timer"):
		save("last_time", get_tree().get_nodes_in_group("timer")[0].current_time)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	



func _on_persian_button_pressed():
	$AnimationPlayer.play_backwards("zoom")
	await $AnimationPlayer.animation_finished
	if get_tree().has_group("menu_levels"):
		get_tree().get_nodes_in_group("menu_levels")[0].get_node("AnimationPlayer").play_backwards("zoom")
		get_tree().get_nodes_in_group("menu_levels")[0].zoom = false
		get_tree().get_nodes_in_group("menu_levels")[0].get_node("Camera2D").enabled = true
	queue_free()


func _on_animation_player_2_animation_finished(anim_name):
	$ScrollContainer2.size = $ScrollContainer.size
	$ScrollContainer2.position = $ScrollContainer.position

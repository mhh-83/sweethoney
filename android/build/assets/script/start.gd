extends Control


var level = 1
var max_level = 1
var unlock_level = 1
var save_path = "user://data.cfg"
var part = 0
var teach = true
var guid
@export var gift_score = 30
@export_subgroup("guids")
@export_multiline var guid_league = ""
@export_global_file("*.mp3", "*.wav") var sound_guid_league
@export_multiline var guid_hive = ""
@export_global_file("*.mp3", "*.wav") var sound_guid_hive
@export_multiline var guid_normal_levels = ""
@export_global_file("*.mp3", "*.wav") var sound_guid_normal_levels
@export_multiline var guid_gift = ""
@export_global_file("*.mp3", "*.wav") var sound_guid_gift
@export_multiline var guid_shop = ""
@export_global_file("*.mp3", "*.wav") var sound_guid_shop
var guid_text_list = []
var page = 0
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
	var json = JSON.new()
	var file2 = FileAccess.open("user://time_league/time_league.json", FileAccess.READ)
	var time = json.parse_string(file2.get_as_text())
	file2.close()
	if load_game("begin_league", false):
		$timer.queue_free()
		$timer2.show()
		$timer2.start("close_league", time[2], 0)
	else:
		$timer.start("begin_league", time[0], 0)
	if load_game("close_league", false):
		$timer.queue_free()
		$timer2.queue_free()
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
	var daily_gift_time = load_game2("daily_gift_time", [])
	if daily_gift_time.size() > 0:
		var file = FileAccess.open("user://daily_gift_time/"+ daily_gift_time[0], FileAccess.READ)
		var time2 = JSON.parse_string(file.get_line())
		file.close()
		$gift/timer.start("gift", time2)
	$icons/icons.button_pressed.connect(_on_icons_button_pressed)
func _on_PersianButton_pressed():
	add_child(preload("res://scenes/particles.tscn").instantiate())
	save("last_time_gift", $gift/timer.current_time)
	await get_tree().create_timer(3).timeout
	queue_free()
	get_tree().change_scene_to_file("res://scenes/normal_menu.tscn")






func _on_texture_button_pressed():
	$icons.show()
	



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

func _on_texture_button_2_pressed():
	save("img_mode", 0)
	save("img", "res://sprite/user_img.png")
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/Label.show()
	save("rotate_img", 0)
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.rotation_degrees = load_game("rotate_img", 0)
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.texture = load(load_game("img", "res://sprite/user_img.png"))
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureButton2.hide()
	





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


func _on_PersianButton3_pressed():
	$AnimationPlayer2.play("change_scene")
	save("last_time_gift", $gift/timer.current_time)
	await $AnimationPlayer2.animation_finished
	get_tree().quit()


func _on_turn_texture_pressed():
	save("rotate_img", load_game("rotate_img", 0) + 90)
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.rotation_degrees = load_game("rotate_img", 0)

	
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
		if guid and $PanelQ.scale.x > 1:
			if page < guid_text_list.size() - 1:
				page += 1
				$PanelQ/RichTextLabel.text = "[right]" + guid_text_list[page] + "\n[/right][i][u][b] بزن روی صفحه"
			else:
				$AnimationPlayer.play("close")
				guid = false
			
				
func _on_file_dialog_file_sellected(path):
	save("img_mode", 1)
	save("img", path)
	save("rotate_img", 0)
	var image = Image.load_from_file(load_game("img", "res://sprite/user_img.png"))
	var tex = ImageTexture.create_from_image(image)
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.rotation_degrees = load_game("rotate_img", 0)
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.texture = tex
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/TextureRect2.rotation_degrees = load_game("rotate_img", 0)
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureRect/Label.hide()
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureButton2.show()
	$VBoxContainer/HBoxContainer4/Control/Panel/TextureButton3.show()

func _process(delta):
	if load_game("gift", false):
		if $gift/AnimationPlayer.current_animation != "gift":
			$gift/AnimationPlayer.play("rotate_door")
	if load_game("begin_league"):
		$VBoxContainer/HBoxContainer2/PersianButton2.disabled = false
		$VBoxContainer/HBoxContainer2/PersianButton2/Lock.hide()

	if load_game("close_league"):
		$VBoxContainer/HBoxContainer2/PersianButton2.disabled = true
		$VBoxContainer/HBoxContainer2/PersianButton2/Lock.show()
	if $icons.visible or $PopupPanel.visible:
		$CanvasModulate.show()
	else:
		$CanvasModulate.hide()
func _on_timer_timeout():
	save("gift", true)
	save("last_time_gift", $gift/timer.current_time)



func _on_realisticgoldgiftbox_body_pressed():
	if load_game("gift", false):
		save("gift", false)
		save("last_time_gift", $gift/timer.current_time)
		save("score", load_game("score", 0) + gift_score)
		$VBoxContainer/HBoxContainer4/Control/Panel/Label2.text = "امتیاز : "+ str(load_game("score", 0))
		$gift/Label.text = "+" + str(gift_score)
		$gift/AnimationPlayer.play("gift")
		await $gift/AnimationPlayer.animation_finished
		$gift/AnimationPlayer.play("RESET")


func _on_hives_pressed():
	if !guid:
		add_child(preload("res://scenes/particles.tscn").instantiate())
		save("last_time_gift", $gift/timer.current_time)
		await get_tree().create_timer(3).timeout
		get_node("particles").queue_free()
		var m = preload("res://scenes/hive_scene.tscn").instantiate()
		get_tree().get_root().add_child(m)
	else:
		$AnimationPlayer.play("light_off")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("guid")
		guid_text_list = guid_hive.split("\n")
		page = 0
		$PanelQ/RichTextLabel.text = "[right]" + guid_text_list[page] + "\n[/right][i][u][b] بزن روی صفحه"
func _on_guid_button_pressed():
	guid = true
	$AnimationPlayer.play("light_on")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("effect")


func _on_guid_league_button_pressed():
		$AnimationPlayer.play("light_off")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("guid")
		guid_text_list = guid_league.split("\n")
		page = 0
		$PanelQ/RichTextLabel.text = "[right]" + guid_text_list[page] + "\n[/right][i][u][b] بزن روی صفحه"


func _on_timer_2_timeout():
	save('close_league', true)
	$VBoxContainer/HBoxContainer2/PersianButton2.disabled = true
	$VBoxContainer/HBoxContainer2/PersianButton2/Lock.show()
	$timer2.queue_free()

func _on_gift_button_pressed():
	if guid:
		$AnimationPlayer.play("light_off")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("guid")
		guid_text_list = guid_gift.split("\n")
		page = 0
		$PanelQ/RichTextLabel.text = "[right]" + guid_text_list[page] + "\n[/right][i][u][b] بزن روی صفحه"



func _on_timer_begin_league_timeout():
	save('begin_league', true)
	$timer.queue_free()




func _on_shop_button_pressed():
	if guid:
		$AnimationPlayer.play("light_off")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("guid")
		guid_text_list = guid_shop.split("\n")
		page = 0
		$PanelQ/RichTextLabel.text = "[right]" + guid_text_list[page] + "\n[/right][i][u][b] بزن روی صفحه"
	else:
		$PopupPanel.popup_centered()


func _on_league_button_pressed():
	add_child(preload("res://scenes/particles.tscn").instantiate())
	save("last_time_gift", $gift/timer.current_time)
	await get_tree().create_timer(3).timeout
	queue_free()
	get_tree().change_scene_to_file("res://scenes/league_menu.tscn")

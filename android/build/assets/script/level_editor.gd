extends Control

var words = []
var data = {}
var level = 1
var ques = ""
var text_list = []
var choice_list = []
var match_list = []
var last_data = []
var part = 0
func _ready():
	
	
	
	answer_box($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
	
	data.state = $Panel/VBoxContainer/HBoxContainer/OptionButton.selected
	data.score = $Panel/VBoxContainer/HBoxContainer8/SpinBox.value
	$Panel/VBoxContainer/HBoxContainer2/SpinBox.max_value = max_level()
	$Panel/VBoxContainer/HBoxContainer2/SpinBox.value = max_level()
	data.level = max_level()
	
func update_data():
	show_alert("بارگذاری انجام شد", 1)
	$Panel/VBoxContainer/HBoxContainer8/SpinBox.value = data.score
	ques = data.ques
	$Panel/VBoxContainer/HBoxContainer2/LineEdit.text = data.ques
	if data.state <= 1:
		if $Panel/VBoxContainer/HBoxContainer9/OptionButton.selected == 4:
			%time.value = data.time
		
		$Panel/VBoxContainer/HBoxContainer/OptionButton.select(data.state)
		_on_OptionButton_item_selected($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
		$Panel/VBoxContainer/HBoxContainer5/SpinBox.value = data.answers.size()
		if $Panel/VBoxContainer/HBoxContainer/OptionButton.selected == 1:
			$Panel/VBoxContainer/HBoxContainer6/SpinBox.value = data.data.size()
		answer_box($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
		if get_tree().has_group("answer"):
			for x in range(get_tree().get_nodes_in_group("answer").size()):
				get_tree().get_nodes_in_group("answer")[x].text = data.answers[x]
		words = data.words
		if get_tree().has_group("table"):
			get_tree().get_nodes_in_group("table")[0].update_data(data.data)
			get_tree().get_nodes_in_group("table")[0].words = words
		var t = ""
		for w in words:
			t += w + " "
		$Panel/VBoxContainer/HBoxContainer7/LineEdit.text = t
		_on_line_edit_text_changed(t)
	elif data.state == 2:
		%time.value = data.time
		$Panel/VBoxContainer/HBoxContainer5/SpinBox.value = data.options.size()
		answer_box($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
		if get_tree().has_group("test"):
			for x in range(get_tree().get_nodes_in_group("test").size()):
				get_tree().get_nodes_in_group("test")[x].text = data.options[x]
	elif data.state == 3:
		%time.value = data.time
		$Panel/VBoxContainer/HBoxContainer5/SpinBox.value = data.options.size()
		answer_box($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
		if get_tree().has_group("choice"):
			for x in range(get_tree().get_nodes_in_group("choice").size()):
				get_tree().get_nodes_in_group("choice")[x].text = data.options[x][0]
				get_tree().get_nodes_in_group("choice")[x].get_child(0).button_pressed = data.options[x][1]
	elif data.state == 4:
		match_list = []
		%time.value = data.time
		$Panel/VBoxContainer/HBoxContainer5/SpinBox.value = data.options.size() / 2
		answer_box($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
		if get_tree().has_group("match_option"):
			for x in range(get_tree().get_nodes_in_group("match_option").size()):
				get_tree().get_nodes_in_group("match_option")[x].text = data.options[x]
			match_list = data.answers
			for num in match_list:
				for option in get_tree().get_nodes_in_group("left_col"):
					if num.split("_").size() > 1:
						if option.num == int(num.split("_")[0]):
							option.match_options(int(num.split("_")[1]))
func max_level(count=0) -> int:
	var p = ["home", "village", "school", "mosque", "league"]
	var list = []
	var dir
	if p[count] != "league":
		dir = DirAccess.open("res://files/levels/"+p[count])
	else:
		dir = DirAccess.open("res://files/levels/" + p[count] + "/" + str($Panel/VBoxContainer/HBoxContainer/OptionButton.selected))
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()
		var next = dir.get_next()
		while next != "":
			if !dir.current_is_dir():
				list.append(next)
			next = dir.get_next()
		dir.list_dir_end()
	else:
		if p[count] != "league":
			DirAccess.make_dir_absolute("res://files/levels/" + p[count])
		else:
			DirAccess.make_dir_absolute("res://files/levels/" + p[count] + "/" + str($Panel/VBoxContainer/HBoxContainer/OptionButton.selected))
	return list.size() + 1
func add_words(_name, degross):
	var label = preload("res://scenes/Label.tscn").instantiate()
	var node = Node2D.new()
	if words.size() * 3 < 70:
		label.size2 = 70 -  (words.size() * 3)
	else:
		label.size2 = 2
	label.size = Vector2(.7 * label.size2, label.size2 + 1)
	label.text = _name
	
	label.position = -label.size / 2
	node.add_child(label)
	var pivot = Vector2(0, .8).rotated(deg_to_rad(degross))
	var size = ($Panel/VBoxContainer/HBoxContainer7/Control/TextureRect.size / 2)
	node.position = -(pivot * size)
	$Panel/VBoxContainer/HBoxContainer7/Control/TextureRect/words.add_child(node)
func answer_box(index):
	text_list = []
	choice_list = []
	match_list = []
	last_data = []
	if get_tree().has_group("answer"):
		for answer in get_tree().get_nodes_in_group("answer"):
			text_list.append(answer.text)
	if get_tree().has_group("match_option"):
		for option in get_tree().get_nodes_in_group("left_col"):
			match_list.append(option.sellect_num)
		for option in get_tree().get_nodes_in_group("match_option"):
			text_list.append(option.text)
	if get_tree().has_group("choice"):
		for answer in get_tree().get_nodes_in_group("choice"):
			text_list.append(answer.text)
			choice_list.append(answer.get_child(0).button_pressed)
	if get_tree().has_group("test"):
		for answer in get_tree().get_nodes_in_group("test"):
			text_list.append(answer.text)
	if get_tree().has_group("table"):
		last_data = get_tree().get_nodes_in_group("table")[0].data
	for child in $Panel/VBoxContainer/HBoxContainer3.get_children():
		$Panel/VBoxContainer/HBoxContainer3.remove_child(child)
	match index:
		0:
			var scroll = ScrollContainer.new()
			scroll.size_flags_horizontal = SIZE_EXPAND_FILL
			var grid = GridContainer.new()
			grid.columns = 3
			grid.size_flags_horizontal = SIZE_EXPAND_FILL
			grid.size_flags_vertical = SIZE_EXPAND_FILL
			
			for x in range($Panel/VBoxContainer/HBoxContainer5/SpinBox.value):
				var control = Control.new()
				control.size_flags_horizontal = SIZE_EXPAND_FILL
				control.size_flags_vertical = SIZE_EXPAND_FILL
				var line_edit = preload("res://scenes/LineEdit.tscn").instantiate()
				line_edit.text_changed.connect(answer_box_text_changed.bind(line_edit))
				line_edit.add_to_group("answer")
				line_edit.anchor_left = 0.5
				line_edit.anchor_bottom = 0
				line_edit.anchor_top = 0
				line_edit.anchor_right = 0.5
				control.add_child(line_edit)
				if x <= text_list.size() - 1:
					line_edit.text = text_list[x]
				grid.add_child(control)
			scroll.add_child(grid)
			$Panel/VBoxContainer/HBoxContainer3.add_child(scroll)
		1:
			var table = preload("res://scenes/table.tscn").instantiate()
			table.words = words
			table.col = $Panel/VBoxContainer/HBoxContainer6/SpinBox.value
			table._reload(last_data)
			$Panel/VBoxContainer/HBoxContainer3.add_child(table)
		2:
			var scroll = ScrollContainer.new()
			scroll.size_flags_horizontal = SIZE_EXPAND_FILL
			var grid = GridContainer.new()
			grid.columns = 2
			grid.size_flags_horizontal = SIZE_EXPAND_FILL
			grid.size_flags_vertical = SIZE_EXPAND_FILL
			for x in range($Panel/VBoxContainer/HBoxContainer5/SpinBox.value):
				var control = Control.new()
				control.size_flags_horizontal = SIZE_EXPAND_FILL
				control.size_flags_vertical = SIZE_EXPAND_FILL
				var line_edit = preload("res://scenes/LineEdit2.tscn").instantiate()
				line_edit.text_changed.connect(answer_box_text_changed.bind(line_edit))
				line_edit.add_to_group("test")
				line_edit.anchor_left = 0.5
				line_edit.anchor_bottom = 0
				line_edit.anchor_top = 0
				line_edit.anchor_right = 0.5
				control.add_child(line_edit)
				if x <= text_list.size() - 1:
					line_edit.text = text_list[x]
				grid.add_child(control)
			scroll.add_child(grid)
			$Panel/VBoxContainer/HBoxContainer3.add_child(scroll)
		3:
			var scroll = ScrollContainer.new()
			scroll.size_flags_horizontal = SIZE_EXPAND_FILL
			var grid = GridContainer.new()
			grid.columns = 3
			grid.size_flags_horizontal = SIZE_EXPAND_FILL
			grid.size_flags_vertical = SIZE_EXPAND_FILL
			
			for x in range($Panel/VBoxContainer/HBoxContainer5/SpinBox.value):
				var control = Control.new()
				control.size_flags_horizontal = SIZE_EXPAND_FILL
				control.size_flags_vertical = SIZE_EXPAND_FILL
				var line_edit = preload("res://scenes/line_edit3.tscn").instantiate()
				line_edit.text_changed.connect(answer_box_text_changed.bind(line_edit))
				line_edit.add_to_group("choice")
				line_edit.anchor_left = 0.5
				line_edit.anchor_bottom = 0
				line_edit.anchor_top = 0
				line_edit.anchor_right = 0.5
				control.add_child(line_edit)
				if x <= text_list.size() - 1 and x <= choice_list.size() - 1:
					line_edit.text = text_list[x]
					line_edit.get_child(0).button_pressed = choice_list[x]
				grid.add_child(control)
			scroll.add_child(grid)
			$Panel/VBoxContainer/HBoxContainer3.add_child(scroll)
		4:
			var scroll = ScrollContainer.new()
			scroll.size_flags_horizontal = SIZE_EXPAND_FILL
			var vbox = VBoxContainer.new()
			vbox.size_flags_horizontal = SIZE_EXPAND_FILL
			vbox.add_theme_constant_override("separation", 50)
			for x in range($Panel/VBoxContainer/HBoxContainer5/SpinBox.value):
				var hbox = HBoxContainer.new()
				hbox.add_theme_constant_override("separation", 200)
				var line_edit = preload("res://scenes/match_option.tscn").instantiate()
				line_edit.num = x
				line_edit.dir = 1
				line_edit.text_changed.connect(answer_box_text_changed.bind(line_edit))
				line_edit.add_to_group("left_col")
				var line_edit2 = preload("res://scenes/match_option.tscn").instantiate()
				line_edit2.num = x
				line_edit2.dir = -1
				line_edit2.add_to_group("right_col")
				line_edit2.text_changed.connect(answer_box_text_changed.bind(line_edit2))
				if x * 2 <= text_list.size() - 2:
					line_edit.text = text_list[x * 2]
					line_edit2.text = text_list[(x * 2) + 1]
				hbox.add_child(line_edit)
				hbox.add_child(line_edit2)
				vbox.add_child(hbox)
			scroll.add_child(vbox)
			$Panel/VBoxContainer/HBoxContainer3.add_child(scroll)

			for num in match_list:
				for option in get_tree().get_nodes_in_group("left_col"):
					if num.split("_").size() > 1:
						if option.num == int(num.split("_")[0]):
							option.match_options(int(num.split("_")[1]))

func _on_OptionButton_item_selected(index):
	data.state = index
	if part == 4:
		$Panel/VBoxContainer/HBoxContainer2/SpinBox.value = max_level(part)
		$Panel/VBoxContainer/HBoxContainer2/SpinBox.max_value = max_level(part)
	$Panel/VBoxContainer/HBoxContainer7.show()
	match index:
		0:
			$Panel/VBoxContainer/HBoxContainer6.hide()
			$Panel/VBoxContainer/HBoxContainer5.show()
			$Panel/VBoxContainer/HBoxContainer10.hide()
		1:
			$Panel/VBoxContainer/HBoxContainer5.hide()
			$Panel/VBoxContainer/HBoxContainer6.show()
			$Panel/VBoxContainer/HBoxContainer10.hide()
			
		2:
			$Panel/VBoxContainer/HBoxContainer10.show()
			$Panel/VBoxContainer/HBoxContainer6.hide()
			$Panel/VBoxContainer/HBoxContainer5.show()
			$Panel/VBoxContainer/HBoxContainer7.hide()
		3:
			$Panel/VBoxContainer/HBoxContainer6.hide()
			$Panel/VBoxContainer/HBoxContainer5.show()
			$Panel/VBoxContainer/HBoxContainer7.hide()
			$Panel/VBoxContainer/HBoxContainer10.hide()
		4:
			$Panel/VBoxContainer/HBoxContainer6.hide()
			$Panel/VBoxContainer/HBoxContainer5.show()
			$Panel/VBoxContainer/HBoxContainer7.hide()
			$Panel/VBoxContainer/HBoxContainer10.hide()
	answer_box($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
func _on_SpinBox_changed(value):
	answer_box($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
	$Panel/VBoxContainer/HBoxContainer10/SpinBox.max_value = value


func comb(n:int):
	var k = 1
	for x in range(n):
		k *= (n - x)
	return k
func show_alert(_text, state):
	if state == 0:
		var anime = $AnimationPlayer.get_animation("erore")
		anime.track_insert_key(2, 3, _text)
		$AnimationPlayer.play("erore", 0, 2)
	if state == 1:
		var anime = $AnimationPlayer.get_animation("successfully")
		anime.track_insert_key(2, 3, _text)
		$AnimationPlayer.play("successfully", 0, 2)
func _on_button_pressed():
	var list = []
	if words.size() < 10:
		for x in range(comb(words.size())):
			var l = []
			for w in words:
				l.append(w)
			var t = ""
			
			for y in range(words.size()):
				t += l[int(x / (comb(l.size()) / l.size())) % l.size()]
				l.remove_at(int(x / (comb(l.size()) / l.size())) % l.size())
			list.append(t)
	var all_answer_true = true
	var empty_box = false
	var empty_option = false
	if get_tree().has_group("answer"):
		var answers = []
		for answer in get_tree().get_nodes_in_group("answer"):
			var has_text = false
			if list.size() > 0:
				for w in list:
					if !w.find(answer.text):
						has_text = true
			else:
				has_text = true
					
			if answer.text != "" and answer.text.split(" ").size() == 1:
				if has_text or list.has(answer.text):
					answers.append(answer.text)
					answer.add_theme_stylebox_override("normal", preload("res://styles/LineEdit_s.tres"))
				else:
					all_answer_true = false
					answer.add_theme_stylebox_override("normal", preload("res://styles/LineEdit_e.tres"))
			else:
				all_answer_true = false
				answer.add_theme_stylebox_override("normal", preload("res://styles/LineEdit_e.tres"))
				
		data.answers = answers
	
	elif get_tree().has_group("table"):
		var table = get_tree().get_nodes_in_group("table")[0]
		data.answers = table.answers()
		data.data = table.data
		var boxs = []
		if get_tree().has_group("box"):
			boxs = get_tree().get_nodes_in_group("box")
		if boxs.size() == 0:
			empty_box = true
		for x in range(boxs.size()):
			if boxs[x].text == "" or boxs[x].text == " ":
				boxs[x].add_theme_stylebox_override("normal", preload("res://styles/LineEdit2_e.tres"))
				empty_box = true
	elif get_tree().has_group("test"):
		data.correct_answer = $Panel/VBoxContainer/HBoxContainer10/SpinBox.value
		var options = []
		for option in get_tree().get_nodes_in_group("test"):
			var r = false
			for t in option.text.split(" "):
				if t != "":
					r = true
			if r:
				options.append(option.text)
			else:
				option.add_theme_stylebox_override("normal", preload("res://styles/LineEdit_e.tres"))
				empty_option = true
		data.options = options
	elif get_tree().has_group("choice"):
		var options = []
		for option in get_tree().get_nodes_in_group("choice"):
			var r = false
			for t in option.text.split(" "):
				if t != "":
					r = true
			if r:
				options.append([option.text, option.get_child(0).button_pressed])
			else:
				option.add_theme_stylebox_override("normal", preload("res://styles/LineEdit_e.tres"))
		data.options = options
	elif get_tree().has_group("match_option"):
		var options = []
		var answers = []
		for option in get_tree().get_nodes_in_group("left_col"):
			answers.append(option.sellect_num)
		for option in get_tree().get_nodes_in_group("match_option"):
			var r = false
			for t in option.text.split(" "):
				if t != "":
					r = true
			if r:
				options.append(option.text)
			else:
				option.add_theme_stylebox_override("normal", preload("res://styles/LineEdit_e.tres"))
				empty_option = true
		data.options = options
		data.answers = answers
	if $Panel/VBoxContainer/HBoxContainer/OptionButton.selected <= 1:
		if data.answers.size() > 0 and words.size() > 1 and !empty_box:
			data.words = words
			data.ques = ques
			data.state = $Panel/VBoxContainer/HBoxContainer/OptionButton.selected
			var p = ["home", "village", "school", "mosque", "league"]
			
			var file
			if p[part] != "league":
				var json = JSON.stringify(data)
				file = FileAccess.open("res://files/levels/"+p[part]+"/level_"+ str(level)+".json", FileAccess.WRITE)
				file.store_line(json)
			else:
				data.time = %time.value
				var json = JSON.stringify(data)
				file = FileAccess.open("res://files/levels/" + p[part] + "/" + str(data.state) + "/level_"+ str(level)+".json", FileAccess.WRITE)
				file.store_line(json)
			file.close()
			$Panel/VBoxContainer/HBoxContainer2/SpinBox.value = max_level(part)
			$Panel/VBoxContainer/HBoxContainer2/SpinBox.max_value = max_level(part)
			if all_answer_true:
				show_alert("با موفقیت ذخیره شد", 1)
			else:
				show_alert("فقط موارد سبز رنگ ذخیره شدند", 1)
		else:
			if words.size() < 2:
				show_alert("تعداد حروف باید بیشتر از دو باشد", 0)
			elif data.answers.size() < 1:
				show_alert("حداقل یک جواب درست بنویسید", 0)
			elif empty_box:
				show_alert("جعبه های خالی را پر کنید", 0)
	elif $Panel/VBoxContainer/HBoxContainer/OptionButton.selected == 2: 
		if $Panel/VBoxContainer/HBoxContainer5/SpinBox.value >= 2 and !empty_option:
			data.ques = ques
			data.time = %time.value
			data.state = $Panel/VBoxContainer/HBoxContainer/OptionButton.selected
			var json = JSON.stringify(data)
			var file = FileAccess.open("res://files/levels/league/2/level_"+ str(level)+".json", FileAccess.WRITE)
			file.store_line(json)
			file.close()
			$Panel/VBoxContainer/HBoxContainer2/SpinBox.value = max_level(4)
			$Panel/VBoxContainer/HBoxContainer2/SpinBox.max_value = max_level(4)
			get_tree().get_nodes_in_group("test")[data.correct_answer - 1].add_theme_stylebox_override("normal", preload("res://styles/LineEdit_s.tres"))
			show_alert("با موفقیت ذخیره شد", 1)
		else:
			if empty_option:
				show_alert("گزینه های خالی را پر کنید", 0)
			else:
				show_alert("حداقل دو گزینه بنویسید", 0)
	elif $Panel/VBoxContainer/HBoxContainer/OptionButton.selected == 3: 
		if data.options.size() > 1:
			data.time = %time.value
			data.ques = ques
			data.state = $Panel/VBoxContainer/HBoxContainer/OptionButton.selected
			var json = JSON.stringify(data)
			var file = FileAccess.open("res://files/levels/league/3/level_"+ str(level)+".json", FileAccess.WRITE)
			file.store_line(json)
			file.close()
			$Panel/VBoxContainer/HBoxContainer2/SpinBox.value = max_level(4)
			$Panel/VBoxContainer/HBoxContainer2/SpinBox.max_value = max_level(4)
			show_alert("با موفقیت ذخیره شد", 1)
		else:
			show_alert("حداقل دو گزینه بنویسید", 0)
	elif $Panel/VBoxContainer/HBoxContainer/OptionButton.selected == 4:
		var a = 0
		for answer in data.answers:
			if answer != "":
				a += 1
		if $Panel/VBoxContainer/HBoxContainer5/SpinBox.value >= 2 and !empty_option and a > 0:
			data.ques = ques
			data.time = %time.value
			data.state = $Panel/VBoxContainer/HBoxContainer/OptionButton.selected
			var json = JSON.stringify(data)
			var file = FileAccess.open("res://files/levels/league/4/level_"+ str(level)+".json", FileAccess.WRITE)
			file.store_line(json)
			file.close()
			$Panel/VBoxContainer/HBoxContainer2/SpinBox.value = max_level(4)
			$Panel/VBoxContainer/HBoxContainer2/SpinBox.max_value = max_level(4)
			show_alert("با موفقیت ذخیره شد", 1)
		else:
			if empty_option:
				show_alert("گزینه های خالی را پر کنید", 0)
			elif a == 0:
				show_alert("حداقل یک مورد را به هم وصل کنید", 0)
			else:
				show_alert("حداقل دو گزینه بنویسید", 0)
func _on_button_2_pressed():
	for answer in get_tree().get_nodes_in_group("answer"):
		answer.text = ""
	for answer in get_tree().get_nodes_in_group("test"):
		answer.text = ""
	for option in get_tree().get_nodes_in_group("choice"):
		option.text = ""
		option.get_child(0).button_pressed = false
	for option in get_tree().get_nodes_in_group("match_option"):
		option.text = ""
		option.get_child(0).points = []
		if option.target:
			option.target.get_child(0).points = []
			option.target.sellect_num = ""
			option.sellect_num = ""
			option.target.target = null
			option.target = null
	if get_tree().has_group("table"):
		get_tree().get_nodes_in_group("table")[0]._reload()
	answer_box($Panel/VBoxContainer/HBoxContainer/OptionButton.selected)
	$Panel/VBoxContainer/HBoxContainer7/LineEdit.text = ""
	$Panel/VBoxContainer/HBoxContainer2/LineEdit.text = ""
	for child in $Panel/VBoxContainer/HBoxContainer7/Control/TextureRect/words.get_children():
		$Panel/VBoxContainer/HBoxContainer7/Control/TextureRect/words.remove_child(child)
	words = []
	


func _on_button_3_pressed():
	var p = ["home", "village", "school", "mosque", "league"]
	if p[part] != "league":
		if FileAccess.file_exists("res://files/levels/"+p[part]+"/level_"+str(level)+".json"):
			var file = FileAccess.open("res://files/levels/"+p[part]+"/level_"+ str(level)+".json", FileAccess.READ)
			data = JSON.parse_string(file.get_line())
			update_data()
		else:
			show_alert("فایل وجود ندارد", 0)
	else:
		if FileAccess.file_exists("res://files/levels/" + p[part] + "/" + str($Panel/VBoxContainer/HBoxContainer/OptionButton.selected) + "/level_"+ str(level)+".json"):
			var file = FileAccess.open("res://files/levels/" + p[part] + "/" + str($Panel/VBoxContainer/HBoxContainer/OptionButton.selected) + "/level_"+ str(level)+".json", FileAccess.READ)
			data = JSON.parse_string(file.get_line())
			update_data()
		else:
			show_alert("فایل وجود ندارد", 0)
		
	
	

func _on_question_text_changed():
	ques = $Panel/VBoxContainer/HBoxContainer2/LineEdit.text


func _on_button_4_pressed():
	get_tree().quit()


func _on_line_edit_text_changed(new_text):
	
	var list = new_text.split(" ")
	for child in $Panel/VBoxContainer/HBoxContainer7/Control/TextureRect/words.get_children():
		$Panel/VBoxContainer/HBoxContainer7/Control/TextureRect/words.remove_child(child)
	words = []
	for t in list:
		if t != "" and t != " ":
			words.append(t)
	for x in range(words.size()):
		add_words(words[x], (360 / words.size()) * x)
	data.words = words
	if get_tree().has_group("table"):
		get_tree().get_nodes_in_group("table")[0].words = words


func answer_box_text_changed(t, answer):
	answer.add_theme_stylebox_override("normal", preload("res://styles/LineEdit_n.tres"))


func _on_spin_box_value_changed(value):
	data.level = value
	level = value


func _on_Score_changed(value):
	data.score = value


func _on_part_item_selected(index):
	part = index
	if part == 4:
		%time.show()
		$Panel/VBoxContainer/HBoxContainer9/Label2.show()
		$Panel/VBoxContainer/HBoxContainer/OptionButton.set_item_disabled(2, false)
		$Panel/VBoxContainer/HBoxContainer/OptionButton.set_item_disabled(3, false)
		$Panel/VBoxContainer/HBoxContainer/OptionButton.set_item_disabled(4, false)
	else:
		%time.hide()
		$Panel/VBoxContainer/HBoxContainer9/Label2.hide()
		$Panel/VBoxContainer/HBoxContainer/OptionButton.select(0)
		_on_OptionButton_item_selected(0)
		$Panel/VBoxContainer/HBoxContainer/OptionButton.set_item_disabled(2, true)
		$Panel/VBoxContainer/HBoxContainer/OptionButton.set_item_disabled(3, true)
		$Panel/VBoxContainer/HBoxContainer/OptionButton.set_item_disabled(4, true)
	$Panel/VBoxContainer/HBoxContainer2/SpinBox.max_value = max_level(index)
	$Panel/VBoxContainer/HBoxContainer2/SpinBox.value = max_level(index)


func correct_answer(value):
	data.correct_answer = value



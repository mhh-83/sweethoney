extends Control
var target_word = []
var word
var text = ""
var true_answer = false
var answered = false
var drag = true
var level = 1
var unlock_level = 1
var data = {}
var words = []
var rotate_words = false
var back_rotate_words = false
var stop_rotate_words = false
var speed_rotate = 0
var save_path = "user://data.cfg"
var w_answer_list = []
var table_box = []
var score = 0
var part = 0
var collide = false
var table_word_r = []
var table_word_c = []
var menu_open = false
var max_level = 1
var ques_menu = false
var speed = 0
var back_speed = 0
var end_game = true
func update_score(num=0):
	score += num
	save("score", score)
	$VBoxContainer/Control/Label.text = str(score)
func find_word(box):
	box.get_child(0).emitting = true
func help(state, _score):
	randomize()
	if score >= _score:
		update_score(-_score)
		if state == 0:
			
			var words2 = []
			if data.state == 0:
				for x in range(data.answers.size()):
					for y in range(data.answers[x].length()):
						words2.append(Vector2(x, y))
						for a in w_answer_list:
							if x == a.x and y == a.y:
								words2.erase(Vector2(x, y))
				if words2.size() > 0:
					var z = randi_range(0, words2.size() - 1)
					var x = words2[z].x
					var y = words2[z].y
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					hbox.get_child(y).get_child(0).text = data.answers[x][data.answers[x].length() - 1 - y]
					find_word(hbox.get_child(y).get_child(0))
					w_answer_list.append(Vector2(x, y))
				
			if data.state == 1:
				for box in table_box:
					words2.append(box)
					if get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0].text != "":
						words2.erase(box)
				if words2.size() > 0:
					var z = randi_range(0, len(words2) - 1)
					var x = words2[z].x
					var y = words2[z].y
					var box = get_tree().get_nodes_in_group("answer_"+str(x)+"_"+str(y))[0]
					box.text = data.data[x][y]
					find_word(box)
			if words2.size() == 1:
				$satan/AnimationPlayer.play("fall")
				$bee/AnimationTree.active = false
				$bee/AnimatedSprite2D.play("default")
				$bee/AnimationPlayer.play("true_answer")
				await get_tree().create_timer(1.5).timeout
				end()
		if state == 1:
			true_answer_animation()
			var words_list = []
			var words_r_list = []
			var words_c_list = []
			if data.state == 0:
				for x in range(data.answers.size()):
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					words_list.append(x)
					var a = true
					for box in hbox.get_children():
						if box.get_child(0).text == "":
							a = false
					if a:
						words_list.erase(x)
				if words_list.size() > 0:
					var z = randi_range(0, len(words_list) - 1)
					var x = words_list[z]
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					for y in range(hbox.get_children().size()):
						hbox.get_child(y).get_child(0).text = data.answers[x][data.answers[x].length() - 1 - y]
						find_word(hbox.get_child(y).get_child(0))
						w_answer_list.append(Vector2(x, y))
			if data.state == 1:
				
				for x in range(data.answers[0].size()):
					var boxs = get_tree().get_nodes_in_group("answer_r_"+str(x))
					var a = false
					words_r_list.append(x)
					for box in boxs:
						if box.text == "":
							a = true
					if !a:
						words_r_list.erase(x)
				for x in range(data.answers[1].size()):
					var boxs = get_tree().get_nodes_in_group("answer_c_"+str(x))
					words_c_list.append(x)
					var a = false
					for box in boxs:
						if box.text == "":
							a = true
					if !a:
						words_c_list.erase(x)
				if words_c_list.size() > 0 and words_r_list.size() > 0:
					var r = randi_range(0, 1)
					if r == 0:
						var z = randi_range(0, len(words_r_list) - 1)
						var x = words_r_list[z]
						var boxs = get_tree().get_nodes_in_group("answer_r_"+str(x))
						for y in range(boxs.size()):
							boxs[y].text = data.answers[0][data.answers[0].size() - x - 1][data.answers[0][data.answers[0].size() - x - 1].length() - y - 1]
							find_word(boxs[y])
							w_answer_list.append(Vector2(x, y))
					if r == 1:
						var z = randi_range(0, len(words_c_list) - 1)
						var x = words_c_list[z]
						var boxs = get_tree().get_nodes_in_group("answer_c_"+str(x))
						for y in range(boxs.size()):
							boxs[y].text = data.answers[1][x][y]
							find_word(boxs[y])
							w_answer_list.append(Vector2(x, y))
				elif words_c_list.size() > 0 and words_r_list.size() == 0:
					var z = randi_range(0, len(words_c_list) - 1)
					var x = words_c_list[z]
					var boxs = get_tree().get_nodes_in_group("answer_c_"+str(x))
					for y in range(boxs.size()):
						boxs[y].text = data.answers[1][x][y]
						find_word(boxs[y])
						w_answer_list.append(Vector2(x, y))
				elif words_r_list.size() > 0 and words_c_list.size() == 0:
					var z = randi_range(0, len(words_r_list) - 1)
					var x = words_r_list[z]
					var boxs = get_tree().get_nodes_in_group("answer_r_"+str(x))
					for y in range(boxs.size()):
						boxs[y].text = data.answers[0][data.answers[0].size() - x - 1][data.answers[0][data.answers[0].size() - x - 1].length() - y - 1]
						find_word(boxs[y])
						w_answer_list.append(Vector2(x, y))
			if words_list.size() == 1:
				$satan/AnimationPlayer.play("fall")
				$bee/AnimatedSprite2D.play("default")
				$bee/AnimationPlayer.play("true_answer")
				await get_tree().create_timer(1.5).timeout
				end()
			if (words_c_list.size() == 0 and words_r_list.size() == 1) or (words_c_list.size() == 1 and words_r_list.size() == 0):
				$satan/AnimationPlayer.play("fall")
				$bee/AnimatedSprite2D.play("default")
				$bee/AnimationPlayer.play("true_answer")
				await get_tree().create_timer(1.5).timeout
				end()
		if state == 2:
			true_answer_animation()
			if data.state == 0:
				for x in range(data.answers.size()):
					var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
					for y in range(hbox.get_children().size()):
						find_word(hbox.get_child(y).get_child(0))
						hbox.get_child(y).get_child(0).text = data.answers[x][data.answers[x].length() - 1 - y]
			if data.state == 1:
				for box in table_box:
					get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0].text = data.data[box.x][box.y]
					find_word(get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0])
			$satan/AnimationPlayer.play("fall")
			$bee/AnimatedSprite2D.play("default")
			$bee/AnimationPlayer.play("true_answer")
			await get_tree().create_timer(2).timeout
			end()
		
	else:
		$AnimationPlayer.play("score")
	
	

func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func load_game(_name, defaulte = null):
	var confige = ConfigFile.new()
	confige.load(save_path)
	return confige.get_value("user", _name, defaulte)
func load_game2(_name, defaulte = null):
	var confige = ConfigFile.new()
	confige.load("user://files.cfg")
	return confige.get_value("user", _name, defaulte)
func _ready():
	$bee/AnimationPlayer.get_animation("true_answer").set_loop_mode(1)

	
	var tex = load("res://sprite/user_img.png")
	if load_game("img", "") != "":
		var image= Image.load_from_file("user://icons/"+load_game("img"))
		tex = ImageTexture.create_from_image(image)
	$CanvasLayer/Panel/VBoxContainer/Control/TextureRect/TextureRect.texture = tex
	
	score = load_game("score", 0)
	level = load_game("league_level", 1)
	update_score()
	save("part_league", 3)
	part = load_game("part_league", 2)
	$CanvasLayer/Panel/VBoxContainer/Control/Label.text = load_game("name", "")
	var file2 = FileAccess.open("user://levels_league_"+ str(part + 1) + "/" + str(load_game2("random_level"+str(part), ["level_1.json"])[level]), FileAccess.READ)
	data = JSON.parse_string(file2.get_line())
	file2.close()
	match part:
		0:
			$AnimationPlayer3.play("state1")
		1:
			$AnimationPlayer3.play("state1")
		2:
			$AnimationPlayer3.play("state2")
			$AnimationPlayer2.play("question")
		3:
			$AnimationPlayer3.play("state4")
			$AnimationPlayer2.play("question")
		4:
			$AnimationPlayer3.play("state3")
			$AnimationPlayer2.play("question")
	
	speed = ($satan.global_position.x - ($bee.global_position.x - 125)) / data.time
	$VBoxContainer/Control/Label2.text = "مرحلـه " + str(level)
	$TextureRect3/Line2D.position = -$TextureRect3.global_position
	
	if data.state == 0:
		for x in range(data.answers.size()):
			add_answer(data.answers[x].length(), x)
	elif data.state >= 1:
		add_answer(1, 0)
	if data.state <= 1:
		for x in range(data.words.size()):
			add_words(data.words[x], (360 / data.words.size()) * x)
		words = data.words
		if words.size() < 20:
			$TextureRect3/Line2D.width = 30 - words.size()
		else:
			$TextureRect3/Line2D.width = 2
	var quess = data.ques.split("؟")
	
	for x in range(quess.size()-1):
		$Node2D/Panel/PersianLabel.text += str(x+1) + "_" + quess[x] + "؟" + "\n"


func add_words(_name, degross):
	var label = preload("res://scenes/Label.tscn").instantiate()
	var node = Node2D.new()
	label.size2 = 80 -  (words.size() * 2)
	label.size = Vector2(.7 * label.size2, label.size2 + 1)
	label.text = _name
	
	label.mouse_hover.connect(_on_Label_mouse_hover)
	label.mouse_exit.connect(_on_Label_mouse_exit)
	label.position = -label.size / 2
	node.add_child(label)
	
	var pivot = Vector2(0, .64).rotated(deg_to_rad(degross))
	var size2 = ($TextureRect3.size / 2)
	node.position = -(pivot * size2)

	$TextureRect3/words.add_child(node)
func add_answer(num, count):
	var l = []
	var q = []
	if data.state == 0:
		$VBoxContainer/ScrollContainer/GridBoxContainer.columns = 1
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("h_separation", 180)
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("v_separation", 90)
		var hbox = HBoxContainer.new()
		for x in range(num):
			var c = Control.new()
			var box = preload("res://scenes/box_word.tscn").instantiate()
			c.add_child(box)
			hbox.add_child(c)
		hbox.add_theme_constant_override("separation", 80)
		hbox.add_to_group("answer"+str(count))
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_child(hbox)
		if count == data.answers.size() - 1:
			$VBoxContainer/ScrollContainer/GridBoxContainer.add_child(Control.new())
	elif data.state == 1:
		$VBoxContainer/ScrollContainer/GridBoxContainer.layout_direction = LAYOUT_DIRECTION_LTR
		$VBoxContainer/ScrollContainer.layout_direction = LAYOUT_DIRECTION_LTR
		$VBoxContainer/ScrollContainer/GridBoxContainer.columns = data.data.size() + 1
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("v_separation" , 80)
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("h_separation" , 80)
		for x in range(data.data.size()):
			for y in range(data.data[x].size()):
				var control = Control.new()
				var box = preload("res://scenes/box_word.tscn").instantiate()
				for c in range(data.answers[2].size()):
					if x == 0 and y == 0 and "_00_" in data.answers[2][c]:
						box.add_to_group("answer_c_"+str(c))
						l.append([Vector2(x, y), c])
					elif ("_" + str(y + (x * data.data[x].size())) + "_") in data.answers[2][c]:
						l.append([Vector2(x, y), c])
						box.add_to_group("answer_c_"+str(c))
				for r in range(data.answers[3].size()):
					if x == 0 and y == 0 and "_00_" in data.answers[3][r]:
						box.add_to_group("answer_r_"+str(r))
						q.append([Vector2(x, y), r])
					elif ("_" + str(y + (x * data.data[x].size())) + "_") in data.answers[3][r]:
						box.add_to_group("answer_r_"+str(r))
						q.append([Vector2(x, y), r])
				if data.data[x][y] != " ":
					control.add_child(box)
					table_box.append(Vector2(x, y))
					box.add_to_group("answer_"+str(x)+"_"+str(y))
				$VBoxContainer/ScrollContainer/GridBoxContainer.add_child(control)
				if y == data.data[x].size() - 1:
					$VBoxContainer/ScrollContainer/GridBoxContainer.add_child(Control.new())
		for y in range(data.answers[3].size()):
			var z = []
			for x in range(q.size()):
				if q[x][1] == y:
					z.append(q[x][0])
			table_word_r.append(z)
		for y in range(data.answers[2].size()):
			var z = []
			for x in range(l.size()):
				if l[x][1] == y:
					z.append(l[x][0])
			table_word_c.append(z)
	elif data.state == 2:
		$VBoxContainer/ScrollContainer/GridBoxContainer.layout_direction = LAYOUT_DIRECTION_LTR
		$VBoxContainer/ScrollContainer.layout_direction = LAYOUT_DIRECTION_LTR
		$VBoxContainer/ScrollContainer/GridBoxContainer.columns = 2
		$VBoxContainer/ScrollContainer.clip_contents = false
		$VBoxContainer/ScrollContainer/GridBoxContainer.size_flags_horizontal = SIZE_EXPAND_FILL
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("v_separation" , 80)
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("h_separation" , 80)
		for x in range(data.options.size()):
			var option = preload("res://scenes/option.tscn").instantiate()
			option.set("metadata/num", x)
			option.pressed.connect(test_button.bind(option.get("metadata/num")))
			option.text = data.options[x]
			$VBoxContainer/ScrollContainer/GridBoxContainer.add_child(option)
			
	elif data.state == 3:
		
		for x in range(data.options.size()):
			var option = preload("res://scenes/choice_option.tscn").instantiate()
			option.get_node("Label").text = data.options[x][0]
			option.correct = data.options[x][1]
			option.position = Vector2(0, 1).rotated(deg_to_rad(x * (360 / data.options.size()))) * 250
			$options.add_child(option)
	elif data.state == 4:
		$VBoxContainer/ScrollContainer/GridBoxContainer.layout_direction = LAYOUT_DIRECTION_LTR
		$VBoxContainer/ScrollContainer/GridBoxContainer.size_flags_vertical = SIZE_EXPAND_FILL
		$VBoxContainer/ScrollContainer.layout_direction = LAYOUT_DIRECTION_LTR
		$VBoxContainer/ScrollContainer/GridBoxContainer.columns = 1
		$VBoxContainer/ScrollContainer.clip_contents = false
		$VBoxContainer/ScrollContainer/GridBoxContainer.size_flags_horizontal = SIZE_EXPAND_FILL
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("v_separation" , 80)
		$VBoxContainer/ScrollContainer/GridBoxContainer.add_theme_constant_override("h_separation" , 20)
		for x in range(data.options.size() / 2):
			var hbox = HBoxContainer.new()
		
			hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			var option = preload("res://scenes/match_option2.tscn").instantiate()
			option.text = data.options[x * 2]
			option.dir = 1
			option.num = x
			option.add_to_group("left_col")
			var option2 = preload("res://scenes/match_option2.tscn").instantiate()
			option2.text = data.options[(x * 2) + 1]
			option2.dir = -1
			option2.num = x
			option2.add_to_group("right_col")
			hbox.add_theme_constant_override("separation", 200)
			hbox.add_child(option)
			hbox.add_child(option2)
			$VBoxContainer/ScrollContainer/GridBoxContainer.add_child(hbox)
		
		for option in get_tree().get_nodes_in_group("match_option"):
			option.start()
		
			
func test_button(_num):
	speed = 0
	
	for option in get_tree().get_nodes_in_group("options"):
		option.disabled = true
	if _num == data.correct_answer -1:
		$satan/AnimationPlayer.play("fall")
		$bee/AnimatedSprite2D.play("default")
		$bee/AnimationPlayer.play("true_answer")
		get_tree().get_nodes_in_group("options")[_num].add_theme_stylebox_override("disabled", preload("res://styles/test_btn_t.tres"))
	else:
		data.score = 0
		get_tree().get_nodes_in_group("options")[_num].add_theme_stylebox_override("disabled", preload("res://styles/test_btn_f.tres"))
		get_tree().get_nodes_in_group("options")[data.correct_answer - 1].add_theme_stylebox_override("disabled", preload("res://styles/test_btn_t.tres"))
		$satan/AnimationPlayer.play("shot")
		await $satan/AnimationPlayer.animation_finished
		$satan/AnimationPlayer.play("happing")
	
	await get_tree().create_timer(2).timeout
	end()
func end():
	await get_tree().create_timer(2)
func change_words_pos():
	var list = []
	var words2 = data.words
	randomize()
	for y in range(words2.size()):
		var x = randi_range(0, words2.size() - 1)
		list.append(words2[x])
		words2.remove_at(x)
	data.words = list
	for child in $TextureRect3/words.get_children():
		child.queue_free()
	for x in range(data.words.size()):
		add_words(data.words[x], (360 / data.words.size()) * x)
var a = 1 
func _process(delta):
	$satan.position.x -= speed * delta
	if get_tree().has_group("choice_option"):
		var _end_game = true
		for option in get_tree().get_nodes_in_group("choice_option"):
			if !option.sellected:
				if option.correct:
					_end_game = false
		if end_game and _end_game:
			speed = 0
			var _score = 0
			var options = get_tree().get_nodes_in_group("choice_option")
			for x in range(options.size()):
				options[x].get_node("Label").mouse_filter = MOUSE_FILTER_IGNORE
				if !options[x].sellected:
					options[x].get_node("Label").add_theme_stylebox_override("normal", preload("res://styles/choice_option_f.tres"))
				else:
					if options[x].correct:
						_score += data.score
					else:
						_score -= data.score
			if _score > 0:
				if $satan/AnimationPlayer.current_animation != "fall":
					$satan/AnimationPlayer.play("fall")
					$bee/AnimatedSprite2D.play("default")
					$bee/AnimationPlayer.play("true_answer")
			else:
				$satan/AnimationPlayer.play("shot")
				await $satan/AnimationPlayer.animation_finished
				$satan/AnimationPlayer.play("happing")
			end_game = false
			
			print(_score)
			
	if $satan/body/polygons/spear2.visible:
		var spear = $satan/body/polygons/spear2
		var velocity = (-$satan.global_position + $bee.global_position).normalized()
		spear.rotation = Vector2(1, 0).rotated(velocity.angle()).angle()
		if collide:
			a -= 2 * delta
			if spear.modulate.a > 0:
				spear.modulate = Color(1, 1, 1, a)
			else:
				spear.visible = false
		else:
			spear.position += velocity * 3000 * delta
	if rotate_words:
		speed_rotate += 10 * delta
		$TextureRect3/words.rotate(deg_to_rad(speed_rotate))
		if speed_rotate >= 10:
			back_rotate_words = true
			rotate_words = false
			change_words_pos()
	if back_rotate_words:
		speed_rotate -= 10 * delta
		$TextureRect3/words.rotate(deg_to_rad(speed_rotate))
		if speed_rotate <= 1:
			speed_rotate = 0
			if $TextureRect3/words.rotation != 0:
				stop_rotate_words = true
			back_rotate_words = false
	if stop_rotate_words:
		
		if int(rad_to_deg($TextureRect3/words.rotation)) % 360 != 0:
			if int(rad_to_deg($TextureRect3/words.rotation)) % 360 != 180:
				$TextureRect3/words.rotate(deg_to_rad(-(180 - (int(rad_to_deg($TextureRect3/words.rotation)) % 360)) / abs(180 - (int(rad_to_deg($TextureRect3/words.rotation)) % 360))))
			else:
				$TextureRect3/words.rotate(deg_to_rad(1))
		else:
			$TextureRect3/words.rotation = 0
			stop_rotate_words = false
			drag = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if drag:
			if word:
				if !target_word.has(word):
					target_word.append(word)
			$TextureRect3/Line2D.points = []
			for words2 in target_word:
				$TextureRect3/Line2D.add_point(words2.global_position + words2.size / 2)
			$TextureRect3/Line2D.add_point(get_global_mouse_position())
			if $TextureRect3/Line2D.points.size() > 0:
				$TextureRect3/Line2D.set_point_position(len($TextureRect3/Line2D.points) - 1, get_global_mouse_position())
			text = ""
			for words2 in target_word:
				text += words2.text
			$label_pos/Label.text = text
	else:
		var next_level = true
		if data.state == 0:
			for x in range(data.answers.size()):
				var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
				if text == data.answers[x]:
					for y in range(hbox.get_children().size()):
						if hbox.get_child(y).get_child(0).text == "":
							true_answer = true
							hbox.get_child(y).get_child(0).text = data.answers[x][data.answers[x].length() - 1 - y]
							w_answer_list.append(Vector2(x, y))
							find_word(hbox.get_child(y).get_child(0))
						else:
							answered = true
				for y in range(hbox.get_children().size()):
					if hbox.get_child(y).get_child(0).text == "":
						next_level = false
		if data.state == 1:
			for x in range(data.answers[0].size()):
				var boxs = get_tree().get_nodes_in_group("answer_r_"+str(x))
				if text == data.answers[0][data.answers[0].size() - x - 1]:
					for y in range(boxs.size()):
						if boxs[y].text == "":
							true_answer = true
							boxs[y].text = data.answers[0][data.answers[0].size() - x - 1][data.answers[0][data.answers[0].size() - x - 1].length() - y - 1]
							find_word(boxs[y])
							w_answer_list.append(Vector2(x, y))
						else:
							answered = true
				for y in range(boxs.size()):
					if boxs[y].text == "":
						next_level = false
			for x in range(data.answers[1].size()):
				var boxs = get_tree().get_nodes_in_group("answer_c_"+str(x))
				if text == data.answers[1][x]:
					for y in range(boxs.size()):
						if boxs[y].text == "":
							true_answer = true
							boxs[y].text = data.answers[1][x][y]
							find_word(boxs[y])
							w_answer_list.append(Vector2(x, y))
						else:
							answered = true
				for y in range(boxs.size()):
					if boxs[y].text == "":
						next_level = false
		if text != "":
			drag = false
			if true_answer:
				true_answer_animation()
				$label_pos/Label.add_theme_stylebox_override("normal", preload("res://styles/word_label_t.tres"))
			elif answered:
				$label_pos/Label.add_theme_stylebox_override("normal", preload("res://styles/word_label_b.tres"))
			else:
				$label_pos/Label.add_theme_stylebox_override("normal", preload("res://styles/word_label_f.tres"))
			target_word = []
			$TextureRect3/Line2D.points = []
			await get_tree().create_timer(0.5).timeout
			
			drag = true
			true_answer = false
			answered = false
			$label_pos/Label.add_theme_stylebox_override("normal", preload("res://styles/word_label_n.tres"))
			text = ""
			$label_pos/Label.text = text
			
			if next_level:
				$bee/AnimationPlayer.play("true_answer")
				$bee/AnimatedSprite2D.play("default")
				$satan/AnimationPlayer.play("fall")
				await get_tree().create_timer(0.5).timeout
				end()
				
	$label_pos.global_position.y = $TextureRect3.global_position.y - $label_pos/Label.size.y
	$label_pos.global_position.x = ($TextureRect3.global_position.x + $TextureRect3.size.x / 2) - $label_pos/Label.size.x / 2



func _on_Label_mouse_exit(object):
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target_word.erase(object)
	word = null

func _on_Label_mouse_hover(object):
	if !target_word.has(object) and drag:
		target_word.append(object)
	


func _on_PersianButton_pressed():
	var m = preload("res://scenes/menu_levels.tscn").instantiate()
	
	get_tree().get_root().add_child(m)
	menu_open = false
	$CanvasLayer/Panel/AnimationPlayer.play("close")

func _on_PersianButton2_pressed():
	menu_open = true
	$CanvasLayer/Panel/AnimationPlayer.play("open")


func _on_TextureButton_pressed():
	if !rotate_words and !stop_rotate_words and !back_rotate_words:
		rotate_words = true
		drag = false


func _on_button_5_pressed():
	get_tree().change_scene_to_file("res://scenes/start.tscn")


func true_answer_animation():
	var tween = get_tree().create_tween()
	tween.tween_property($satan, "position:x", -46, 1)
	
	$bee/AnimationPlayer.play("blowing")
	$bee/AnimatedSprite2D.play("blowing")
	await $bee/AnimationPlayer.animation_finished
	$bee/AnimatedSprite2D.play("default")
	$bee/AnimationPlayer.play("Idle")
func _on_help_button_pressed(state, _score):
	help(state, _score)
	menu_open = false
	$CanvasLayer/Panel/AnimationPlayer.play("close")


func _on_texture_button_pressed():
	menu_open = false
	$CanvasLayer/Panel/AnimationPlayer.play("close")



func _on_button_pressed():
	if !ques_menu:
		$AnimationPlayer2.play("question")
		ques_menu = true
		$bee/AnimatedSprite2D.play("default")
	else:
		$AnimationPlayer2.play_backwards("question")
		await $AnimationPlayer2.animation_finished
		ques_menu = false
		
func _on_button_2_pressed():
	$AnimationPlayer2.play_backwards("question")
	ques_menu = false

func _on_gui_input(event):
	if event is InputEventScreenTouch:
		if menu_open:
			menu_open = false
			$CanvasLayer/Panel/AnimationPlayer.play("close")
		if ques_menu:
			$AnimationPlayer2.play_backwards("question")
			ques_menu = false
		




func _on_area_2d_area_entered(area):
	
	speed = 0
	var _score = 0
	
	$satan/AnimationPlayer.play("shot")
	if data.state == 0:
		
		for x in range(data.answers.size()):
			var hbox = get_tree().get_nodes_in_group("answer"+str(x))[0]
			for y in range(hbox.get_children().size()):
				find_word(hbox.get_child(y).get_child(0))
				if hbox.get_child(y).get_child(0).text == "":
					hbox.get_child(y).get_child(0).text = data.answers[x][data.answers[x].length() - 1 - y]
					hbox.get_child(y).get_child(0).label_settings = preload("res://styles/box_word_f.tres")
				else:
					_score += 1

	if data.state == 1:
		for box in table_box:
			if box == "":
				get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0].text = data.data[box.x][box.y]
				find_word(get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0])
				get_tree().get_nodes_in_group("answer_"+str(box.x)+"_"+str(box.y))[0].label_settings = preload("res://styles/box_word_f.tres")
			else:
				_score += 1

	if data.state == 2:
		for option in get_tree().get_nodes_in_group("options"):
			option.disabled = true
		get_tree().get_nodes_in_group("options")[data.correct_answer - 1].add_theme_stylebox_override("disabled", preload("res://styles/test_btn_t.tres"))
	if data.state == 3:
		$VBoxContainer/Button.disabled = true
		var options = get_tree().get_nodes_in_group("choice_option")
		for x in range(options.size()):
			if !options[x].sellected:
				if options[x].correct:
					options[x].get_node("Label").add_theme_stylebox_override("normal", preload("res://styles/choice_option_t.tres"))
				else:
					options[x].get_node("Label").add_theme_stylebox_override("normal", preload("res://styles/choice_option_f.tres"))
			else:
				if options[x].correct:
					_score += data.score
				else:
					_score -= data.score
	if data.state == 4:
		$VBoxContainer/Button.disabled = true
		var options = get_tree().get_nodes_in_group("left_col")
		for x in range(options.size()):
			
			options[x].mouse_filter = MOUSE_FILTER_IGNORE
			if options[x].sellect_num == data.answers[x]:
				_score += data.score
				options[x].add_theme_stylebox_override("normal", preload("res://styles/test_btn_t.tres"))
			else:
				options[x].match_options(int(data.answers[x].split("_")[1]))
				options[x].add_theme_stylebox_override("normal", preload("res://styles/test_btn_f.tres"))
				_score -= data.score
		var options2 = get_tree().get_nodes_in_group("right_col")
		for x in range(options2.size()):
			options2[x].mouse_filter = MOUSE_FILTER_IGNORE
			if options2[x].sellect_num == data.answers[x]:
				options2[x].add_theme_stylebox_override("normal", preload("res://styles/test_btn_t.tres"))
			else:
				options2[x].add_theme_stylebox_override("normal", preload("res://styles/test_btn_f.tres"))
		
	await $satan/AnimationPlayer.animation_finished
	$satan/AnimationPlayer.play("happing")
	await get_tree().create_timer(2).timeout
	print(_score)
	end()


func _on_end_button_pressed():
	var _score = 0
	speed = 0
	
	$VBoxContainer/Button.disabled = true
	if get_tree().has_group("match_option"):
		$VBoxContainer/Button.disabled = true
		var options = get_tree().get_nodes_in_group("left_col")
		for x in range(options.size()):
			options[x].mouse_filter = MOUSE_FILTER_IGNORE
			if options[x].sellect_num == data.answers[x]:
				_score += data.score
				options[x].add_theme_stylebox_override("normal", preload("res://styles/test_btn_t.tres"))
			else:
				options[x].match_options(int(data.answers[x].split("_")[1]))
				options[x].add_theme_stylebox_override("normal", preload("res://styles/test_btn_f.tres"))
				_score -= data.score
		var options2 = get_tree().get_nodes_in_group("right_col")
		for x in range(options2.size()):
			
			options2[x].mouse_filter = MOUSE_FILTER_IGNORE
			if options2[x].sellect_num in data.answers:
				
				options2[x].add_theme_stylebox_override("normal", preload("res://styles/test_btn_t.tres"))
			else:
				options2[x].add_theme_stylebox_override("normal", preload("res://styles/test_btn_f.tres"))
	if _score > 0:
		$satan/AnimationPlayer.play("fall")
		
		$bee/AnimatedSprite2D.play("default")
		$bee/AnimationPlayer.play("true_answer")
	else:
		$satan/AnimationPlayer.play("shot")
		await $satan/AnimationPlayer.animation_finished
		$satan/AnimationPlayer.play("happing")
	await get_tree().create_timer(2).timeout
	print(_score)


func _on_spear_2_area_entered(area):
	collide = true
	$bee/AnimatedSprite2D.play("fear")
	$bee/AnimationPlayer.play("death")
	

func _on_area_2d_2_area_entered(area):
	$bee/AnimatedSprite2D.play("fear")
	$bee/AnimationPlayer.play("fear")
	
func _on_area_2d_2_area_exited(area):
	$bee/AnimatedSprite2D.play("default")
	$bee/AnimatedSprite2D.frame = 2
	$bee/AnimationPlayer.play("Idle")

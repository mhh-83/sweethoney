extends Control


var data = []
var words = []
var col = 1
func _ready():
	
	$ScrollContainer/GridContainer.columns = col

func update_data(d):
	data = d
	for y in range(data.size()):
		for x in range(data[y].size()):
			if data[y][x] != " ":
				_on_btn_pressed($ScrollContainer/GridContainer.get_child(x + (y * data[y].size())), x + (y * data[y].size()), data[y][x])
func _reload(d=[[]]):
	data = []
	for y in range(col):
		var list = []
		for x in range(col):
			add_btn(x + (y * col))
			list.append(" ")
		data.append(list)
	for x in range(d.size()):
		for y in range(d[x].size()):
			if x < data.size() and y < data[x].size():
				data[x][y] = d[x][y]
	update_data(data)
func answers():
	var list_r = []
	var list_c = []
	var list = []
	var pos_r_list = []
	var pos_c_list = []
	for y in range(data.size()):
		var t = ""
		var t2 = ""
		var pos = ""
		var pos2 = ""
		for x in range(data[y].size()):
			if data[0][0] != " " and x == 0 and y == 0:
				pos += "_00_"
			elif data[y][x] != " ":
				pos += "_" + str(x + (y * data[y].size())) + "_"
			else:
				pos += "_0_"
			if data[0][0] != " " and x == 0 and y == 0:
				pos2 += "_00_"
			elif data[x][y] != " ":
				pos2 += "_" + str(y + (x * data[x].size())) + "_"
			else:
				pos2 += "_0_"
			t += data[data[y].size() - y - 1][data[y].size() - x - 1]
			t2 += data[x][y]
		pos_r_list.append(pos)
		pos_c_list.append(pos2)
		list_r.append(t)
		list_c.append(t2)
	var list_c2 = []
	var list_r2 = []
	var pos_r_list2 = []
	var pos_c_list2 = []
	for pos in pos_r_list:
		var sp = pos.split("_0_")
		for n in sp:
			if n != "" and n != " " and n.length() >= 6:
				pos_r_list2.append(n)
	for pos in pos_c_list:
		var sp = pos.split("_0_")
		for n in sp:
			if n != "" and n != " " and n.length() >= 6:
				pos_c_list2.append(n)
	for t in list_c:
		var sp = t.split(" ")
		for w in sp:
			if w != "" and w != " " and w.length() > 1:
				list_c2.append(w)
				
		
	for t in list_r:
		var sp = t.split(" ")
		for w in sp:
			if w != "" and w != " " and w.length() > 1:
				list_r2.append(w)
		
	list.append(list_r2)
	list.append(list_c2)
	list.append(pos_c_list2)
	list.append(pos_r_list2)
	return list
func add_btn(num):
	var btn = TextureButton.new()
	btn.texture_normal = preload("res://sprite/add_btn.png")
	btn.pressed.connect(_on_btn_pressed.bind(btn, num))
	$ScrollContainer/GridContainer.add_child(btn)
	
func _on_btn_pressed(btn, num, t=""):
	btn.disabled = true
	var line_edit = preload("res://scenes/table_box.tscn").instantiate()
	line_edit.text = t
	line_edit.gui_input.connect(box_input_event.bind(btn, line_edit, num))
	line_edit.text_changed.connect(box_text_change.bind(num, line_edit))
	btn.add_child(line_edit)
func box_input_event(event, btn, box, num):
	var kill= false
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		kill = true
	
	
	if kill and box:
		btn.disabled = false
		data[int(num / col)][int(num) % int(col)] = " "
		box.queue_free()

func box_text_change(new_text, num, box):
	box.add_theme_stylebox_override("normal", preload("res://styles/LineEdit2_n.tres"))
	var has_text = false
	for w in words:
		if new_text in w:
			has_text = true
	if new_text != "" and has_text:
		data[int(num / col)][int(num) % int(col)] = new_text
	else:
		box.text = ""
		data[int(num / col)][int(num) % int(col)] = " "


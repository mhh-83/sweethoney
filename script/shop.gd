extends PopupPanel

var save_path = "user://data.cfg"
var num
var cost
var mode_purchase
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$PopupPanel/Control/yes.pressed.connect(_on_purchase_button_complated)
	$PopupPanel/Control/no.pressed.connect(_on_purchase_button_faild)
	for x in range($Shop/ScrollContainer/VBoxContainer/HBoxContainer2.get_children().size()):
		
		var button = $Shop/ScrollContainer/VBoxContainer/HBoxContainer2.get_child(x).get_child(0)
		button.pressed.connect(_on_hive_button_pressed.bind(x, button.get("metadata/cost")))
		if load_game("open_hive"+str(x), false):
			button.disabled = true
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func load_game(_name, defaulte=null):
	var confige = ConfigFile.new()
	confige.load(save_path)
	return confige.get_value("user", _name, defaulte)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Shop.modulate = [Color.WHITE, Color("4f4f4f")][int($PopupPanel.visible)]
	
func _on_purchase_button_faild():
	$PopupPanel.hide()
func _on_purchase_button_complated():
	$PopupPanel.hide()
	var score = load_game("score", 0)
	match mode_purchase:
		"hive":
			score -= cost
			save("score", score)
			if get_tree().has_group('score'):
				get_tree().get_nodes_in_group("score")[0].text = "امتیاز : "+ str(load_game("score", 0))
			$Shop/ScrollContainer/VBoxContainer/HBoxContainer2.get_child(num).disabled = true
			save("open_hive"+str(num), true)
			var time = {"hour" : GlobalTime.current_time.hour, "minute": GlobalTime.current_time.minute, "second": GlobalTime.current_time.second}
			save("hive_time"+str(num), time)
func _on_hive_button_pressed(_num, _cost):
	
	if load_game("score", 0) >= _cost:
		$PopupPanel.popup_centered()
		cost = _cost
		num = _num
		mode_purchase = "hive"
func _on_texture_button_pressed():
	pass # Replace with function body.

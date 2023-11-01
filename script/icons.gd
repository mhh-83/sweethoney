extends ScrollContainer

signal button_pressed
# Called when the node enters the scene tree for the first time.
var save_path = "user://data.cfg"
func save(_name, num, path=save_path):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(path)
func load_game(_name, defaulte=null, path=save_path):
	var confige = ConfigFile.new()
	confige.load(path)
	return confige.get_value("user", _name, defaulte)
func _ready():
	for x in range(load_game("icons", [], "user://files.cfg").size()):
		add_icon(load_game("icons", [], "user://files.cfg")[x])
func add_icon(img):
	if FileAccess.file_exists("user://icons/"+img):
		var image = Image.load_from_file("user://icons/" + img)
		var tex = ImageTexture.create_from_image(image)
		var btn = TextureButton.new()
		var control = Control.new()
		btn.texture_normal = tex
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.size = Vector2(80, 80)
		btn.pressed.connect(_on_btn_pressed.bind(img))
		control.add_child(btn)
		$GridContainer.add_child(control)
func _on_btn_pressed(img):
	emit_signal("button_pressed", img)

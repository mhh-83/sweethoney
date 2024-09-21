extends Control


var save_path = "user://data.cfg"
var time = {}
@onready var score = load_game("score", 0)
@export var need_score = 0
var camera_move = false
var light = 255
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)
func load_game(_name, defaulte = null):
	var confige = ConfigFile.new()
	confige.load(save_path)
	return confige.get_value("user", _name, defaulte)
# Called when the node enters the scene tree for the first time.
func _ready():
	save("league", true)
	save("end_league", false)
	var json = JSON.new()
	var file = FileAccess.open("user://time_league/time_league.json", FileAccess.READ)
	time = json.parse_string(file.get_as_text())
	file.close()
	
	if load_game("end_league", false):
		$Button.disabled = true
		$timer.queue_free()
		$timer2.show()
		
		$timer2.start("close_league", time[2], 0)
	else:
		$timer.start("end_league", time[1], 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if load_game("league", false):
		$Button3.hide()
		$Button.show()
		$Label.hide()
	else:
		if score < need_score:
			$Button3.disabled = true
			$SubViewport/TextureProgressBar.value = score * 100 / need_score
			$Label.text = str(score) + " / " + str(need_score)
		else:
			$Button3.disabled = false
			$Label.hide()
	if camera_move:
		$Camera2D.zoom += Vector2(1, 1) * delta * 8
		light -= 4
		$CanvasModulate.color = Color8(light, light, light, 255)
		if $Camera2D.zoom.x >= 10:
			Exit.change_scene("res://scenes/league_parts.tscn")
func _on_button_2_pressed():
	Exit.change_scene("res://scenes/start.tscn")

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_button_2_pressed()
func _on_timer_timeout():
	save("end_league", true)
	$Button.disabled = true

func _on_timer2_timeout():
	save("close_league", true)
	Exit.change_scene("res://scenes/start.tscn")


func _on_button_3_pressed():
	pass # Replace with function body.


func _on_button_pressed():
	$TextureRect.texture = preload("res://sprite/fd.png")
	camera_move = true

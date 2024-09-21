extends Control

var save_path = "user://data.cfg"
var anime_finish = false
var zoom = false
var teach = false
var tiles = []
var points = []
var unlock_part = 1
var count = 0
var add_move = 0
var unlock_level = 0
var max_level = 0
func add_point(point, line:Line2D, num):
	line.points = []
	for x in range(point.size()):
	
		if x < point.size() - 1:
			var a = point[x]
			var b = point[x + 1]
			if x == 0:
				line.add_point(a)
			for y in range(num):
				var c = a + (a.direction_to(b) * (y * ((b - a).length() / float(num))))
				if (c - a).length() > 3:
					line.add_point(c)
			line.add_point(b)
func reload():
	unlock_part = load_game("unlock_part", 0)
	$Line2D2.points = []
	points = []
	count = 0
	for y in range(get_tree().get_nodes_in_group("part").size()):
		var button = get_tree().get_nodes_in_group("part")[y]
		if unlock_part < y:
			button.disabled = true
		var pos = button.global_position
		var _size = button.size
		if !button.disabled:
			for x in range($Line2D.points.size()):
				if Geometry2D.is_point_in_polygon($Line2D.points[x], [Vector2(pos.x, pos.y), Vector2(pos.x + _size.x, pos.y), pos + _size, Vector2(pos.x, pos.y + _size.y)]):
					points.append(x)
					
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
	reload()
	add_point($Line2D.points, $Line2D, 10)
	if unlock_part < 4:
		var p = []
		var button = get_tree().get_nodes_in_group("part")[unlock_part]
		var pos = button.global_position
		var _size = button.size
		var button2 = get_tree().get_nodes_in_group("part")[unlock_part + 1]
		var pos2 = button2.global_position
		var _size2 = button2.size
		for x in range($Line2D.points.size()):
			if Geometry2D.is_point_in_polygon($Line2D.points[x], [Vector2(pos.x, pos.y), Vector2(pos.x + _size.x, pos.y), pos + _size, Vector2(pos.x, pos.y + _size.y)]):
				p.append(x)
			if Geometry2D.is_point_in_polygon($Line2D.points[x], [Vector2(pos2.x, pos2.y), Vector2(pos2.x + _size2.x, pos2.y), pos2 + _size2, Vector2(pos2.x, pos2.y + _size2.y)]):
				p.append(x)
		match unlock_part:
			0:
				unlock_level = load_game("unlock_level_m", 1)
				max_level = load_game("max_level_m", 1)
			1:
				unlock_level = load_game("unlock_level_h", 1)
				max_level = load_game("max_level_h", 1)
			2:
				unlock_level = load_game("unlock_level_s", 1)
				max_level = load_game("max_level_s", 1)
			3:
				unlock_level = load_game("unlock_level_v", 1)
				max_level = load_game("max_level_v", 1)
		add_move = ((p.max() - p.min()) / max_level) * (unlock_level -1)
	
func _on_button_pressed(count):
	if anime_finish and !zoom:
		zoom = true
		match count:
			0:
				$Camera2D.position = $Button4.position + $Button4.size / 2
			1:
				$Camera2D.position = $Button.position + $Button.size / 2
			2:
				$Camera2D.position = $Button3.position + $Button3.size / 2
			3:
				$Camera2D.position = $Button2.position + $Button2.size / 2
			4:
				$Camera2D.position = $Button6.position + $Button6.size / 2
		$AnimationPlayer.play("zoom")
		save("part", count)
		await $AnimationPlayer.animation_finished
		$AnimationPlayer2.play("RESET")
		$Hand.hide()
		save("teach", false)
		get_tree().get_root().add_child(preload("res://scenes/levels.tscn").instantiate())
		$Camera2D.enabled = false

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and not get_tree().has_group("levels"):
		_on_button_5_pressed()

func _process(delta):
	if $Line2D2.points.size() < ((points.max()) * 10) + add_move:
		$Line2D2.add_point($Line2D.points[count])
		await get_tree().create_timer(0.01).timeout
		count += 1
	else:
		$CPUParticles2D.global_position = $Line2D2.get_point_position(count - 1)
		$CPUParticles2D.look_at($Line2D.get_point_position(count))
		$BeePng74659.position = $Line2D2.get_point_position(count - 1)
		if randi_range(0, 100) == 1 and get_tree().get_processed_tweens().size() == 0:
			var tween = get_tree().create_tween()
			tween.tween_property($BeePng74659, "rotation", $BeePng74659.rotation + randi_range(-PI, PI), 0.5)
			tween.play()
func _on_button_5_pressed():
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start":
		anime_finish = true
		if teach:
			$Hand.show()
			$AnimationPlayer2.play("teach")

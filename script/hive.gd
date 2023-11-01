extends TextureButton

	
var save_path = "user://data.cfg"
var onlock = false
@export_range(0, 3) var num = 1
var score = 40
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
	randomize()
	if load_game("open_hive"+str(num), false):
		disabled = false
		var time = {"hour" : GlobalTime.current_time.hour, "minute": GlobalTime.current_time.minute, "second": GlobalTime.current_time.second}
		$timer.start("hive"+ str(num), load_game("hive_time" + str(num), time))
		texture_normal = load("res://sprite/hive2.png")
		$timer.show()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if load_game("hive"+ str(num), false):
		texture_normal = load("res://sprite/hive3.png")
		$timer.hide()
	if onlock:
		if randi_range(1, 1000) == 1:
			var bee = preload("res://scenes/hive_bee.tscn").instantiate()
			var pos = Vector2.ZERO
			var h = ($Area2D/CollisionPolygon2D.polygon[3].y - $Area2D/CollisionPolygon2D.polygon[0].y) * scale.y
			var w = ($Area2D/CollisionPolygon2D.polygon[2].x - $Area2D/CollisionPolygon2D.polygon[0].x) * scale.x
			var pos_x = randi_range($Area2D/CollisionPolygon2D.polygon[0].x, w)
			var pos_y = 0
			
			
			if pos_x < w / 2:
				var z1 = (h / 2) - ((pos_x * sin(deg_to_rad(31))) / sin(deg_to_rad(59)))
				var z2 = (h / 2) + ((pos_x * sin(deg_to_rad(31))) / sin(deg_to_rad(59)))
				pos_y = randi_range(z1, z2)
				
			else:
				var z1 = (h / 2) - (((w - pos_x) * sin(deg_to_rad(29))) / sin(deg_to_rad(61)))
				var z2 = (h / 2) + (((w - pos_x) * sin(deg_to_rad(29))) / sin(deg_to_rad(61)))
				pos_y = randi_range(z1, z2)
			
			pos += Vector2(pos_x, pos_y)
			bee.parent_pos = $Marker2D.global_position
			bee.global_position = global_position + pos
			%bees.add_child(bee)

func _on_pressed():
	if load_game("hive"+ str(num), false):
		if get_parent():
			if !get_parent().collect:
				$timer.show()
				get_parent().collect_honey(score, global_position, num)
				texture_normal = load("res://sprite/hive2.png")
				save("last_time_hive" + str(num), GlobalTime.current_time)
				save("hive"+ str(num), false)



func _on_area_2d_body_entered(body):
	if body.go_back:
		body.queue_free()

extends Control

var save_path = "user://data.cfg"
var anime_finish = false
var zoom = false
var teach = false
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
	
	var unlock_part = load_game("unlock_part", 1)
	for btn in get_tree().get_nodes_in_group("part"):
		if btn.num >= unlock_part:
			btn.disabled = true
func _on_button_pressed(count):
	if anime_finish and !zoom:
		zoom = true
		match count:
			0:
				$Camera2D.position = $Button.position + $Button.size / 2
			1:
				$Camera2D.position = $Button2.position + $Button2.size / 2
			2:
				$Camera2D.position = $Button3.position + $Button3.size / 2
			3:
				$Camera2D.position = $Button4.position + $Button4.size / 2
		$AnimationPlayer.play("zoom")
		save("part", count)
		await $AnimationPlayer.animation_finished
		$AnimationPlayer2.play("RESET")
		$Hand.hide()
		save("teach", false)
		get_tree().get_root().add_child(preload("res://scenes/levels.tscn").instantiate())
		$Camera2D.enabled = false
	



func _process(delta):
	var x = 0
	match load_game("unlock_part", 1):
		1:
			x = int((load_game("unlock_level_h", 1) * 100 / load_game("max_level_h", 1)) * 0.01 * 6) + 1
		2:
			x = int((load_game("unlock_level_v", 1) * 100 / load_game("max_level_v", 1)) * 0.01 * 5) + 7
		3:
			x = int((load_game("unlock_level_s", 1) * 100 / load_game("max_level_s", 1)) * 0.01 * 5) + 12
		4:	
			x = 17
	
	if $AnimatedSprite2D.frame >= x:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = x

func _on_button_5_pressed():
	
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start":
		$AnimatedSprite2D.play("default")
		anime_finish = true
		if teach:
			$Hand.show()
			$AnimationPlayer2.play("teach")

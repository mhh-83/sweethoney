extends Control


var timer
var collect = false
@export var score = 0

func load_game(_name, defaulte = null):
	var confige = ConfigFile.new()
	confige.load(save_path)
	return confige.get_value("user", _name, defaulte)
func collect_honey(score, pos, num):
	collect = true
	save("score", load_game("score", 0) + score)
	if get_tree().has_group("score"):
		get_tree().get_nodes_in_group("score")[0].text = "امتیاز : " + str(load_game("score", 0))
	var animation = %AnimationPlayer.get_animation("collect_honey")
	animation.track_insert_key(0, 0.0, pos)
	$TextureProgressBar.scale = Vector2((num * 0.2) + 0.2, (num * 0.2) + 0.2)
	animation.track_insert_key(2, 0.0, Vector2((num * 0.2) + 0.2, (num * 0.2) + 0.2))
	
	%AnimationPlayer.play("collect_honey")
func _ready():
	save("hive1", true)
	score = load_game("score", 0)
	$TextureProgressBar2.value = score * 100 / 5000
	$TextureProgressBar2/Label.text = str(score)
	if get_tree().has_group("timer"):
		timer = get_tree().get_nodes_in_group("timer")[0]
		for t in get_tree().get_nodes_in_group("timer"):
			if t.start_timer == false:
				await get_tree().create_timer(0.1).timeout
		$AnimationPlayer.play("show")
var save_path = "user://data.cfg"
func save(_name, num):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(save_path)

func _on_button_pressed():
	if !get_node_or_null("Node2D"):
		if timer:
			save("last_time_gift", timer.current_time)
			for hive in get_tree().get_nodes_in_group("hive"):
				save("last_time_hive"+ str(hive.num), timer.current_time)
		queue_free()

func _process(delta):
	
	if (%AnimationPlayer.current_animation == "collect_honey" and %AnimationPlayer.current_animation_position >= 4) or \
	(%AnimationPlayer.current_animation == "end" and %AnimationPlayer.current_animation_position <= 1):
		var tween = get_tree().create_tween()
		tween.tween_property($TextureProgressBar2, "value", load_game("score", 0) * 100 / 5000, 2)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(self, "score", load_game("score", 0), 1.5)
	$TextureProgressBar2/Label.text = str(int(score))
func _on_animation_player_animation_finished(anim_name):
	$Node2D.queue_free()


func _on_animation_player_animation_finished2(anim_name):
	match anim_name:
		"collect_honey":
			%AnimationPlayer.play("end")
		"end":
			collect = false

extends Control



func _on_animation_player_animation_finished(anim_name):
	$AnimationPlayer.play_backwards("start")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/load.tscn")

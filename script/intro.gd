extends Control

func _on_animation_player_animation_finished(anim_name):
	$AnimationPlayer.play_backwards("start")
	await $AnimationPlayer.animation_finished
	Exit.change_scene("res://scenes/load.tscn")

extends Panel


func _on_button_pressed():
	for child in get_tree().get_root().get_children():
		if child != AddBee and child != Exit and GlobalTime:
			child.queue_free()
	get_tree().change_scene_to_file("res://scenes/load.tscn")

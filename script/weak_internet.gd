extends PopupPanel



func _on_button_2_pressed():
	hide()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")

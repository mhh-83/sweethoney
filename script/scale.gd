extends Button

func _ready():
	size.x = get_child(0).size.x * 1.58
	size.y = size.x / 2.75
	scale = (custom_minimum_size * 100 / size) * 0.01
	if scale.x < 0.5:
		scale = Vector2.ONE * 0.5
		size = Vector2(750, 273)
		$Label.autowrap_mode = 3
		$Label.custom_minimum_size.x = 466

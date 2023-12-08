extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var d = {}
	for child in get_children():
		d[child.name] = [[], []]
		for child2 in child.get_children():
			d[child.name][1].append({child2.name : [[], []]})
			for child3 in child2.get_children():
				d[child.name][1][child2.name][1].append({child3.name : [[], []]})
				for child4 in child3.get_children():
					d[child.name][1][child2.name][1][child3.name][1].append({child4.name : [[], []]})
					for child5 in child4.get_children():
						d[child.name][1][child2.name][1][child3.name][1][child4.name][1].append({child5.name : [[], []]})
	print(d)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

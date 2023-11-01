extends RigidBody2D

var drag = false
var correct = false
var start_pos
var sellected

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drag:
		global_position = get_global_mouse_position()
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		drag = false
		if !sellected:
			global_position = start_pos
			
	if sellected:
		
		$Label.scale = Vector2(0.5, 0.5)
		$CollisionShape2D.scale = Vector2(0.5, 0.5)




func _on_label_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and !sellected:
		drag = true
		

shader_type canvas_item;
uniform float range = 100.0;
uniform float speed = 1.0;
uniform float dir : hint_range(-1.0, 1.0, 1.0);
void vertex(){
	VERTEX.x += sin(TIME * speed * dir) * range * (UV.y - 1.0);
}

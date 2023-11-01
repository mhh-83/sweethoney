shader_type canvas_item;
uniform float speed = 1.0;
void fragment() {
	vec2 uv = vec2(UV.x, UV.y - TIME * speed);
	COLOR = texture(TEXTURE, uv);
}

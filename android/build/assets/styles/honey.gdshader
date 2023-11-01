shader_type canvas_item;

void fragment() {
	vec2 uv = vec2(UV.x, UV.y - TIME);
	COLOR = texture(TEXTURE, uv);
}

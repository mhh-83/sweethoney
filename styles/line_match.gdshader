shader_type canvas_item;
uniform float speed = 0.5;

void fragment() {
	
	vec2 uv = vec2(UV.x + (-TIME * speed), UV.y);
	
	COLOR = texture(TEXTURE, uv) ;
}

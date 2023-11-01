shader_type canvas_item;
uniform vec4 color: source_color;
uniform float speed;
uniform float x;
uniform float y;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
void vertex(){
	UV.x += TIME * speed;
}
void fragment(){
	vec2 uv = UV;
	COLOR = color;
	if(UV.y < 0.1){
		COLOR.a = (fma(sin(uv.x * x) + 4.5, sin(uv.y * y), -0.1));
		COLOR.a = clamp(COLOR.a, 0.0, color.a);
	}
	
}
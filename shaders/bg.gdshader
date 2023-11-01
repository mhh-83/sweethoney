shader_type canvas_item;
uniform vec4 color: source_color;
uniform vec4 color2: source_color;
void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if(tex.g >= 0.3 && tex.b >= 0.3 && tex.r >= 0.3){
		COLOR = color;
	}
	else if(tex.g < 0.3 && tex.r < 0.3 && tex.b < 0.3){
		COLOR = color2;
	}
	COLOR.a = texture(TEXTURE, UV).a;
	
}

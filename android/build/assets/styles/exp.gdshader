shader_type canvas_item;

void fragment() {

	if(texture(TEXTURE, UV).r <= 0.4 && texture(TEXTURE, UV).g <= 0.4 && texture(TEXTURE, UV).b <= 0.4){
		COLOR.a = 0.0;
	}
}

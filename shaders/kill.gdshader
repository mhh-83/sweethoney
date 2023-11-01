shader_type canvas_item;
uniform int frame : hint_range(0, 100, 1) = 0;
void fragment() {
	for(int i; i <= frame; i++){
		if(1.0 - UV.y <= float(float(i) * 0.01)){
			COLOR.a = 0.0;
		}
	}
}

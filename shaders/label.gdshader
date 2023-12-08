shader_type canvas_item;
uniform float scale = 1.0;
uniform vec2 offset;
uniform vec2 movent;

uniform sampler2D tex : repeat_enable;
void fragment() {
	
	COLOR.rgb = texture(tex, vec2(UV + offset + movent * TIME) * scale).rgb;
}

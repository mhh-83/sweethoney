shader_type canvas_item;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    
    // Check whether the current pixel is even or odd
    int x = int(floor(uv.x));
    int y = int(floor(uv.y));
    bool is_even = (x + y) % 2 == 0;
    
    // Set the color of the pixel based on whether it is even or odd
    if (is_even) {
        COLOR = vec4(1.0, 1.0, 1.0, 1.0);
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
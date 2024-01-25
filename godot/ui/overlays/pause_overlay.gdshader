shader_type canvas_item;

uniform vec4 overlay_color: source_color;
uniform float blur_amount: hint_range(0.0, 10.0) = 1.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void fragment() {
    vec2 size = vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 uv = SCREEN_UV;
    
    vec4 color = vec4(0.0);
    float total = 0.0;
    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            vec2 offset = vec2(float(x), float(y)) * blur_amount / size;
            color += texture(SCREEN_TEXTURE, uv + offset);
            total += 1.0;
        }
    }
    color /= total;

    COLOR = color * overlay_color;
}

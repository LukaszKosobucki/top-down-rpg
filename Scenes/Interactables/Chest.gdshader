shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.2, 1.0);
uniform float outline_size = 0.0;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    
    float alpha = col.a;
    
    if (alpha == 0.0) {
        float outline = 0.0;
        
        outline += texture(TEXTURE, UV + vec2(outline_size, 0.0) * TEXTURE_PIXEL_SIZE).a;
        outline += texture(TEXTURE, UV + vec2(-outline_size, 0.0) * TEXTURE_PIXEL_SIZE).a;
        outline += texture(TEXTURE, UV + vec2(0.0, outline_size) * TEXTURE_PIXEL_SIZE).a;
        outline += texture(TEXTURE, UV + vec2(0.0, -outline_size) * TEXTURE_PIXEL_SIZE).a;
        
        if (outline > 0.0) {
            COLOR = outline_color;
        }
    } else {
        COLOR = col;
    }
}
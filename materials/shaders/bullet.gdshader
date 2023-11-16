shader_type canvas_item;

uniform vec4 bullet_color: source_color;

const float precision = 0.1;
const vec4 original_bullet_color = vec4(1, 0, 0.267, 1);
varying flat vec4 modulate;

vec4 swap_color(vec4 color){
	if (distance(color, original_bullet_color) <= precision){
		return vec4(bullet_color.rgb, color.a);
	}
	return color;
}

void vertex() {
	modulate = COLOR;
}

void fragment() {
	COLOR = swap_color(texture(TEXTURE, UV)) * modulate;
}
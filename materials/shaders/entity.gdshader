shader_type canvas_item;

uniform float flash_amount: hint_range(0, 1);
uniform vec4 flash_color: source_color = vec4(1, 1, 1, 1);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, flash_color.rgb, flash_amount);
	COLOR = color;
}

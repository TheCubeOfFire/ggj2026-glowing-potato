shader_type canvas_item;
render_mode blend_add;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 vUVOffset = vec2(cos(TIME), sin(TIME));
    COLOR = texture(TEXTURE, UV + vUVOffset * 0.1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

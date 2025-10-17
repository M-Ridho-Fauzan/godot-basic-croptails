//shader_type canvas_item;
//
//uniform vec4 original_0 : source_color;
//uniform vec4 original_1 : source_color;
//
//uniform vec4 replace_0 : source_color;
//uniform vec4 replace_1: source_color;
//
//const float precission = 0.1;
//
//void vertex() {
	//// Called for every vertex the material is visible on.
//}
//
//vec4 replace_color(vec4 color) {
	//vec4 original_colors[2] = vec4[2](original_0, original_1);
	//vec4 replace_colors[2] = vec4[2](replace_0, replace_1);
//
	//for (int i = 0; i < 2; i++) {
		//if (distance(color, original_colors[i]) <= precission) {
			//color = replace_colors[i];
		//}
	//}
//
	//return color;
//}
//
//void fragment() {
	////vec4 color = texture(TEXTURE, UV);
	////if (distance(color, original_0) <= precission) {
		////color = replace_0;
	////}
	////COLOR = color;
	//COLOR = replace_color(texture(TEXTURE, UV));
//}
//
////void light() {
////	// Called for every pixel for every light affecting the CanvasItem.
////	// Uncomment to replace the default light processing function with this one.
////}


// kelap kelip skin

shader_type canvas_item;

uniform vec4 original_0 : source_color;
uniform vec4 original_1 : source_color;

// Kita tidak lagi membutuhkan uniform replace_0 dan replace_1
// karena warna pengganti akan dihasilkan secara dinamis.

const float precission = 0.1; // Toleransi untuk pencocokan warna.
uniform float cycle_speed : hint_range(0.1, 5.0, 0.1) = 1.0; // Kecepatan siklus warna. Sesuaikan di editor.
uniform float hue_offset : hint_range(0.0, 1.0, 0.01) = 0.0; // Offset hue awal. Sesuaikan di editor untuk warna awal yang berbeda.

// Fungsi konversi HSV ke RGB (implementasi standar di shader)
vec3 hsv_to_rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// Fungsi untuk mengganti warna, sekarang menerima warna pengganti dinamis sebagai input
vec4 replace_dynamic_color(vec4 current_pixel_color, vec3 dynamic_replace_rgb) {
	vec4 original_colors[2] = vec4[2](original_0, original_1);

	vec4 result_color = current_pixel_color;

	for (int i = 0; i < 2; i++) {
		// Bandingkan hanya komponen RGB untuk jarak guna mencocokkan warna
		if (distance(current_pixel_color.rgb, original_colors[i].rgb) <= precission) {
			// Ganti dengan warna RGB yang berputar
			result_color.rgb = dynamic_replace_rgb;
			// Alpha dari piksel asli dipertahankan, atau Anda bisa mengatur original_colors[i].a
		}
	}
	return result_color;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Hitung hue yang berputar berdasarkan TIME dan uniform
    // fract(TIME * cycle_speed) membuat hue berputar mulus dari 0.0 hingga 1.0
    float current_hue = fract(TIME * cycle_speed + hue_offset);

    // Konversi hue ke RGB (saturasi penuh, nilai penuh untuk siklus warna yang cerah)
    vec3 rotating_rgb = hsv_to_rgb(vec3(current_hue, 1.0, 1.0));

    // Panggil fungsi pengganti yang dimodifikasi
    COLOR = replace_dynamic_color(tex_color, rotating_rgb);
}
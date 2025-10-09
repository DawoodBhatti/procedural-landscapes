shader_type canvas_item;

// 📍 Center of the orbit (normalized UV space)
uniform vec2 center = vec2(0.5, 0.5);

// 📐 Radius of each circle in pixels
uniform float radius = 50.0;

// 🌫️ Fade edge in pixels
uniform float blur_radius = 10.0;

// 🌈 Hue cycle rate (cycles per second)
uniform float hue_rate = 0.01;

// 🔄 Rotation speed (radians per second)
uniform float rotation_speed = 0.2;

// 🧵 Number of trail dots
uniform int trail_length = 12;

// 📏 Screen size in pixels (set from GDScript)
uniform vec2 screen_size = vec2(1.0, 1.0);

// 🧮 Aspect ratio correction (set from GDScript as size.x / size.y, 1.0)
uniform vec2 screen_ratio = vec2(1.0, 1.0);

// 🎨 HSV to RGB conversion
vec3 hsv2rgb(float h, float s, float v) {
    float c = v * s;
    float x = c * (1.0 - abs(mod(h * 6.0, 2.0) - 1.0));
    float m = v - c;
    vec3 rgb;

    if (h < 1.0/6.0) rgb = vec3(c, x, 0.0);
    else if (h < 2.0/6.0) rgb = vec3(x, c, 0.0);
    else if (h < 3.0/6.0) rgb = vec3(0.0, c, x);
    else if (h < 4.0/6.0) rgb = vec3(0.0, x, c);
    else if (h < 5.0/6.0) rgb = vec3(x, 0.0, c);
    else rgb = vec3(c, 0.0, x);

    return rgb + vec3(m);
}

void fragment() {
    vec2 uv = UV;
    vec2 corrected_uv = (uv - center) * screen_ratio;

    float pixel_radius = radius / screen_size.x;
    float pixel_blur_radius = blur_radius / screen_size.x;
    float orbit_radius = pixel_radius * 5.0;

    vec3 final_color = vec3(0.0);
    float final_alpha = 0.0;

    float base_angle = TIME * rotation_speed * TAU;

    for (int i = 0; i < trail_length; i++) {
        float t = trail_length > 1 ? float(i) / float(trail_length - 1) : 0.0;
        float angle = base_angle - float(i) * TAU / float(trail_length);

        vec2 offset = vec2(cos(angle), sin(angle)) * orbit_radius;
        vec2 dot_uv = offset;

        // 📏 Scale radius and blur per dot
        float scaled_radius = mix(pixel_radius, pixel_radius * 0.3, t);
        float scaled_blur = mix(pixel_blur_radius, pixel_blur_radius * 0.3, t);

        float dist = length(corrected_uv - dot_uv);
        float trail_alpha = mix(0.85, 0.55, t);

        //uncomment for scaling effect
        float alpha = smoothstep(scaled_radius, scaled_radius - scaled_blur, dist) * trail_alpha;
        //float alpha = smoothstep(pixel_radius, pixel_radius - pixel_blur_radius, dist) * trail_alpha;

        float hue = mod(TIME * hue_rate + t * 0.03, 1.0);
        vec3 color = hsv2rgb(hue, 1.0 - t * 0.03, 1.0);

        final_color += color * alpha;
        final_alpha += alpha;
    }

    COLOR = vec4(final_color, final_alpha);
}
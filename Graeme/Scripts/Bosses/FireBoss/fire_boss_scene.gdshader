shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float speed = 1.5;

void fragment() {
    vec2 uv = UV;

    // Move upward over time
    uv.y += TIME * speed;

    // Sample noise texture
    float n = texture(noise_tex, uv * vec2(2.0, 4.0)).r;

    // Shape flame
    float mask = smoothstep(1.0, 0.2, UV.y);

    float flame = pow(n * mask, 2.0);

    vec3 color = vec3(1.0, 0.5, 0.1) * flame;
    color += vec3(1.0, 0.8, 0.3) * pow(flame, 3.0);

    COLOR = vec4(color, flame);
}
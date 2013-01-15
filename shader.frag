uniform sampler2D tex;
uniform float Effect;

void main() {
    float force = Effect * (0.5- min(0.5, distance(gl_TexCoord[0].st, vec2(0.5, 0.5))));
    float x = sin(force*2.0)/20.0 * force;
    float y = cos(force*2.0)/20.0 * force;
    vec4 color = texture2D(tex, gl_TexCoord[0].st + vec2(x, y));
    gl_FragColor = vec4(
        color[0],
        color[1],
        color[2],
        color[3]
    );
}

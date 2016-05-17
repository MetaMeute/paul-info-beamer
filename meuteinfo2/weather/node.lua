gl.setup(1280, 100)

-- offset 55, 55
-- width 217
-- height 20
-- offset2 55, 430
-- n1 14
-- n2 2

util.resource_loader{"weather.gif"}

local shader = resource.create_shader([[
    void main() {
        gl_TexCoord[0] = gl_MultiTexCoord0;
        gl_FrontColor = gl_Color;
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    }
]], [[
    uniform sampler2D tex;
    uniform float t;

    float tr(float height, float offset, float t) {
	return height * (0.5 + atan((t - offset) * 25.0) / 3.14159);
    }

    float dy(float t) {
	float y = 0.0;
	t *= 19.0;

	y += tr(51.0, 0.0, t);
	y += tr(64.0, 16.0, t);
	y += tr(21.0, 17.0, t);
	y += tr(21.0, 18.0, t);

	for (int i = 1; i <= 15; ++i)
		y += tr(21.0, i, t);

	return y / 568.0;
    }

    void main() {
        vec2 uv = gl_TexCoord[0].st;
	float y = uv.y;
	uv.y -= dy(t);
        vec4 texel = texture2D(tex, uv);
	float a = 1.0;
	vec4 bg = vec4(1.0, 0.89411765, 0.48235294, 1.0);
	vec4 delta = abs(texel - bg);

	if ((delta.x + delta.y + delta.z) < 0.01 || uv.x < 55.0 / 309.0) {
		texel = vec4(1.0, 1.0, 1.0, 0.9);
	}

        gl_FragColor = texel;
    }
]])

function node.render()
  shader:use{ t = (sys.now() % 19) / 19} --dy((sys.now() % 19) / 19.0) }
  weather:draw(0, 0, 1280, 4.1424 * 568)
end

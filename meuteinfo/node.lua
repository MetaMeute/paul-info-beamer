gl.setup(1280, 1024)

util.auto_loader(_G)

meutelogo = resource.load_image("meutelogo.png")

local BORDER = 50

local logo_shader = resource.create_shader([[
    void main() {
        gl_TexCoord[0] = gl_MultiTexCoord0;
        gl_FrontColor = gl_Color;
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    }
]], [[
    uniform sampler2D tex;
    void main() {
        vec2 uv = gl_TexCoord[0].st;
        vec4 texel = texture2D(tex, gl_TexCoord[0].st);
        gl_FragColor = gl_Color * texel;
        gl_FragColor = vec4(1.0, 1.0, 1.0, texel.a);
    }
]])

function node.render()
  gl.clear(math.cos((sys.now()+42589)/7)*0.2, math.sin((sys.now()+199933)/23)*0.3, math.cos(sys.now()+999331)*0.2, 1)

  resource.render_child("mpd-status"):draw(BORDER, BORDER, WIDTH - BORDER, BORDER + 140)

  resource.render_child("wetterkarte"):draw(BORDER, BORDER + 2 * 70, 520 + BORDER, 571 + BORDER + 2 * 70)
  resource.render_child("webcams"):draw(WIDTH - BORDER - 640, BORDER + 2 * 70, WIDTH - BORDER, BORDER + 480 + 2 * 70) 

  resource.render_child("digitalclock"):draw(WIDTH - BORDER - 540, HEIGHT - BORDER - 200, WIDTH - BORDER, HEIGHT - BORDER)
 logo_shader:use()
        gl.perspective(50,
            WIDTH/2+60, HEIGHT/2+45, -WIDTH/1.38,
            WIDTH/2+60, HEIGHT/2+45, 0
        )
        gl.pushMatrix()
            gl.translate(200, HEIGHT-BORDER-128)
            gl.rotate(-10, 0, 0, 1)
            gl.translate(0, 200)
            -- gl.rotate((sys.now()*100) % 180-90, 1, 0, 0)
            gl.rotate(math.sin(sys.now()/2.0)*15, -1, 0, 0)
            gl.rotate(math.sin(sys.now()/5.0)*8, 0, 1, 0)
            gl.translate(0, -200)

  meutelogo:draw(0, 0, 2*226, 64*2)
        gl.popMatrix()
        gl.ortho()
    logo_shader:deactivate()
end

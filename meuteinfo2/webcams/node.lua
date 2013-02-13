local COUNTDOWN = 3
local FADEDURATION = 0.3

gl.setup(640, 480)

pictures = util.generator(function()
    local out = {}
    for name, _ in pairs(CONTENTS) do
        if name:match(".*jpg") then
            out[#out + 1] = name
        end
    end
    return out
end)
node.event("content_remove", pictures.remove)

local current_image = resource.load_image(pictures.next())
local next_image
local next_image_time = sys.now() + COUNTDOWN

local distort_shader = resource.create_shader([[
    void main() {
        gl_TexCoord[0] = gl_MultiTexCoord0;
        gl_FrontColor = gl_Color;
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    }
]], [[
    uniform sampler2D tex;
    uniform float effect;
    void main() {
        vec2 uv = gl_TexCoord[0].st;
        vec4 col;
        col.r = texture2D(tex,vec2(uv.x+sin(uv.y*20.0*effect)*0.2,uv.y)).r;
        col.g = texture2D(tex,vec2(uv.x+sin(uv.y*25.0*effect)*0.2,uv.y)).g;
        col.b = texture2D(tex,vec2(uv.x+sin(uv.y*30.0*effect)*0.2,uv.y)).b;
        col.a = texture2D(tex,vec2(uv.x,uv.y)).a;
        vec4 foo = vec4(1,1,1,effect);
        col.a = 1.0;
        gl_FragColor = gl_Color * col * foo;
    }
]])

function node.render()
  local time_to_next = next_image_time - sys.now()

  if time_to_next < FADEDURATION then
    if not next_image then
      next_image = resource.load_image(pictures.next())
    end
    local alpha = (FADEDURATION - time_to_next)/FADEDURATION
    local beta = math.sin(alpha*3.1415/2)
    alpha = (FADEDURATION - time_to_next)/FADEDURATION
    util.draw_correct(current_image, 0, 0, WIDTH, HEIGHT)
    --util.draw_correct(next_image, 0, 0, WIDTH, HEIGHT, alpha)
    util.post_effect(distort_shader, {
        effect = math.abs(alpha) * 3.2
    })
    util.draw_correct(next_image, 0, 0, WIDTH, HEIGHT, beta)
  else
    util.draw_correct(current_image, 0, 0, WIDTH,HEIGHT)
  end

  if time_to_next < 0 then
    if next_image then
      current_image = next_image
      next_image = nil
      next_image_time = sys.now() + COUNTDOWN
    else
      next_image_time = sys.now() + COUNTDOWN
    end
  end
end

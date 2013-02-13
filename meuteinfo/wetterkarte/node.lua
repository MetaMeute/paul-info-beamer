local COUNTDOWN = 0.2
local FADEDURATION = 0.2

gl.setup(520, 571)

function generator(refiller)
  local items = {}
  local index = 1
  return {
    next = function(self)
      if index > #items then 
        index = 1 
        items = {}
        for _, value in ipairs(refiller()) do
          items[#items + 1] = value
        end
      end
      local next_item = items[index]
      index = index + 1
      return next_item
    end;
  }
end

pictures = generator(function()
  local out = {}
  for name, _ in pairs(CONTENTS) do
    if name:match(".*png") then
      out[#out + 1] = name
    end
  end

  table.sort(out)

  return out
end)

node.event("content_remove", pictures.remove)

local current_image = resource.load_image(pictures.next())
local next_image
local next_image_time = sys.now() + COUNTDOWN

local crt_shader = resource.create_shader([[
    void main() {
        gl_TexCoord[0] = gl_MultiTexCoord0;
        gl_FrontColor = gl_Color;
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    }
]], [[
    uniform vec2 resolution;
    uniform float time;
    uniform sampler2D tex0;

    void main(void)
    {
        vec2 q = gl_FragCoord.xy / resolution.xy;
        vec2 uv = 0.5 + (q-0.5)*(0.95 + 0.05*sin(0.2*time));

        vec3 oricol = texture2D(tex0,vec2(q.x,1.0-q.y)).xyz;
        vec3 col;

        float fnord = sin(time*1.0) * 0.001;
        col.r = texture2D(tex0,vec2(uv.x+fnord,uv.y)).x;
        col.g = texture2D(tex0,vec2(uv.x+0.000,uv.y)).y;
        col.b = texture2D(tex0,vec2(uv.x-fnord,uv.y)).z;

        col = clamp(col*0.5+0.5*col*col*1.2,0.0,1.0);
        col *= 0.5 + 0.5*26.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);
        col *= vec3(1.0,1.0,1.0);
        col *= 0.9+0.1*sin(5.0*time+uv.y*1000.0);
        col *= 0.97+0.08*sin(3.0*time);

        float comp = smoothstep( 0.2, 0.5, sin(time) );

        gl_FragColor = vec4(col,1.0);
    }
]])

function node.render()
  util.draw_correct(current_image, 0, 0, WIDTH,HEIGHT)

  local time_to_next = next_image_time - sys.now()

  if time_to_next < FADEDURATION then
    if not next_image then
      next_image = resource.load_image(pictures.next())
    end
    util.draw_correct(next_image, 0,0, WIDTH,HEIGHT, (FADEDURATION - time_to_next)/FADEDURATION)
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

  util.post_effect(crt_shader, {
    resolution = {WIDTH, HEIGHT},
    time = sys.now(),
  })
end

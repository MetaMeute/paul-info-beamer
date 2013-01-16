local COUNTDOWN = 1.5*5
local FADEDURATION = 1.5*5

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

function node.render()
  util.draw_correct(current_image, 0, 0, WIDTH,HEIGHT)

  local time_to_next = next_image_time - sys.now()

  if time_to_next < FADEDURATION then
    if not next_image then
      next_image = resource.load_image(pictures.next())
    end
    local alpha = math.sin((FADEDURATION - time_to_next)/FADEDURATION*3.1415/2)
    alpha = (FADEDURATION - time_to_next)/FADEDURATION
    gl.pushMatrix()
    gl.translate(-WIDTH*alpha, 0, 0)
    util.draw_correct(current_image, 0, 0, WIDTH, HEIGHT)
    util.draw_correct(next_image, WIDTH, 0, 2*WIDTH, HEIGHT)
    gl.popMatrix()
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
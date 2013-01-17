local COUNTDOWN = 3
local FADEDURATION = 1.0

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
  local time_to_next = next_image_time - sys.now()

  if time_to_next < FADEDURATION then
    if not next_image then
      next_image = resource.load_image(pictures.next())
    end
    local alpha = math.sin((FADEDURATION - time_to_next)/FADEDURATION*3.1415/2)
    alpha = (FADEDURATION - time_to_next)/FADEDURATION
    util.draw_correct(current_image, 0, 0, WIDTH, HEIGHT)
    util.draw_correct(next_image, 0, 0, WIDTH, HEIGHT, alpha)
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

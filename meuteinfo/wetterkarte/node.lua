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
end

DELAY = 0.04

gl.setup(640, 480)

function generator(refiller)
    local items = {}
    local i = 1
    return {
        next = function(self)
            if i > #items then
              items = refiller()
              i = 1
            end

            local next_item = items[i]
            i = i + 1

            return next_item
        end;
    }
end

pictures = generator(function()
    local out = {}
    for name, _ in pairs(CONTENTS) do
        if name:match(".*jpg") then
            out[#out + 1] = name
        end
    end

    table.sort(out)
    return out
end)

local image_fn
local image
local time_next = sys.now()

function next_image()
    image_fn = pictures.next()
    image = resource.load_image(image_fn)
end

function node.render()
  if sys.now() > time_next then
    time_next = sys.now() + DELAY
    while 1 do
        if pcall(next_image) then
            break
        end
    end
  end

  util.draw_correct(image, 0, 0, WIDTH,HEIGHT)
end

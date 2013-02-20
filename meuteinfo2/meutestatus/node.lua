gl.setup(1024, 300)

RED = 9
YELLOW = 16
MAX = 9

local json = require"json"

util.auto_loader(_G)

local status

util.file_watch("status.json", function(content)
    status = json.decode(content)
end)

local BORDER = 30

function wrap(str, limit)
    limit = limit or 72
    local here = 1
    local wrapped = str:gsub("(%s+)()(%S+)()", function(sp, st, word, fi)
        if fi-here > limit then
            here = st
            return "\n"..word
        end
    end)
    local splitted = {}
    for token in string.gmatch(wrapped, "[^\n]+") do
        splitted[#splitted + 1] = token
    end
    return splitted
end

function draw_box(header, body, alpha)
  body = wrap(body, 32)

  textheight = 50
  height = 2*BORDER+50+10 + #body*textheight

  offset = HEIGHT - height

  bg:draw(0, offset, WIDTH, offset+height, 0.7)
  bg_hl:draw(0, offset, WIDTH, offset+height, alpha*0.7)
  bold:write(BORDER, offset+BORDER, header, 50, 1, 1, 1)
  for i, l in ipairs(body) do
    regular:write(BORDER, (i-1)*textheight+offset+BORDER+60, l, textheight, 1, 1, 1)
  end

  return height
end

local lastid = 0
local fade = 1
local fadeuntil = 0

function node.render()
  local alpha = 1
  for _, m in ipairs(status) do
    if m.source ~= "paul" then
      if m.id ~= lastid then
        fadeuntil = sys.now() + fade
        lastid = m.id
      end
      if sys.now() < fadeuntil then
        alpha = math.abs(sys.now() - fadeuntil) / fade
      else
        alpha = 0
      end
        draw_box(m.timestamp, m.message, alpha)
      break
    end
  end
end

gl.setup(540, 200)

util.auto_loader(_G)

function clock()
  local time, day, date

  local function update()
    time = os.date("%X")
    day = os.date("%A")
    date = os.date("%d. %B. %Y")
  end

  local function get_time() return time end
  local function get_day() return day end
  local function get_date() return date end

  update()

  return {
    update = update,
    time = get_time,
    day = get_day,
    date = get_date
  }
end

local last_update = sys.now()
local c = clock()

function node.render()
  if sys.now() - last_update > 0.5 then
    c.update()
    last_update = sys.now()
  end

  bold:write(0, 100, c.time(), 114, 1,1,1,1)
  bold:write(0, 0, c.day(), 50, 1, 1, 1, 1)
  bold:write(0, 50, c.date(), 50, 1, 1, 1, 1)
end

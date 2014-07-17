gl.setup(640, 550)

RED = 9
YELLOW = 16
MAX = 9

local json = require"json"

util.auto_loader(_G)

util.file_watch("routes.json", function(content)
    busses = json.decode(content)
end)

local times

function check_next_bus()
  local now = os.date("*t")

  times = check_bus(now.hour, now.min, now.wday, 0)

  if #times < MAX then
    local day = now.wday % 8 + 1
    local more_times = check_bus(0, 0, day, 24)
    for i, v in ipairs(more_times) do
      table.insert(times, v)
    end
  end
end

function draw_departures()
  local now = os.date("*t")

  for x, v in ipairs(times) do
    local min = math.floor((v.time - (now.hour + now.min/60)) * 60)
    local time_min = tostring(math.floor((v.time * 60) % 60 + 0.5))

    if #time_min == 1 then time_min = "0" .. time_min end

    local time = math.floor(v.time % 24) .. ":" .. time_min
    local departure

    local font

    if min > 29 then
      departure = time
      font = regular
    else
      departure = min .. "min"
      font = bold
    end

    local r,g,b
    r = 1
    g = 1
    b = 1

    if min < RED then 
      r = 1
      g = 0
      b = 0
    elseif min < YELLOW then
      r = 1
      g = 1
      b = 0
    end

    local l2 = bold:write(0,-100, v.route,50,r,g,b,1)
    local offset = math.max(l2, 60)
    bold:write(offset-l2, x*50, v.route, 50, r, g, b, 1)

    regular:write(offset+10, x*50+5, v.station, 40, r, g, b, 1)

    local l = font:write(0, -100, departure, 50, r, g, b, 1)
    font:write(WIDTH - l, x*50, departure, 50, r, g, b, 1)
    if x > MAX then break end
  end
end

function check_bus(hour, minute, day, offset)
  local times = {}
  local now = hour + minute/60

  if day == 1 then
    day = "su"
  elseif day == 7 then
    day = "sa"
  else
    day = "mo-fr"
  end

  for i, station in ipairs(busses) do
    for route, routes in pairs(station.routes) do
      for _, time in ipairs(routes[day]) do
        local h = math.floor(time)
        local m = (time - h) * 100
        local t = h + m/60
        if t > now then
          table.insert(times, { time = t + offset, route = route, station = station.name})
        end
      end
    end
  end


  table.sort(times, function (a, b) return a.time < b.time end)

  return times
end

local next_update = 0

function node.render()
    t = os.date("*t")
    if sys.now() > next_update  then
      next_update = sys.now() + 30
      check_next_bus()
    end

    bold:write(0, 0, "Nächster Bus", 50, 1, 1, 1, 1)
    draw_departures()
end

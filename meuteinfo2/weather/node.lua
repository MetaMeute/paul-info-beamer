gl.setup(320, 240)

local json = require("json")

util.auto_loader(_G)

local weather

util.file_watch("weather.json", function(content)
    weather = json.decode(content)
end)

local lastid = 0
local fade = 1
local fadeuntil = 0

function node.render()
  regular:write(0, 0, tostring(weather["main"]["temp"]) .. " K", 24, 1, 1, 1)
end

gl.setup(320, 240)

local json = require("json")

util.auto_loader(_G)

local data

util.file_watch("weather.json", function(content)
    data = json.decode(content)
end)

function node.render()
  regular:write(0, 0, tostring(data["main"]["temp"]) .. " K", 96, 1, 1, 1)
end

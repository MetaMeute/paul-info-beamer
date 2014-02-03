gl.setup(640, 240)

local json = require("json")

util.auto_loader(_G)

local data

util.file_watch("weather.json", function(content)
    data = json.decode(content)
end)

function node.render()
  regular:write(0, 0, string.format("%0.1f °C", data["main"]["temp"] - 273.15), 96, 1, 1, 1)
end

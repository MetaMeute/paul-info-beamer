gl.setup(400, 300)

util.auto_loader(_G)

node.alias("traffic")

local rx, tx

rx = 0
tx = 0

node.event("data", function (data, suffix) 
  if suffix == "rx" then rx = data end
  if suffix == "tx" then tx = data end
end)

function node.render()
  bold:write(0, 0, rx, 50, 1, 1, 1)
  bold:write(0, 50, tx, 50, 1, 1, 1)
end

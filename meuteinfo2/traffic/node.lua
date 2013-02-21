gl.setup(880, 300)

util.auto_loader(_G)

node.alias("traffic")

local rx, tx

local LowPass = {}

function LowPass:new()
      o = {history = {}, level = 30}
      setmetatable(o, self)
      self.__index = self
 
      return o
end
 
local function average(t)
    local s = 0
    for i = 1, #t do
        s = s + t[i]
    end
    return s / #t
end
 
function LowPass:filter(value)
    table.insert(self.history, value)
    if #self.history > self.level then
        table.remove(self.history, 1)
    end

    return average(self.history)
end

rx = 0
tx = 0

METERMAX = 50 -- Mbps

rxlp = LowPass:new()
txlp = LowPass:new()

SCALE = 8/1024/1024

node.event("data", function (data, suffix) 
  if suffix == "rx" then
    rx = tonumber(data)*SCALE
    rx = rxlp:filter(rx)
  end
  if suffix == "tx" then 
    tx = tonumber(data)*SCALE
    tx = txlp:filter(tx)
  end
end)

function draw_hand(x, y, alpha)
  gl.pushMatrix()
  gl.translate(x, y)
  gl.rotate(alpha*180, 0, 0, 1)
  gl.rotate(-90, 0, 0, 1)
  hand:draw(-10, -190, 10, 50)
  gl.popMatrix()
end

local oldrxangle = 0
local oldtxangle = 0

function node.render()
  rxangle = math.min(rx/METERMAX, 1)
  txangle = math.min(tx/METERMAX, 1)

  rxjitter = 0
  txjitter = 0

  if rx/METERMAX > 1 then
    rxjitter = (0.5 - math.random()) * (rx-METERMAX)/(2*METERMAX) / 100
  end

  if tx/METERMAX > 1 then
    txjitter = (0.5 - math.random()) * (tx-METERMAX)/(2*METERMAX) / 100
  end

  draw_hand(220, 220, rxangle+rxjitter)
  draw_hand(660, 220, txangle+txjitter)

  bold:write(190, 20, "RX", 50, 0, 1, 0.5)
  bold:write(630, 20, "TX", 50, 0, 1, 0.5)
end

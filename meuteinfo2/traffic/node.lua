gl.setup(980, 480)

util.auto_loader(_G)

node.alias("traffic")

local rx, tx

local LowPass = {}

function LowPass:new()
      o = {history = {}, level = 10}
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

METERMAX = 100 -- Mbps

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
  gl.rotate(alpha*300, 0, 0, 1)
  gl.rotate(-150, 0, 0, 1)
  hand:draw(-10, -190, 10, 50)
  gl.popMatrix()
end

local rxv = 0
local txv = 0

local alpha = 0.2

local oldtime = sys.now()

function center_text(x, y, text, h, r, g, b, a)
  w = regular:write(-10000, -10000, text, h, r, g, b, a)
  regular:write(x - w/2, y, text, h, r, g, b, a)
end

function node.render()
  newtime = sys.now()
  dtime = newtime - oldtime
  oldtime = newtime

  rxv = rxv + (rx - rxv) * dtime * alpha
  txv = txv + (tx - txv) * dtime * alpha

  rxangle = math.min(rxv/METERMAX, 1)
  txangle = math.min(txv/METERMAX, 1)

  rxjitter = 0
  txjitter = 0

  if rx/METERMAX > 1 then
    rxjitter = (0.5 - math.random()) * (rxv-METERMAX)/(2*METERMAX) / 100
  end

  if tx/METERMAX > 1 then
    txjitter = (0.5 - math.random()) * (txv-METERMAX)/(2*METERMAX) / 100
  end

  bold:write(190, 20, "RX", 50, 0, 1, 0.5)
  bold:write(630, 20, "TX", 50, 0, 1, 0.5)

  dial:draw(0, 0, 480, 480)
  dial:draw(500, 0, 980, 480)

  rxround = math.floor(rxv + 0.5)
  txround = math.floor(txv + 0.5)

  center_text(240, 270, rxround, 70, 0, 0, 0)
  center_text(240, 270+80, "Mbps", 50, 0, 0, 0)
  center_text(240, 270-130, "Down", 50, 0, 0, 0)
  center_text(740, 270, txround, 70, 0, 0, 0)
  center_text(740, 270+80, "Mbps", 50, 0, 0, 0)
  center_text(740, 270-130, "Up", 50, 0, 0, 0)

  draw_hand(240, 240, rxangle+rxjitter)
  draw_hand(740, 240, txangle+txjitter)
end

gl.setup(1280, 1024)

local BORDER = 50

o = 500

function node.render()
  resource.render_child("webcams"):draw(0, 0, WIDTH, HEIGHT)
  resource.render_child("traffic"):draw(WIDTH - 980*0.50 - 20, 20, WIDTH-20, 480 * 0.5 + 20)
  resource.render_child("weather"):draw(BORDER, BORDER, BORDER + 320, BORDER + 240)
  resource.render_child("meutestatus"):draw(0, HEIGHT-300, WIDTH, HEIGHT)
end

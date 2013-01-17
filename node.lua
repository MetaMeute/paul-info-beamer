gl.setup(1280, 1024)

util.auto_loader(_G)

meutelogo = resource.load_image("meutelogo.png")

local BORDER = 50

function node.render()
  gl.clear(math.cos((sys.now()+42589)/7)*0.2, math.sin((sys.now()+199933)/23)*0.3, math.cos(sys.now()+999331)*0.2, 1)

  resource.render_child("mpd-status"):draw(BORDER, BORDER, WIDTH - BORDER, BORDER + 140)

  resource.render_child("wetterkarte"):draw(BORDER, BORDER + 2 * 70, 520 + BORDER, 571 + BORDER + 2 * 70)
  resource.render_child("webcams"):draw(WIDTH - BORDER - 640, BORDER + 2 * 70, WIDTH - BORDER, BORDER + 480 + 2 * 70) 

  resource.render_child("digitalclock"):draw(WIDTH - BORDER - 540, HEIGHT - BORDER - 200, WIDTH - BORDER, HEIGHT - BORDER)

  gl.pushMatrix()
  gl.translate(226+BORDER, HEIGHT - BORDER - 64, 0)
  meutelogo:draw(-226, -64, 226, 64)
  gl.popMatrix()
end

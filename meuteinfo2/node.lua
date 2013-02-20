gl.setup(1280, 1024)

local BORDER = 50

o = 500

function node.render()
  resource.render_child("webcams"):draw(0, 0, WIDTH, HEIGHT)
  resource.render_child("meutestatus"):draw(0, HEIGHT-300, WIDTH, HEIGHT)
end

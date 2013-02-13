gl.setup(1280, 1024)

local BORDER = 50

function node.render()
  resource.render_child("webcams"):draw(0, 0, WIDTH, HEIGHT)
end

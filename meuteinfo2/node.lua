gl.setup(1280, 1024)

local BORDER = 50

function node.render()
  gl.clear(math.cos((sys.now()+42589)/7)*0.2, math.sin((sys.now()+199933)/23)*0.3, math.cos(sys.now()+999331)*0.2, 1)
  resource.render_child("busfahrplan"):draw(BORDER, BORDER, 1180 + BORDER, 924 + BORDER)
end

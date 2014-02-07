gl.setup(2*1280, 1024)

util.auto_loader(_G)

function node.render()
  resource.render_child("meuteinfo2"):draw(0*1280, 0, 1*1280, 1024)
  resource.render_child("meuteinfo"):draw(1*1280, 0, 2*1280, 1024)
end

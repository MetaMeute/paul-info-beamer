gl.setup(2560, 1024)

util.auto_loader(_G)

function node.render()
  resource.render_child("meuteinfo"):draw(1280, 0, 2560, 1024)
end

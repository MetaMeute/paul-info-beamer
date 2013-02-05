gl.setup(2560, 1024)

util.auto_loader(_G)

vnc = resource.create_vnc("127.0.0.1", 5901)

function node.render()
  resource.render_child("meuteinfo"):draw(1280, 0, 2560, 1024)
  vnc:draw(0, 0, 1280, 1024)
end

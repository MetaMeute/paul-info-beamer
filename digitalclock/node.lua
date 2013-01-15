gl.setup(540, 200)

util.auto_loader(_G)

function node.render()
  bold:write(0, 100, os.date("%X"), 114, 1,1,1,1)
  bold:write(0, 0, os.date("%A"), 50, 1, 1, 1, 1)
  bold:write(0, 50, os.date("%d. %B %Y"), 50, 1, 1, 1, 1)
end

local textures = {
  k = lovr.graphics.newTexture('art/blockK.png'),
  e = lovr.graphics.newTexture('art/blockE.png'),
  y = lovr.graphics.newTexture('art/blockY.png')
}

local cubeFace = lovr.graphics.newMesh({
  { -.25, .25, 0, 0,0,0, 0, 0 },
  { .25, .25, 0, 0,0,0, 1, 0 },
  { -.25, -.25, 0, 0,0,0, 0, 1 },
  { .25, -.25, 0, 0,0,0, 1, 1 }
}, 'strip')

-- DAMMIT
return function(letter)
  g.setColor(255, 255, 255)
  cubeFace:setTexture(textures[letter])

  g.push()
  g.rotate(0, 0, 1, 0)
  g.translate(0, 0, .25)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(math.pi / 2, 0, 1, 0)
  g.translate(0, 0, .25)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(math.pi, 0, 1, 0)
  g.translate(0, 0, .25)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(3 * math.pi / 2, 0, 1, 0)
  g.translate(0, 0, .25)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(math.pi / 2, 1, 0, 0)
  g.translate(0, 0, .25)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(-math.pi / 2, 1, 0, 0)
  g.translate(0, 0, .25)
  cubeFace:draw()
  g.pop()
end

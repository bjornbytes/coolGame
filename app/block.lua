local textures = {
  k = lovr.graphics.newTexture('art/blockK.png'),
  e = lovr.graphics.newTexture('art/blockE.png'),
  y = lovr.graphics.newTexture('art/blockY.png')
}

local cubeFace = lovr.graphics.newBuffer({
  { -.5, .5, 0, 0,0,0, 0, 0 },
  { .5, .5, 0, 0,0,0, 1, 0 },
  { -.5, -.5, 0, 0,0,0, 0, 1 },
  { .5, -.5, 0, 0,0,0, 1, 1 }
}, 'strip')

-- DAMMIT
return function(letter)
  cubeFace:setTexture(textures[letter])

  g.push()
  g.rotate(0, 0, 1, 0)
  g.translate(0, 0, .5)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(math.pi / 2, 0, 1, 0)
  g.translate(0, 0, .5)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(math.pi, 0, 1, 0)
  g.translate(0, 0, .5)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(3 * math.pi / 2, 0, 1, 0)
  g.translate(0, 0, .5)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(math.pi / 2, 1, 0, 0)
  g.translate(0, 0, .5)
  cubeFace:draw()
  g.pop()

  g.push()
  g.rotate(-math.pi / 2, 1, 0, 0)
  g.translate(0, 0, .5)
  cubeFace:draw()
  g.pop()
end


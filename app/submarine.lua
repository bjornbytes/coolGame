local submarine = {}
local vec3 = require('lib/cpml').vec3

function submarine:init()
  self.position = vec3.zero
  self.floor = lovr.graphics.newBuffer(lovr.headset.getBoundsGeometry())
  self.periscope = {}
  self.periscope.pos = vec3(0, 2.5, -1)
  self.periscope.size = .2
end

function submarine:draw()
  lovr.graphics.push()
  lovr.graphics.translate(self.position:unpack())

  -- Floor
  self.floor:draw()

  -- Periscope
  local x, y, z = self.periscope.pos:unpack()
  lovr.graphics.cube('fill', x, y, z, self.periscope.size)

  lovr.graphics.pop()
end

return submarine

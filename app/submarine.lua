local submarine = {}
local vec3 = require('lib/cpml').vec3

function submarine:init()
  self.position = vec3.zero
  self.floor = lovr.graphics.newBuffer(lovr.headset.getBoundsGeometry())
end

function submarine:draw()
  lovr.graphics.push()
  lovr.graphics.translate(self.position:unpack())
  self.floor:draw()
  lovr.graphics.pop()
end

return submarine

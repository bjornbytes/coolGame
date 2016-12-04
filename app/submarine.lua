local submarine = {}
local controllers = require('app/controllers')
local vec3 = require('lib/cpml').vec3

function submarine:init()
  self.position = vec3.zero
  self.floor = lovr.graphics.newBuffer(lovr.headset.getBoundsGeometry())
  self.periscope = {}
  self.periscope.pos = vec3(0, 2.5, -1)
  self.periscope.size = .2
end

function submarine:update(dt)
  local controller = controllers.list[1]
  if controller then
    local x, y, z = controller:getPosition()
    local trigger = controller:getAxis('trigger')
    local dist = self.periscope.pos:dist(vec3(x, y, z))
    local isGrabbed = dist < self.periscope.size and trigger > .8
    local targetY = isGrabbed and _.clamp(y, 1.5, 2.5) or 2.5
    local factor = (isGrabbed and 20 or 5) * dt
    self.periscope.pos.y = _.lerp(self.periscope.pos.y, math.min(factor, 1))
  end
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

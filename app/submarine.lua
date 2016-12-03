local submarine = {}
local controllers = require('app/controllers')
local vec3 = require('lib/cpml').vec3

function submarine:init()
  self.position = vec3.zero
  self.floor = lovr.graphics.newBuffer(lovr.headset.getBoundsGeometry())
  self.periscope = {}
  self.periscope.pos = vec3(0, 2.5, -1)
  self.periscope.size = .2
  self.periscope.grabbed = false
end

function submarine:update(dt)
  local controller = controllers.list[1]
  if controller then
    local x, y, z = controller:getPosition()
    local dist = self.periscope.pos:dist(vec3(x, y, z))

    self.periscope.grabbed = dist < self.periscope.size and controller:getAxis('trigger') > .5

    if self.periscope.grabbed then
      self.periscope.pos.y = _.lerp(self.periscope.pos.y, _.clamp(y, 1.5, 2.5), math.min(20 * dt, 1))
    end
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

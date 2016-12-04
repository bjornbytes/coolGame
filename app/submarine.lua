local submarine = {}
local controllers = require('app/controllers')
local vec3 = require('lib/cpml').vec3

local deadzone = .8

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
    local trigger = controller:getAxis('trigger')
    local dist = self.periscope.pos:dist(vec3(x, y, z))
    if self.periscope.isGrabbed then
      if trigger < deadzone or dist > 1 then
        self.periscope.isGrabbed = false
      else
        local targetY = _.clamp(y, 1.5, 2.5)
        self.periscope.pos.y = _.lerp(self.periscope.pos.y, targetY, math.min(20 * dt, 1))
      end
    else
      if dist < self.periscope.size and trigger > deadzone then
        self.periscope.isGrabbed = true
      else
        local targetY = 2.5
        self.periscope.pos.y = _.lerp(self.periscope.pos.y, targetY, math.min(5 * dt, 1))
      end
    end
  end
end

function submarine:draw()
  g.push()
  g.translate(self.position:unpack())

  -- Floor
  g.setColor(0, 0, 0)
  self.floor:draw()

  -- Periscope
  local x, y, z = self.periscope.pos:unpack()
  g.cube('fill', x, y, z, self.periscope.size)

  g.pop()
end

return submarine

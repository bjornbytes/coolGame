local rattle = {}
local controllers = require 'app/controllers'
local vec3 = require('lib/cpml').vec3

rattle.model = lovr.graphics.newModel('art/rattle.obj')
rattle.model:setTexture(lovr.graphics.newTexture('art/rattle_DIFF.png'))

function rattle:init()
  self.lastPosition = nil
  self.shake = 0
end

function rattle:update(dt)
  local controller = controllers.list[1]

  if controller then
    local pos = vec3(controller:getPosition())

    if self.lastPosition then
      local delta = pos - self.lastPosition
      self.shake = _.lerp(self.shake, delta:len() * 2, 6 * dt)
      self.isShaking = self.shake > .035
      if self.isShaking then
        controller:vibrate(math.min((self.shake - .035) / 15, .003))
      end
    end

    self.lastPosition = pos
  end
end

function rattle:draw()
  local controller = controllers.list[1]

  if controller then
    local x, y, z = controller:getPosition()
    local angle, ax, ay, az = controller:getOrientation()
    lovr.graphics.setColor(255, 255, 255)
    -- lovr.graphics.cube('line', x, y, z, .1 + self.shake * 4, -angle, ax, ay, az)
    self.model:draw(x, y, z, .01 + self.shake * .015, -angle, ax, ay, az)
  end
end

return rattle

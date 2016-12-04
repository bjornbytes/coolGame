local rattle = {}
local controllers = require 'app/controllers'
local vec3 = require('lib/cpml').vec3

rattle.model = lovr.graphics.newModel('art/rattle.obj')
rattle.model:setTexture(lovr.graphics.newTexture('art/rattle_DIFF.png'))

function rattle:init()
  self.lastPosition = nil
  self.lastVelocity = nil
  self.shake = 0
end

function rattle:update(dt)
  local controller = controllers.list[1]

  if controller then
    local pos = vec3(controller:getPosition())

    if self.lastPosition then
      local velocity = pos - self.lastPosition

      if self.lastVelocity then
        local acceleration = (velocity - self.lastVelocity):len()
        self.shake = _.lerp(self.shake, acceleration, math.min(16 * dt, 1))
        self.isShaking = self.shake > .035
        if self.isShaking then
          controller:vibrate(math.min((self.shake - .035) / 10, .0035))
        end
      end

      self.lastVelocity = velocity
    end

    self.lastPosition = pos
  end
end

function rattle:draw()
  local controller = controllers.list[1]
  local levels = { require('app/cry'), require('app/sleep'), require('app/play') }

  if controller then
    local x, y, z = controller:getPosition()
    local angle, ax, ay, az = controller:getOrientation()
    lovr.graphics.setColor(255, 255, 255)
    if _.all(levels, 'won') then
      -- TODO Draw keyblade
      self.model:draw(x, y, z, .01 + self.shake * .025, -angle, ax, ay, az)
    else
      self.model:draw(x, y, z, .01 + self.shake * .025, -angle, ax, ay, az)
    end
  end
end

return rattle

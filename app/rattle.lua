local rattle = {}
local controllers = require 'app/controllers'
local vec3 = require('cpml').vec3

rattle.model = lovr.graphics.newModel('art/rattle.obj')
rattle.model:setMaterial(lovr.graphics.newMaterial('art/rattle_DIFF.png'))

rattle.keyblade = lovr.graphics.newModel('art/keyblade.obj')

function rattle:init()
  self.lastPosition = nil
  self.lastVelocity = nil
  self.shake = 0
end

function rattle:update(dt)
  local controller = controllers.list[1]
  local levels = { require('app/cry'), require('app/sleep'), require('app/play') }

  if controller and not _.all(levels, 'won') then
    local pos = vec3(controller:getPosition())

    if self.lastPosition then
      local velocity = pos - self.lastPosition

      if self.lastVelocity then
        local acceleration = (velocity - self.lastVelocity):len()
        self.shake = _.lerp(self.shake, acceleration, math.min(16 * dt, 1))
        self.isShaking = self.shake > .006
        if self.isShaking then
          controller:vibrate(math.min((self.shake - .006) / 4, .0035))
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
    lovr.graphics.setColor(1, 1, 1)
    if _.all(levels, 'won') then
      -- TODO Draw keyblade
      self.keyblade:draw(x, y, z, .75, angle, ax, ay, az)
    else
      self.model:draw(x, y, z, .01 + self.shake * .025, angle, ax, ay, az)
    end
  end
end

return rattle

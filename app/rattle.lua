local rattle = {}
local controllers = require 'app/controllers'
local vec3 = require('lib/cpml').vec3

function rattle:init()
  self.lastPosition = {}
  self.velocity = 0
end

function rattle:update(dt)
  local controller = controllers.list[1]

  if controller then
    local pos = vec3(controller:getPosition())

    if self.lastPosition then
      local delta = pos - self.lastPosition
      print(delta)
      self.lastPosition = pos
    else
      self.lastPosition = pos
    end
  end
end

function rattle:draw()
  local controller = controllers.list[1]

  if controller then
    local x, y, z = controller:getPosition()
    local angle, ax, ay, az = controller:getOrientation()
    lovr.graphics.setColor(255, 255, 255)
    lovr.graphics.cube('line', x, y, z, .2, -angle, ax, ay, az)
  end
end

return rattle

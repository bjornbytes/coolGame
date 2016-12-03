local veggie = {}
veggie.__index = veggie
veggie.model = lovr.graphics.newModel('art/duck.dae')
veggie.model:setTexture(lovr.graphics.newTexture('art/duck.tga'))

local vec3 = require('lib/cpml').vec3
local quat = require('lib/cpml').quat

function veggie.grow(position)
  local self = {}

  self.position = position
  self.direction = vec3(0, 0, 0) - position -- player position - my postiion
  self.speed = _.random(.15, .2)
  local quat = quat.from_direction(self.direction, vec3(0, 1, 0))
  self.angle, self.axis = quat.to_angle_axis(quat)

  return setmetatable(self, veggie)
end

function veggie:update(dt)
  self.position = self.position + self.direction * dt * self.speed
end

function veggie:draw()
  local x, y, z = vec3.unpack(self.position)
  local ax, ay, az = vec3.unpack(self.axis)
  self.model:draw(x, y, z, .1, self.angle, ax, ay, az)
end

return veggie

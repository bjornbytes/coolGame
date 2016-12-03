local veggie = {}
veggie.__index = veggie

local vec3 = require('lib/cpml').vec3

function veggie.grow(position)
  local self = {}

  self.position = position
  self.direction = vec3(0, 0, 0) - position -- player position - my postiion

  return setmetatable(self, veggie)
end

function veggie:update(dt)
  self.position = self.position + self.direction * dt
end

function veggie:draw()
  local x, y, z = vec3.unpack(self.position)
  lovr.graphics.cube('fill', x, y, z, .2)
end

return veggie

local shape = {}
shape.__index = shape

local vec3 = require('lib/cpml').vec3
local quat = require('lib/cpml').quat

local squareModel = lovr.graphics.newModel('art/duck.dae')
squareModel:setTexture(lovr.graphics.newTexture('art/duck.tga'))

local circleModel = lovr.graphics.newModel('art/mobile_plane.obj')
circleModel:setTexture(lovr.graphics.newTexture('art/mobile_DIFF.png'))

function shape.grow(position, type)
  local self = {}

  self.type = type
  self.position = position

  if self.type == 'square' then
    self.model = squareModel
  else
    self.model = circleModel
  end

  self.direction = vec3(0, 0, 0) - position -- player position - my postiion
  self.speed = _.random(.15, .2)
  local quat = quat.from_direction(self.direction, vec3(0, 1, 0))
  self.angle, self.axis = quat.to_angle_axis(quat)

  return setmetatable(self, shape)
end

function shape:update(dt)
  self.position = self.position + self.direction * dt * self.speed
end

function shape:draw()
  local x, y, z = vec3.unpack(self.position)
  local ax, ay, az = vec3.unpack(self.axis)
  self.model:draw(x, y, z, .1, self.angle, ax, ay, az)
end

return shape

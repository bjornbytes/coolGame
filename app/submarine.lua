local submarine = {}
local vec3 = require('lib/cpml').vec3
local quat = require('lib/cpml').quat

function submarine:init()
  self.direction = { 0, 0, 0, 0 }
  self.position = vec3.zero
end

function submarine:update(dt)
  self.direction = quat.from_angle_axis(lovr.headset.getOrientation()) * vec3(0, 0, -1)
  self.position = self.position + self.direction * dt
end

return submarine

local cry = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local vec3 = require('lib/cpml').vec3
local quat = require('lib/cpml').quat

function cry:init()
  self.skybox = g.newSkybox(
    'art/skyboxes/sea_ft.jpg',
    'art/skyboxes/sea_bk.jpg',
    'art/skyboxes/sea_up.jpg',
    'art/skyboxes/sea_dn.jpg',
    'art/skyboxes/sea_rt.jpg',
    'art/skyboxes/sea_lf.jpg'
  )

  self.floor = g.newBuffer(lovr.headset.getBoundsGeometry())

  self.block = {}
  self.block.position = vec3(0, 0, -8)
  self.block.size = .2

  self.transitionFactor = 0

  rattle:init()
end

function cry:update(dt)
  rattle:update(dt)

  if rattle.isShaking then
    local blockDirection = self.block.position - vec3(lovr.headset.getPosition())
    local a, rx, ry, rz = lovr.headset.getOrientation()
    local playerDirection = quat.from_angle_axis(a, vec3(rx, ry, rz)) * vec3.unit_z
    local factor = vec3.dot(blockDirection, playerDirection)
    block.position.z = self.block.position.z + factor * dt * 2
  end

  -- Win
  local controller = controllers.list[1]
  local trigger = controller and controller:getAxis('trigger')
  local dist = controller and vec3(controller:getPosition()):dist(self.block.position) or math.huge
  if controller and trigger < .9 and dist < self.block.size / 2 then
    self.transitionFactor = math.min(self.transitionFactor + dt, 1)

    if self.transitionFactor > 0 then
     controller:vibrate(self.transitionFactor^2 * .0035)
    end

    if self.transitionFactor >= 1 then
      -- YOU WIN
      local menu = require 'app/menu'
      setState(menu)
    end
  else
    self.transitionFactor = math.max(self.transitionFactor - dt, 0)
  end
end

function cry:draw()
  local a, rx, ry, rz = lovr.headset.getOrientation()
  g.setColor(255, 255, 255)
  self.skybox:draw(a, rx, ry, rz)

  rattle:draw()

  g.setColor(255, 255, 255, 80)
  self.floor:draw()

  local x, y, z = self.block.position:unpack()
  g.setColor(128, 0, 255)
  g.cube('fill', x, y, z, self.block.size)

  drawTransition(self.transitionFactor)
end

return cry

local cry = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local vec3 = require('lib/cpml').vec3
local quat = require('lib/cpml').quat
local drawBlock = require('app/block')

cry.won = false

function cry:init()
  self.skybox = g.newTexture(
    'art/skyboxes/sea_ft.jpg',
    'art/skyboxes/sea_bk.jpg',
    'art/skyboxes/sea_up.jpg',
    'art/skyboxes/sea_dn.jpg',
    'art/skyboxes/sea_rt.jpg',
    'art/skyboxes/sea_lf.jpg'
  )

  self.floor = g.newMesh(lovr.headset.getBoundsGeometry())

  self.block = {}
  self.block.position = vec3(0, 1, -4)
  self.block.size = .5

  self.transitionFactor = 0

  rattle:init()
end

function cry:update(dt)
  rattle:update(dt)

  self.block.position.x = math.sin(lovr.timer.getTime()) * self.block.position.z / 5

  if rattle.isShaking then
    local blockDirection = self.block.position - vec3(lovr.headset.getPosition())
    local a, rx, ry, rz = lovr.headset.getOrientation()
    local playerDirection = quat.from_angle_axis(a, vec3(rx, ry, rz)) * vec3.unit_z
    local factor = vec3.dot(blockDirection, playerDirection)
    self.block.position.z = _.clamp(self.block.position.z + factor * dt * .5, -5, .2)
  end

  -- Win
  local controller = controllers.list[1]
  local trigger = controller and controller:getAxis('trigger')
  local dist = controller and vec3(controller:getPosition()):dist(self.block.position) or math.huge
  if controller and trigger > .9 and dist < self.block.size then
    self.transitionFactor = math.min(self.transitionFactor + dt, 1)

    if self.transitionFactor > 0 then
     controller:vibrate(self.transitionFactor^2 * .0035)
    end

    if self.transitionFactor >= 1 then
      self.won = true
      local menu = require 'app/menu'
      setState(menu)
    end
  else
    self.transitionFactor = math.max(self.transitionFactor - dt, 0)
  end
end

function cry:draw()
  local a, rx, ry, rz = lovr.headset.getOrientation()
  g.setColor(1, 1, 1)
  g.skybox(self.skybox, -a, rx, ry, rz)

  rattle:draw()

  g.setColor(1, 1, 1, 80 / 255)
  self.floor:draw()

  local x, y, z = self.block.position:unpack()
  g.push()
  g.translate(x, y, z)
  drawBlock('k')
  g.pop()

  drawTransition(self.transitionFactor)
end

return cry

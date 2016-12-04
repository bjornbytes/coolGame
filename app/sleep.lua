local sleep = {}
local controllers = require('app/controllers')
local rattle = require('app/rattle')
local vec3 = require('lib/cpml').vec3

function sleep:init()
  self.skybox = g.newSkybox(
    'art/skyboxes/stormydays_ft.tga',
    'art/skyboxes/stormydays_bk.tga',
    'art/skyboxes/stormydays_up.tga',
    'art/skyboxes/stormydays_dn.tga',
    'art/skyboxes/stormydays_rt.tga',
    'art/skyboxes/stormydays_lf.tga'
  )

  self.floor = g.newBuffer(lovr.headset.getBoundsGeometry())

  self.block = {}
  self.block.maxY = 10
  self.block.position = vec3(0, self.block.maxY, 0)
  self.block.size = .2

  self.transitionFactor = 0

  rattle:init()
end

function sleep:update(dt)
  rattle:update(dt)

  -- Logic
  if rattle.isShaking then
    local x, y, z = lovr.headset.getPosition()
    local factor = (1 - _.clamp(y / 2, 0, 1)) ^ 3
    self.block.position.y = math.max(self.block.position.y - dt * factor * 2, 1)
  else
    self.block.position.y = math.min(self.block.position.y + dt * .5, self.block.maxY)
  end

  -- Win
  local controller = controllers.list[1]
  local trigger = controller and controller:getAxis('trigger')
  local dist = controller and vec3(controller:getPosition()):dist(self.block.position)
  if controller and trigger > .5 and dist < self.block.size then
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

function sleep:draw()
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

return sleep

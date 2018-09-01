local sleep = {}
local controllers = require('app/controllers')
local rattle = require('app/rattle')
local vec3 = require('cpml').vec3
local drawBlock = require('app/block')

sleep.won = false

function sleep:init()
  self.skybox = g.newTexture(
    'art/skyboxes/gg_ft.jpg',
    'art/skyboxes/gg_bk.jpg',
    'art/skyboxes/gg_up.jpg',
    'art/skyboxes/gg_dn.jpg',
    'art/skyboxes/gg_rt.jpg',
    'art/skyboxes/gg_lf.jpg'
  )

  local w, d = lovr.headset.getBoundsDimensions()
  self.floor = g.newMesh({{ -w, 0, -d }, { -w, 0, d }, { w, 0, -d }, { w, 0, d }}, 'strip')

  self.block = {}
  self.block.maxY = 6
  self.block.position = vec3(0, self.block.maxY, 0)
  self.block.size = .5

  self.transitionFactor = 0

  rattle:init()
end

function sleep:update(dt)
  rattle:update(dt)

  -- Logic
  if rattle.isShaking then
    local x, y, z = lovr.headset.getPosition()
    local factor = (1 - _.clamp(y / 2.2, 0, 1)) ^ 2
    self.block.position.y = math.max(self.block.position.y - dt * factor * 2, .5)
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
      self.won = true
      local menu = require 'app/menu'
      setState(menu)
    end
  else
    self.transitionFactor = math.max(self.transitionFactor - dt, 0)
  end
end

function sleep:draw()
  local a, rx, ry, rz = lovr.headset.getOrientation()
  g.setColor(1, 1, 1)
  g.skybox(self.skybox, -a, rx, ry, rz)

  rattle:draw()

  g.setColor(1, 1, 1, 80 / 255)
  self.floor:draw()

  local x, y, z = self.block.position:unpack()
  g.push()
  g.translate(x, y, z)
  drawBlock('e')
  g.pop()

  drawTransition(self.transitionFactor)
end

return sleep

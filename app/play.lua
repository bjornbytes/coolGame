local sleep = {}
local controllers = require('app/controllers')
local rattle = require('app/rattle')
local vec3 = require('lib/cpml').vec3
local drawBlock = require('app/block')

sleep.won = false

function sleep:init()
  self.skybox = g.newSkybox(
    'art/skyboxes/bluecloud_ft.jpg',
    'art/skyboxes/bluecloud_bk.jpg',
    'art/skyboxes/bluecloud_up.jpg',
    'art/skyboxes/bluecloud_dn.jpg',
    'art/skyboxes/bluecloud_rt.jpg',
    'art/skyboxes/bluecloud_lf.jpg'
  )

  self.floor = g.newBuffer(lovr.headset.getBoundsGeometry())

  self.blocks = {}
  for i = 1, 4 do
    local position

    if i == 1 then
      position = { -1, 1.5, 0 }
    elseif i == 2 then
      position = { 1, 1.5, 0 }
    elseif i == 3 then
      position = { 0, 1.5, -1 }
    else
      position = { 0, 1.5, 1 }
    end

    local block = {}
    block.maxY = 6
    block.position = vec3(unpack(position))
    block.size = .5
    block.angle = 1
    block.win = i == 4
    self.blocks[i] = block
  end

  self.transitionFactor = 0

  rattle:init()
end

function sleep:update(dt)
  rattle:update(dt)

  -- Logic
  if rattle.isShaking then
    _.each(self.blocks, function(block)
      block.angle = block.angle + dt
    end)
  end

  -- Win
  local controller = controllers.list[1]
  local trigger = controller and controller:getAxis('trigger')
  local isWinning = false
  _.each(self.blocks, function(block)

    local dist = controller and vec3(controller:getPosition()):dist(block.position)
    if controller and trigger > .5 and block.win and dist < .5 then
      isWinning = true
    end
  end)

  if controller and isWinning then
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
  g.setColor(255, 255, 255)
  self.skybox:draw(-a, rx, ry, rz)

  rattle:draw()

  g.setColor(255, 255, 255, 80)
  self.floor:draw()

  _.each(self.blocks, function(block)
    local x, y, z = block.position:unpack()
    g.push()
    g.translate(x, y, z)
    g.rotate(block.angle, 0, 1, 0)
    drawBlock('y')
    g.pop()
  end)

  drawTransition(self.transitionFactor)
end

return sleep

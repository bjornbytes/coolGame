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

  for i = 1, 3 do
    local block = {}
    block.maxY = 6
    block.position = vec3(0, 1.5, (2 * math.pi / 4) * i)
    block.size = .4
    block.angle = 1
    block.win = false
    blocks[i] = block
  end
  local block = {}
  block.maxY = 6
  block.position = vec3(0, 1.5, (2 * math.pi / 4) * 4)
  block.size = .4
  block.angle = 1
  block.win = true
  blocks[4] = self.block

  self.blocks = {}

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
  _.each(self.blocks, function(block)

    local dist = controller and vec3(controller:getPosition()):dist(block.position)
    if controller and trigger > .5 block.win and dist < block.size then
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
  end)
end

function sleep:draw()
  local a, rx, ry, rz = lovr.headset.getOrientation()
  g.setColor(255, 255, 255)
  self.skybox:draw(a, rx, ry, rz)

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

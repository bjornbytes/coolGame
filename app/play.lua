local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local shape = require 'app/shape'
local vec3 = require('lib/cpml').vec3


local play = {}

function play:init()
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

  self.holes = {}
  self.correctHole = {}
  self.shapes = {}
  self.currentShape = {}
  self.shapeTimer = 1


  self.transitionFactor = 0

  rattle:init()
  self:setHoles()
end

function play:update(dt)
  rattle:update(dt)
  self.currentShape = self.shapes[1]

  _.each(self.shapes, 'update', dt)

  -- Spawn shapes
  self.shapeTimer = self.shapeTimer - dt
  if self.shapeTimer <= 0 then
    self:spawnShape()
    self.shapeTimer = _.random(1, 2)
  end

  -- Destroy shapes outside map
  _.each(self.shapes, function(shape)
    if shape.position.y < -.1 then
      self:removeShape(shape)
    end
  end)

  if self.currentShape and self.currentShape.position.y == 0 then
    print('enter hole lawl')
    local x, y, z = unpack(self.currentShape.position)
    if x > self.correctHole.minX and x < self.correctHole.maxX and z > self.correctHole.minZ and z < self.correctHole.maxZ then
      print('move block')
      self:moveBlock()
    end
  end

  if rattle.isShaking then
    -- move first shape faster
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

function play:draw()
  local a, rx, ry, rz = lovr.headset.getOrientation()
  g.setColor(255, 255, 255)
  self.skybox:draw(a, rx, ry, rz)

  rattle:draw()
  _.each(self.shapes, 'draw')

  g.setColor(255, 255, 255, 80)
  self.floor:draw()

  _.each(self.holes, function(hole)
    lovr.graphics.setColor(hole.color)
    lovr.graphics.plane('fill', 0, 0, 0, 1.0, 0, 1, 0)
  end)

  local x, y, z = self.block.position:unpack()
  g.setColor(128, 0, 255)
  g.cube('fill', x, y, z, self.block.size)

  drawTransition(self.transitionFactor)
end

function play:shapeMatch()
  local isMatch = false
  -- if shape goes in 'hoop' -- later if correct shape goes in
    -- isMatch = true

end

function play:setHoles()
  self.holes = {
    square = {
      minX = -1,
      maxX = 1,
      minZ = -1,
      maxZ = 1,
      color = { 0, 0, 245 }
    }
  }
end

function play:moveBlock()
    local x, y, z = lovr.headset.getPosition()
    local factor = (1 - _.clamp(y / 2, 0, 1)) ^ 3
    self.block.position.z = math.max(self.block.position.z - dt * factor * 2, 1)
end

function play:spawnShape()
  local shapePosition = vec3(_.random(-1, 1), _.random(.5, 2), _.random(-5, -4))
  local shape = shape.grow(shapePosition, 'square')
  self.shapes[shape] = shape
end

function play:removeShape(shape)
  self.shapes[shape] = nil
end

return play

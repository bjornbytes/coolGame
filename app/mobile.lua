local controllers = require 'app/controllers'
local cry = require 'app/cry'
local sleep = require 'app/sleep'
local vec3 = require('lib/cpml').vec3
local mat4 = require('lib/cpml').mat4

local mobile = {}

function mobile:init()
  self.isEntered = false

  self.position = { 0, 11.5, 0 }
  self.size = 1
  self.rotateSpeed = .5
  self.angle = 3 * math.pi / 180
  self.model = lovr.graphics.newModel('art/mobile.obj')
  self.model:setTexture(lovr.graphics.newTexture('art/mobile_DIFF.png'))

  self.toys = {
    submarine = {
      scale = .5,
      position = { 0, self.position[2], 0 },
      isEntered = false,
      angle = 0,
      model = lovr.graphics.newModel('art/mobile_submarine.obj'),
      color = { 200, 0, 0 },
      target = cry
    },
    plane = {
      scale = .5,
      position = { 0, self.position[2], 0 },
      isEntered = false,
      angle = 0,
      model = lovr.graphics.newModel('art/mobile_plane.obj'),
      color = { 200, 200, 0 },
      target = sleep
    },
    balloon = {
      scale = .5,
      position = { 0, self.position[2], 0 },
      isEntered = false,
      angle = 0,
      model = lovr.graphics.newModel('art/mobile_submarine.obj'),
      color = { 0, 200, 200 },
      target = sleep
    }
  }

  self.numToys = _.count(self.toys)
  self.toySize = .25 -- hitbox, in meters
  self.toyTranslateZ = .5
  self.toyRotate = 2 * math.pi / self.numToys


  _.each(self.toys, function(toy)
    toy.model:setTexture(lovr.graphics.newTexture('art/mobile_DIFF.png'))
  end)

  self.transitionFactor = 0
end

function mobile:update(dt)
  self.angle = self.angle + dt * self.rotateSpeed
  self:handleToyInput(dt)

  local toyRotate = self.toyRotate
  _.each(self.toys, function(toy)

    -- Translate to parent
    local m = mat4.identity()
    m:translate(m, vec3(unpack(self.position)))
    m:rotate(m, self.angle, vec3(0, 1, 0))

    -- Shoot outwards from parent
    m:rotate(m, toyRotate, vec3(0, 1, 0))
    m:translate(m, vec3(0,  -10, self.toyTranslateZ))

    toy.position = { m[13], m[14], m[15] }
    toyRotate = toyRotate + self.toyRotate
  end)
end

function mobile:draw()
  local x, y, z = unpack(self.position)

  lovr.graphics.setColor(255, 255, 255)
  self.model:draw(x, y, z, self.size * .01, self.angle, 0, 1, 0)

  self:drawToys()
end

function mobile:drawToys()
  _.each(self.toys, function(toy)
    local x, y, z = unpack(toy.position)
    lovr.graphics.setColor(unpack(toy.color))
    lovr.graphics.setColor(255, 255, 255)
    toy.model:draw(x, y, z, toy.scale * .01, toy.angle, 0, 1, 0)
  end)

  drawTransition(self.transitionFactor)
end

function mobile.controllerInRange(basePos, size)
  local controller = controllers.list[1]
  if controller then
    local pos = vec3(controller:getPosition())
    local center = vec3(unpack(basePos))
    local distance = pos:dist(center)
    local radius = size

    return distance < radius and true or false
  end
end

function mobile:handleToyInput(dt)
  local controller = controllers.list[1]
  if not controller then return end

  local trigger = controller:getAxis('trigger')
  local activeToy = nil

  _.each(self.toys, function(toy)
    local wasEntered = toy.isEntered
    toy.isEntered = self.controllerInRange(toy.position, self.toySize)
    if toy.isEntered then
      toy.scale = _.lerp(toy.scale, .625, 8 * dt)
      toy.angle = toy.angle + dt
      activeToy = toy
    else
      toy.scale = _.lerp(toy.scale, .5, 8 * dt)
    end

    if wasEntered ~= toy.isEntered then
      controller:vibrate(.0035)
    end
  end)

  if activeToy and trigger > .9 then
    self.transitionFactor = math.min(self.transitionFactor + dt, 1)

    if self.transitionFactor > 0 then
      controller:vibrate(self.transitionFactor^2 * .0035)
    end

    if self.transitionFactor >= 1 then
      setState(activeToy.target)
    end
  else
    self.transitionFactor = math.max(self.transitionFactor - dt, 0)
  end

  self.isEntered = activeToy ~= nil
  self.rotateSpeed = _.lerp(self.rotateSpeed, self.isEntered and 0 or .5, 4 * dt)
end

return mobile

local controllers = require 'app/controllers'
local vec3 = require('cpml').vec3
local mat4 = require('cpml').mat4

local mobile = {}

function mobile:init()
  self.isEntered = false

  self.position = { 0, 11.8, 0 }
  self.size = 1
  self.rotateSpeed = .5
  self.angle = 3 * math.pi / 180
  self.model = lovr.graphics.newModel('art/mobile.obj')
  self.model:setMaterial(lovr.graphics.newMaterial('art/mobile_DIFF.png'))

  self.toys = {
    submarine = {
      scale = .5,
      position = { 0, 0, 0 },
      wonPosition = { -.75, .6, 2.2 },
      stringLength = 10,
      isEntered = false,
      angle = 0,
      angleNudge = -.59,
      model = lovr.graphics.newModel('art/mobile_submarine.obj'),
      color = { 200, 0, 0 }
    },
    plane = {
      scale = .5,
      position = { 0, self.position[2], 0 },
      wonPosition = { 0, .6, 2.2 },
      stringLength = 9.5,
      isEntered = false,
      angle = 0,
      angleNudge = .15,
      model = lovr.graphics.newModel('art/mobile_plane.obj'),
      color = { 200, 200, 0 }
    },
    balloon = {
      scale = .5,
      position = { 0, self.position[2], 0 },
      wonPosition = { .75, .6, 2.2 },
      stringLength = 9.8,
      isEntered = false,
      angle = 0,
      angleNudge = .25,
      model = lovr.graphics.newModel('art/mobile_balloon.obj'),
      color = { 0, 200, 200 }
    }
  }

  self.numToys = _.count(self.toys)
  self.toySize = .38 -- hitbox, in meters
  self.toyTranslateZ = .6
  self.toyRotate = 2 * math.pi / self.numToys

  _.each(self.toys, function(toy)
    toy.model:setMaterial(lovr.graphics.newMaterial('art/mobile_DIFF.png'))
  end)
end

function mobile:update(dt)
  self.angle = self.angle + dt * self.rotateSpeed
  self:handleToyInput(dt)

  local toyRotate = self.toyRotate
  _.each(self.toys, function(toy)

    -- Translate to parent, rotate according to mobile angle
    local m = mat4.identity()
    m:translate(m, vec3(unpack(self.position)))
    m:rotate(m, self.angle, vec3(0, 1, 0))

    -- Rotate so they are spread out evenly
    m:rotate(m, toyRotate + toy.angleNudge, vec3(0, 1, 0))

    -- Move down based on string length, shoot outwards a bit
    m:translate(m, vec3(0,  -toy.stringLength, self.toyTranslateZ))

    toy.position = { m[13], m[14], m[15] }
    toyRotate = toyRotate + self.toyRotate
  end)
end

function mobile:draw()
  local x, y, z = unpack(self.position)

  lovr.graphics.setColor(1, 1, 1)
  self.model:draw(x, y, z, self.size * .01, self.angle, 0, 1, 0)

  self:drawToys()
end

function mobile:drawToys()
  _.each(self.toys, function(toy)
    local x, y, z = unpack(toy.position)
    lovr.graphics.setColor(unpack(toy.color))
    lovr.graphics.setColor(1, 1, 1)
    toy.model:draw(x, y, z, toy.scale * .01, toy.angle, 0, 1, 0)
  end)
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
      toy.angle = toy.angle + dt / 2
    end

    if wasEntered ~= toy.isEntered then
      controller:vibrate(.0035)
    end
  end)

  self.isEntered = activeToy ~= nil
  self.rotateSpeed = _.lerp(self.rotateSpeed, self.isEntered and 0 or .5, 4 * dt)
end

return mobile

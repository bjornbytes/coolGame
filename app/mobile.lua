local controllers = require 'app/controllers'
local vec3 = require('lib/cpml').vec3
local mat4 = require('lib/cpml').mat4

local mobile = {}

function mobile:init()
  self.size = .5
  self.numToys = 4
  self.rotateSpeed = .5
  self.position = { 0, 2, 1 }
  self.angle = 3 * math.pi / 180

  self.isEntered = false

  self.toySize = self.size / 4
  self.toyRotate = 2 * math.pi / self.numToys
  self.toyTranslateZ = self.size / 2
  self.toys = {
    submarine = {
      scale = 1,
      position = { 0, 0, 0 },
      isEntered = false,
      angle = 0,
      color = { 200, 0, 0 }
    },
    plane = {
      scale = 1,
      position = { 0, 0, 0 },
      isEntered = false,
      angle = 0,
      color = { 200, 200, 0 }
    },
    train = {
      scale = 1,
      position = { 0, 0, 0 },
      isEntered = false,
      angle = 0,
      color = { 0, 200, 200 }
    },
    rocketship = {
      scale = 1,
      position = { 0, 0, 0 },
      isEntered = false,
      angle = 0,
      color = { 200, 0, 200 }
    }
  }
end

function mobile:update(dt)
  self.angle = self.angle + dt * self.rotateSpeed
  self:handMobileInput(dt)
  self:handleToyInput(dt)

  local toyRotate = self.toyRotate
  _.each(self.toys, function(toy)

    -- Translate to parent
    local m = mat4.identity()
    m:translate(m, vec3(unpack(self.position)))
    m:rotate(m, self.angle, vec3(0, 1, 0))

    -- Shoot outwards from parent
    m:rotate(m, toyRotate, vec3(0, 1, 0))
    m:translate(m, vec3(0, -.4, self.toyTranslateZ))

    toy.position = { m[13], m[14], m[15] }
    toyRotate = toyRotate + self.toyRotate
  end)
end

function mobile:draw()
  lovr.graphics.setWireframe(false)

  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.push()
  lovr.graphics.translate(unpack(self.position))
  lovr.graphics.rotate(self.angle, 0, 1, 0)
  lovr.graphics.cube('fill', 0, 0, 0, self.size)
  lovr.graphics.pop()

  self:drawToys()
end

function mobile:drawToys()
  local toySize = self.toySize

  _.each(self.toys, function(toy)
    local x, y, z = unpack(toy.position)
    lovr.graphics.setColor(unpack(toy.color))
    lovr.graphics.cube('fill', x, y, z, toySize * toy.scale, toy.angle, 0, 1, 0)
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

function mobile:handMobileInput(dt)
  local controller = controllers.list[1]
  if not controller then return end

  local wasEntered = self.isEntered
  self.isEntered = self.controllerInRange(self.position, self.size)
  self.rotateSpeed = _.lerp(self.rotateSpeed, self.isEntered and 0 or .5, 2 * dt)
  if not wasEntered and self.isEntered then controller:vibrate(.003) end
end

function mobile:handleToyInput(dt)
  local controller = controllers.list[1]
  if not controller then return end

  _.each(self.toys, function(toy)
    toy.isEntered = toy.controllerInRange(toy.position, self.toySize)
    if toy.isEntered then
      -- lerp scale
      toy.scale = _.lerp(toy.scale, 1.2, 8 * dt)
      -- vibrate
      controller:vibrate((math.sin(lovr.timer.getTime() * 4) / 2 + .5) * .0035)
      -- spin
      toy.angle = toy.angle + dt
      -- glow
      -- play sound effect
    else
      toy.scale = _.lerp(toy.scale, 1, 8 * dt)
    end
  end)
end

return mobile

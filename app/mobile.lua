local controllers = require 'app/controllers'
local vec3 = require('lib/cpml').vec3
local mat4 = require('lib/cpml').mat4

local mobile = {}

function mobile:init()
  self.angle = 3 * math.pi / 180
  self.size = .5
  self.position = { 0, 2, 1 }
  self.numToys = 4
  self.rotateSpeed = .5

  self.toySize = self.size / 4
  self.toyRotate = 2 * math.pi / self.numToys
  self.toyTranslateZ = self.size / 2
  self.toys = {
    submarine = {
      color = { 200, 0, 0 }
    },
    plane = {
      color = { 200, 200, 0 }
    },
    train = {
      color = { 0, 200, 200 }
    },
    rocketship = {
      color = { 200, 0, 200 }
    }
  }
end

function mobile:update(dt)
  self.angle = self.angle + dt * self.rotateSpeed
  self:speed(dt)
  self:handleToys(dt)
end

function mobile:draw()
  lovr.graphics.setWireframe(false)

  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.push()
  lovr.graphics.translate(unpack(self.position))
  lovr.graphics.rotate(self.angle, 0, 1, 0)
  lovr.graphics.cube('fill', 0, 0, 0, self.size)
  self:drawToys()
  lovr.graphics.pop()

  local testPos = unpack(self.toys.submarine.position)
  lovr.graphics.setColor(0, 0, 0)
  lovr.graphics.cube('fill', testPos, toySize + .1)
end

function mobile:drawToys()
  local toyRotate = self.toyRotate
  local toyTranslate = self.toyTranslateZ
  local toySize = self.toySize

  for k,v in pairs(self.toys) do
    local m = mat4.identity()
    m:translate(m, vec3(unpack(self.position)))
    m:rotate(m, self.angle, 0, 1, 0)

    local toy = v
    lovr.graphics.push()
    lovr.graphics.setColor(unpack(toy.color))
    lovr.graphics.rotate(toyRotate, 0, 1, 0)
    m:rotate(m, toyRotate, 0, 1, 0)
    lovr.graphics.translate(0, -.4, toyTranslate)
    m:translate(m, 0, -.4, toyTranslate)
    lovr.graphics.cube('fill', 0, 0, 0, toySize)

    toy.position = { m[13], m[14], m[15] }
    toyRotate = toyRotate + self.toyRotate
    lovr.graphics.pop()
  end
end

function mobile.controllerInRange(self, basePos, size)
  local controller = controllers.list[1]
  if controller then
    local pos = vec3(controller:getPosition())
    local center = vec3(unpack(basePos))
    local distance = controllerPos:dist(center)
    local radius = size

    return distance < radius and true or false
  end
end

function mobile:speed(dt)
  self.rotateSpeed = _.lerp(self.rotateSpeed, self.controllerInRange(self, self.position, self.size) and 0 or .5, 2 * dt)
end

return mobile

local mobile = {}

function mobile:init()
  self.angle = 3 * math.pi / 180
  self.size = .5
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
  self.angle = self.angle + dt * .5
end

function mobile:draw()
  lovr.graphics.setWireframe(false)

  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.push()
  lovr.graphics.translate(0, 2, 1)
  lovr.graphics.rotate(self.angle, 0, 1, 0)
  lovr.graphics.cube('fill', 0, 0, 0, self.size)
  self:drawToys()
  lovr.graphics.pop()
end

function mobile:drawToys()
  local toy = nil
  local toyRotate = self.toyRotate
  local toyTranslate = self.toyTranslateZ
  local toySize = self.toySize

  for k,v in pairs(self.toys) do
    toy = v
    lovr.graphics.push()
    lovr.graphics.setColor(unpack(toy.color))
    lovr.graphics.rotate(toyRotate, 0, 1, 0)
    lovr.graphics.translate(0, -.4, toyTranslate)
    lovr.graphics.cube('fill', 0, 0, 0, toySize)
    toyRotate = toyRotate + self.toyRotate
    lovr.graphics.pop()
  end
end

function mobile:speed(controllerPos)
  local center = vec3(0, 1, -2)
  local delta = contollerPos - center
  local l = delta:len()
  local radius = self.size / 2

  if (l < radius) then
    self.rotateSpeed = .05
  else
    self.rotateSpeed = .5
  end
end

return mobile

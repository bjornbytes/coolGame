local mobile = {}

function mobile:init()
  self.angle = 3 * math.pi / 180
  self.size = .5
  self.numToys = 4
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
  self.angle = self.angle + .05 * math.pi / 180
end

function mobile:draw()
  lovr.graphics.setWireframe(false)
  local toy = nil
  local toyRotate = self.toyRotate
  local toyTranslate = self.toyTranslateZ
  local toySize = self.toySize

  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.push()
  lovr.graphics.translate(0, 1, 2)
  lovr.graphics.rotate(self.angle, 0, 1, 0)
  lovr.graphics.cube('fill', 0, 0, 0, self.size)
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
  lovr.graphics.pop()
end

function mobile:drawToys()

end

return mobile

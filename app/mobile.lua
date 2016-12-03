local mobile = {}

-- local x1, y1, z1 = -1, 1, -5
-- local x2, y2, z2 = 0, 1, -5
-- local x3, y3, z3 = 1, 1, -5
local angle = 3 * math.pi / 180


function mobile:init()
  self.toys = {
    submarine = {
      x = 0,
      y = 1,
      z = -2,
      color = { 200, 0, 0 }
    }
  }
  t = 0
end

function mobile:update(dt)
  t = t + dt
  angle = angle + .2 * math.pi / 180
end

function mobile:draw()
  lovr.graphics.setWireframe(false)

  local size = 1 -- meter
  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.cube('fill', 0, 1, -2, size / 2, .5 + t / 2, 0, 1, 0)

  toy = self.toys.submarine
  toy.x = 0 + math.cos(angle)*.3;
  toy.z = -2 + math.sin(angle)*.3;
  lovr.graphics.setColor(unpack(toy.color))
  lovr.graphics.cube('fill', toy.x, toy.y, toy.z, size / 5, .5 + t / 2, 0, 1, 0)


  -- lovr.graphics.setColor(255, 155, 155)
  -- lovr.graphics.triangle('fill', x1, y1, z1, x2, y2, z2, x3, y3, z3)
end

function mobile:drawToys()

end

return mobile

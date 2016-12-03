local mobile = {}

local x1, y1, z1 = 0, 5, 2
local x2, y2, z2 = -1, 3, 2
local x3, y3, z3 = 1, 3, 2

function mobile:init()
  self.environment = lovr.graphics.newModel('art/roomTest.obj')
end

function mobile:update()

end

function mobile:draw()
  lovr.graphics.setBackgroundColor(50, 170, 190)
  self:drawEnvironment()

  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.triangle('fill', x1, y1, z1, x2, y2, z2, x3, y3, z3)
end

function mobile:drawEnvironment()
  lovr.graphics.setWireframe(true)
  self.environment:draw(0, 1, 0, .01)
end

return mobile

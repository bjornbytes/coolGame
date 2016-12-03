local sea = {}
local rattle = require 'app/rattle'

function sea:init()
  self.floor = lovr.graphics.newBuffer(lovr.headset.getBoundsGeometry())
  rattle:init()
end

function sea:update(dt)

  -- Update rattle
  rattle:update(dt)
end

function sea:draw()
  lovr.graphics.setBackgroundColor(0, 50, 100)
  rattle:draw()
  lovr.graphics.setColor(0, 0, 20)
  self.floor:draw()
end

return sea

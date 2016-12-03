local plane = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'

function plane:init()
  rattle:init()
end

function plane:update(dt)
  rattle:update(dt)
end

function plane:draw()
  lovr.graphics.setBackgroundColor(50, 250, 250)
  self:drawCockpit()
  rattle:draw()
end

function plane:drawCockpit()
  local size = 1 -- meter
  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.cube('line', 0, size / 2, 0, size)
end

return plane

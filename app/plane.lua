local plane = {}
local controllers = require 'app/controllers'

function plane:init()

end

function plane:update(dt)

end

function plane:draw()
  lovr.graphics.setBackgroundColor(50, 250, 250)
  self:drawCockpit()
  self:drawRattle()
end

function plane:drawCockpit()
  local size = 1 -- meter
  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.cube('line', 0, size / 2, 0, size)
end

function plane:drawRattle()
  -- Draw the rattle on the "first" controller
  local controller = controllers.list[1]

  if controller then
    local x, y, z = controller:getPosition()
    local angle, ax, ay, az = controller:getOrientation()
    lovr.graphics.setColor(255, 255, 255)
    lovr.graphics.cube('line', x, y, z, .2, -angle, ax, ay, az)
  end
end

return plane

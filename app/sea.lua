local sea = {}
local rattle = require 'app/rattle'

function sea:init()
  rattle:init()
end

function sea:update(dt)

  -- Update rattle
  rattle:update(dt)
end

function sea:draw()
  lovr.graphics.setBackgroundColor(0, 50, 100)
  rattle:draw()
end

return sea

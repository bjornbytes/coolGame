local sea = {}
local rattle = require 'app/rattle'
local submarine = require 'app/submarine'

function sea:init()
  submarine:init()
  rattle:init()
end

function sea:update(dt)
  rattle:update(dt)
  submarine:update(dt)
end

function sea:draw()
  lovr.graphics.setBackgroundColor(0, 50, 100)

  submarine:draw()
  rattle:draw()
end

return sea

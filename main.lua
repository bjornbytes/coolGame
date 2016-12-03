local plane = require 'app/plane'
local controllers = require 'app/controllers'
local state = plane

function lovr.load()
  controllers:init()
  state:init()
end

function lovr.update(dt)
  state:update(dt)
end

function lovr.draw()
  state:draw()
end

function lovr.controlleradded(...)
  controllers:add(...)
end

function lovr.controllerremoved(...)
  controllers:remove(...)
end

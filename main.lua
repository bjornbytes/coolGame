_ = require 'lume'
g = lovr.graphics
local menu = require 'app/menu'
local controllers = require 'app/controllers'
local state = menu

function lovr.load()
  controllers:init()
  menu:init()
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

function setState(newState)
  state = newState
  newState.transitionFactor = 1
end

-- Draw me last!
function drawTransition(factor)
  if factor > 0 then
    g.setColor(1, 1, 1, factor^2)
    lovr.graphics.fill()
  end
end

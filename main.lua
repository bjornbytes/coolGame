_ = require 'lib.lume'
g = lovr.graphics
local cry = require 'app/cry'
local sleep = require 'app/sleep'
local menu = require 'app/menu'
local controllers = require 'app/controllers'
local state = menu

won = {
  cry = false,
  sleep = false,
  play = false
}

function lovr.load()
  controllers:init()
  menu:init()
  cry:init()
  sleep:init()
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
    g.setColor(255, 255, 255, factor^2 * 255)
    g.push()
    g.origin()
    g.translate(0, 0, -1)
    g.setDepthTest()
    g.plane('fill', 0, 0, 0, 5, 0, 0, 1)
    g.setDepthTest('less')
    g.pop()
  end
end

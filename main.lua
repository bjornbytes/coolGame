_ = require 'lib.lume'
g = lovr.graphics
local sea = require 'app/sea'
local menu = require 'app/menu'
local controllers = require 'app/controllers'
local state = menu

function lovr.load()
  -- lovr.graphics.setCullingEnabled(true)
  controllers:init()
  menu:init()
  sea:init()
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
end

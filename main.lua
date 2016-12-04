_ = require 'lib.lume'
g = lovr.graphics
local artichoke = require 'app/artichoke'
local sea = require 'app/sea'
local mobile = require 'app/mobile'
local menu = require 'app/menu'
local controllers = require 'app/controllers'
local state = menu

function lovr.load()
  t = 0
  lovr.graphics.setCullingEnabled(true)
  controllers:init()
  state:init()
end

function lovr.update(dt)
  state:update(dt)
  t = t + dt
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

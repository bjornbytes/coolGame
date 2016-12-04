_ = require 'lib.lume'
local artichoke = require 'app/artichoke'
local sea = require 'app/sea'
local mobile = require 'app/mobile'
local menu = require 'app/menu'
local controllers = require 'app/controllers'
local state = sea

function lovr.load()
  lovr.graphics.setCullingEnabled(true)
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

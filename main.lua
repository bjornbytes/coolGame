_ = require 'lib.lume'
local artichoke = require 'app/artichoke'
local controllers = require 'app/controllers'
local state = artichoke

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

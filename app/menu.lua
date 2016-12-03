local menu = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local mobile = require 'app/mobile'
local vec3 = require('lib/cpml').vec3

function menu:init()
  self.environment = lovr.graphics.newModel('art/roomTest.obj')
  rattle:init()
  mobile:init()
end

function menu:update(dt)
  rattle:update(dt)
  mobile:update(dt)
end

function menu:draw()
  lovr.graphics.setBackgroundColor(50, 250, 250)
  self:drawEnvironment()
  rattle:draw()
  mobile:draw()
end

function menu:drawEnvironment()
  lovr.graphics.setWireframe(true)
  self.environment:draw(0, 1, 0, .01)
end

return menu

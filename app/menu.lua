local menu = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local mobile = require 'app/mobile'
local vec3 = require('lib/cpml').vec3

function menu:init()
  self.room = lovr.graphics.newModel('art/room.obj')
  self.crib = lovr.graphics.newModel('art/crib.obj')
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
  self.room:draw(0, 1, 0, .01)
  lovr.graphics.setWireframe(false)
  lovr.graphics.setColor(255, 255, 255)
  self.crib:draw(0, 1, 0, .01)
end

return menu

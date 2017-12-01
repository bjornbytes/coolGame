local menu = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local mobile = require 'app/mobile'
local vec3 = require('lib/cpml').vec3

function menu:init()
  self.room = lovr.graphics.newModel('art/room.obj')
  self.room:setMaterial(g.newMaterial('art/room_DIFF.png'))
  self.crib = lovr.graphics.newModel('art/crib.obj')
  self.crib:setMaterial(g.newMaterial('art/crib_DIFF.png'))
  rattle:init()
  mobile:init()
end

function menu:update(dt)
  rattle:update(dt)
  mobile:update(dt)
end

function menu:draw()
  lovr.graphics.setBackgroundColor(50 / 255, 250 / 255, 250 / 255)
  self:drawEnvironment()
  rattle:draw()
  mobile:draw()
end

function menu:drawEnvironment()
  lovr.graphics.setColor(1, 1, 1)
  self.room:draw(0, 1, 0, .01)
  self.crib:draw(0, 1, 0, .01)
end

return menu

local artichoke = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local veggie = require 'app/veggie'
local vec3 = require('lib/cpml').vec3

function artichoke:init()
  self.environment = lovr.graphics.newModel('art/roomTest.obj')
  rattle:init()
  self.veggies = {}
  self:spawnVeggie()
end

function artichoke:update(dt)
  rattle:update(dt)
  _.each(self.veggies, 'update', dt)
end

function artichoke:draw()
  lovr.graphics.setBackgroundColor(50, 250, 250)
  self:drawEnvironment()
  rattle:draw()
  _.each(self.veggies, 'draw')
end

function artichoke:drawEnvironment()
  lovr.graphics.setWireframe(true)
  self.environment:draw(0, 1, 0, .01)
end

function artichoke:spawnVeggie()
  local veggiePosition = vec3(0, 3, -5)
  local veggie = veggie.grow(veggiePosition)
  table.insert(self.veggies, veggie)
end

return artichoke

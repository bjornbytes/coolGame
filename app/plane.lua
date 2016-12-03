local plane = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local veggie = require 'app/veggie'
local vec3 = require('lib/cpml').vec3

function plane:init()
  rattle:init()
  self.veggies = {}
  self:spawnVeggie()
end

function plane:update(dt)
  rattle:update(dt)
  _.each(self.veggies, 'update', dt)
end

function plane:draw()
  lovr.graphics.setBackgroundColor(50, 250, 250)
  self:drawCockpit()
  rattle:draw()
  _.each(self.veggies, 'draw')
end

function plane:drawCockpit()
  local size = 1 -- meter
  lovr.graphics.setColor(255, 255, 255)
  lovr.graphics.cube('line', 0, size / 2, 0, size)
end

function plane:spawnVeggie()
  local veggiePosition = vec3(0, 3, -5)
  local veggie = veggie.grow(veggiePosition)
  table.insert(self.veggies, veggie)
end

return plane

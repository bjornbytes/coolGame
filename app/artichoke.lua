local artichoke = {}
local controllers = require 'app/controllers'
local rattle = require 'app/rattle'
local veggie = require 'app/veggie'
local vec3 = require('lib/cpml').vec3

function artichoke:init()
  self.environment = lovr.graphics.newModel('art/roomTest.obj')
  rattle:init()
  self.veggies = {}
  self.veggieTimer = 1
end

function artichoke:update(dt)
  rattle:update(dt)

  -- Update veggies
  _.each(self.veggies, 'update', dt)

  -- Spawn veggies
  self.veggieTimer = self.veggieTimer - dt
  if self.veggieTimer <= 0 then
    self:spawnVeggie()
    self.veggieTimer = _.random(1, 2)
  end

  -- Destroy veggies outside map
  _.each(self.veggies, function(veggie)
    if veggie.position.y < -.5 then
      self:removeVeggie(veggie)
    end
  end)
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
  local veggiePosition = vec3(_.random(-1, 1), _.random(.5, 2), _.random(-5, -4))
  local veggie = veggie.grow(veggiePosition)
  self.veggies[veggie] = veggie
end

function artichoke:removeVeggie(veggie)
  self.veggies[veggie] = nil
end

return artichoke

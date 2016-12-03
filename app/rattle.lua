local rattle = {}
local vec3 = require 'lib.cpml.vec3'

function rattle:init()
  self.lastPosition = {}
  self.velocity = 0
end

function rattle:update(dt)
  print(self.controller)
  if self.controller then
    local pos = vec3(self.controller:getPosition())
    print(pos)

    if self.lastPosition then
      local delta = pos - self.lastPosition
      print(delta)
      self.lastPosition = pos
    else
      self.lastPosition = pos
    end
  elseif controllers.list[1] then
    self:setController(controllers.list[1])
  end
end

function rattle:draw()
  --
end

function rattle:setController(controller)
  self.controller = controller
end

return rattle

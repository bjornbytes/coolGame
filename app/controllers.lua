local controllers = {}

function controllers:init()
  self.list = {}
end

function controllers:add()
  self:refresh()
end

function controllers:remove()
  self:refresh()
end

function controllers:refresh()
  self.list = lovr.headset.getControllers()
end

return controllers

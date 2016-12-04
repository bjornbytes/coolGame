local sea = {}
local rattle = require 'app/rattle'
local controllers = require 'app/controllers'
local submarine = require 'app/submarine'

function sea:init()
  self.skybox = g.newSkybox(
    -- 'art/skyboxes/seaSide.png',
    -- 'art/skyboxes/seaSide.png',
    -- 'art/skyboxes/seaCeiling.png',
    -- 'art/skyboxes/seaFloor.png',
    -- 'art/skyboxes/seaSide.png',
    -- 'art/skyboxes/seaSide.png'

    'art/skyboxes/sea_rt.jpg',
    'art/skyboxes/sea_lf.jpg',
    'art/skyboxes/sea_up.jpg',
    'art/skyboxes/sea_dn.jpg',
    'art/skyboxes/sea_bk.jpg',
    'art/skyboxes/sea_ft.jpg'
  )
  self.transitionFactor = 0

  self.transitionFactor = 1

  submarine:init()
  rattle:init()
end

function sea:update(dt)
  rattle:update(dt)
  submarine:update(dt)

  local controller = controllers.list[1]
  if controller and controller:isDown('system') then
    self.transitionFactor = math.min(self.transitionFactor + dt, 1)

     if self.transitionFactor > 0 then
      controller:vibrate(self.transitionFactor^2 * .0035)
    end

    if self.transitionFactor >= 1 then
      local menu = require 'app/menu'
      setState(menu)
    end
  else
    self.transitionFactor = math.max(self.transitionFactor - dt, 0)
  end
end

function sea:draw()
  local a, rx, ry, rz = lovr.headset.getOrientation()
  g.setColor(255, 255, 255)
  self.skybox:draw(a, rx, ry, rz)

  submarine:draw()
  rattle:draw()

  drawTransition(self.transitionFactor)
end

return sea

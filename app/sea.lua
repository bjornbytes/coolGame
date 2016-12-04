local sea = {}
local rattle = require 'app/rattle'
local submarine = require 'app/submarine'

function sea:init()
  self.skybox = g.newSkybox(
    'art/skyboxes/seaSide.png',
    'art/skyboxes/seaSide.png',
    'art/skyboxes/seaCeiling.png',
    'art/skyboxes/seaFloor.png',
    'art/skyboxes/seaSide.png',
    'art/skyboxes/seaSide.png'
  )

  submarine:init()
  rattle:init()
end

function sea:update(dt)
  rattle:update(dt)
  submarine:update(dt)
  t = (t or 0) + dt
end

function sea:draw()
  local a, rx, ry, rz = lovr.headset.getOrientation()
  g.setColor(255, 255, 255)
  self.skybox:draw(a, rx, ry, rz)

  submarine:draw()
  rattle:draw()
end

return sea

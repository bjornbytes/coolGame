local sea = {}
local rattle = require 'app/rattle'
local submarine = require 'app/submarine'

function sea:init()
  self.skybox = g.newSkybox(
    'art/sea/sea_rt.jpg',
    'art/sea/sea_lf.jpg',
    'art/sea/sea_up.jpg',
    'art/sea/sea_dn.jpg',
    'art/sea/sea_bk.jpg',
    'art/sea/sea_ft.jpg'
  )

  submarine:init()
  rattle:init()
end

function sea:update(dt)
  rattle:update(dt)
  submarine:update(dt)
end

function sea:draw()
  local a, rx, ry, rz = lovr.headset.getPosition()
  self.skybox:draw(-a, rx, ry, rz)

  submarine:draw()
  rattle:draw()
end

return sea

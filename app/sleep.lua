local sleep = {}

function sleep:init()
  self.skybox = g.newSkybox(
    'art/skyboxes/stormydays_rt.tga',
    'art/skyboxes/stormydays_lf.tga',
    'art/skyboxes/stormydays_up.tga',
    'art/skyboxes/stormydays_dn.tga',
    'art/skyboxes/stormydays_bk.tga',
    'art/skyboxes/stormydays_ft.tga'
  )

  self.floor = g.newBuffer(lovr.headset.getBoundsGeometry())

  self.transitionFactor = 0
end

function sleep:update(dt)
  --
end

function sleep:draw()
  local a, rx, ry, rz = lovr.headset.getOrientation()
  g.setColor(255, 255, 255)
  self.skybox:draw(a, rx, ry, rz)

  g.setColor(255, 255, 255, 80)
  self.floor:draw()
end

return sleep

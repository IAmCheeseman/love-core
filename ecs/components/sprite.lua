local path = (...):gsub(".ecs.components.sprite$", "")
local event = require(path .. ".event")

local animGroup = Group("x", "y", "sprite")

event.on("update", function(dt)
  for entity in animGroup:iter() do
    entity.sprite:update(dt)
  end
end)

event.on("draw", function()
  for entity in animGroup:iter() do
    entity.scalex = entity.scalex or 1
    entity.scaley = entity.scaley or 1
    entity.rotation = entity.rotation or 0

    entity.sprite:draw(
        entity.x, entity.y,
        entity.rotation,
        entity.scalex, entity.scaley)
  end
end)



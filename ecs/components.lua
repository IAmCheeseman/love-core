local path = (...):gsub(".ecs.components$", "")

require(path .. ".ecs.components.animation")
require(path .. ".ecs.components.movement")

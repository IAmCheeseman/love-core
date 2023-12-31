local path = (...):gsub(".ecs.components$", "")

require(path .. ".ecs.components.drawable")
require(path .. ".ecs.components.state")
require(path .. ".ecs.components.sprite")
require(path .. ".ecs.components.camera")
require(path .. ".ecs.components.animation")
require(path .. ".ecs.components.movement")
require(path .. ".ecs.components.physics")

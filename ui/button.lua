local path = (...):gsub(".ui.button$", "")
local inky = require(path .. ".thirdparty.inky")
local theme = require(path .. ".ui.theme")

local button = inky.defineElement(function(self)
  self.props.hovered = false

  self:onPointerEnter(function()
    self.props.hovered = true
  end)

  self:onPointerExit(function()
    self.props.hovered = false
  end)

  return function(_, x, y, w, h)
    love.graphics.setLineStyle(theme.lineStyle)

    love.graphics.setColor(unpack(theme.bgColor))
    love.graphics.rectangle("fill", x, y, w, h, theme.borderRadius)

    love.graphics.setColor(unpack(theme.borderColor))
    love.graphics.setLineWidth(theme.borderWidth)
    love.graphics.rectangle("line", x, y, w, h, theme.borderRadius)

    if self.props.hovered then
      love.graphics.setColor(unpack(theme.focusColor))
      love.graphics.setLineWidth(theme.focusWidth)
      love.graphics.rectangle("line",
          x - theme.focusWidth,
          y - theme.focusWidth,
          w + theme.focusWidth * 2,
          h + theme.focusWidth * 2,
          theme.borderRadius)
    end

    love.graphics.setLineWidth(1)
    love.graphics.setFont(theme.font)
    love.graphics.setColor(theme.fgColor)
    love.graphics.printf(
        self.props.text,
        x, y + (h - theme.font:getHeight()) / 2,
        w, "center")
  end
end)

return button

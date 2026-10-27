-- Скорость, FPS и игроки рядом - маленькая плашка в углу экрана.
script = { name = "Speed HUD", author = "Felon", description = "Скорость, FPS и игроки рядом" }

local nearby = 0

events.on("tick", function()
  nearby = #world.players()
end)

events.on("render2d", function()
  local vx, vy, vz = player.velocity()
  local speed = math.sqrt(vx * vx + vz * vz) * 20
  local text = string.format("%.1f б/с  |  FPS %d  |  игроков рядом: %d", speed, client.fps(), nearby)
  local w = render.width(text, 8) + 12
  render.rect(6, 6, w, 16, color(16, 16, 21, 190), 6)
  render.text(text, 12, 10, 8, color(255, 255, 255))
end)

-- Коробки вокруг игроков рядом: красные - близко, зелёные - далеко.
script = { name = "Player Boxes", author = "Felon", description = "ESP-коробки игроков через render3d" }

local players = {}

events.on("tick", function()
  players = world.players()
end)

events.on("render3d", function()
  for _, p in ipairs(players) do
    local c = p.distance < 10 and color(235, 64, 52) or color(60, 200, 90)
    render.box(p.x - 0.3, p.y, p.z - 0.3, p.x + 0.3, p.y + 1.8, p.z + 0.3, c)
  end
end)

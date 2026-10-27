-- Предупреждение о голоде и низком HP + включение модуля по клавише.
script = { name = "Alerts", author = "Felon", description = "Голод, HP и KillAura на клавишу G" }

local warned = false

timer.every(1000, function()
  if not player.exists() then return end
  if player.food() <= 6 and not warned then
    client.print("Пора поесть: голод " .. player.food())
    warned = true
  elseif player.food() > 6 then
    warned = false
  end
end)

events.on("key", function(key, action)
  -- 71 = G
  if key == 71 and action == 1 and client.screen() == "" then
    modules.toggle("KillAura")
    client.print("KillAura: " .. (modules.isEnabled("KillAura") and "вкл" or "выкл"))
  end
end)

events.on("render2d", function()
  local hp = player.health()
  if hp > 0 and hp < 8 then
    local text = string.format("HP %.1f!", hp)
    local w = render.width(text, 12)
    render.text(text, render.screenWidth() / 2 - w / 2, render.screenHeight() / 2 + 20, 12, color(255, 80, 90))
  end
end)

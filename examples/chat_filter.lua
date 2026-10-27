-- Скрывает сообщения с запрещёнными словами и считает, сколько скрыто.
script = { name = "Chat Filter", author = "Felon", description = "Прячет рекламу в чате" }

local banned = { "купи", "донат", "скидка", "discord.gg" }
local hidden = 0

events.on("chat", function(text)
  local lower = text:lower()
  for _, word in ipairs(banned) do
    if lower:find(word, 1, true) then
      hidden = hidden + 1
      return true
    end
  end
end)

events.on("disable", function()
  client.print("Скрыто сообщений: " .. hidden)
end)

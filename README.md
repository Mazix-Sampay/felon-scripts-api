# Felon Scripts API

Скрипты для клиента **Felon** пишутся на **Lua** и кладутся в папку `Felon/scripts/*.lua`.
Включаются и выключаются во вкладке **Scripts** в ClickGUI. Там же справка по API и консоль (`print` и ошибки).

Сайт с документацией: **https://mazix-sampay.github.io/felon-scripts-api/**

- [Быстрый старт](#быстрый-старт)
- [Описание скрипта](#описание-скрипта)
- [События](#события)
- [client](#client)
- [player](#player)
- [world](#world)
- [modules](#modules)
- [render](#render)
- [input](#input)
- [timer](#timer)
- [color](#color)
- [Ограничения](#ограничения)
- [Примеры](examples)

---

## Быстрый старт

1. Открой ClickGUI → вкладка **Scripts** → кнопка **Папка**.
2. Создай файл `hello.lua`:

```lua
script = { name = "Привет", author = "я", description = "Первый скрипт" }

events.on("enable", function()
  client.print("Скрипт включён!")
end)

events.on("render2d", function()
  render.text("Hello, Felon!", 10, 10, 9, color(255, 255, 255))
end)
```

3. Нажми **Обновить** и включи скрипт переключателем.

Ошибки видны прямо в карточке скрипта (красным) и в **Консоли**.

## Описание скрипта

Глобальная таблица `script` (необязательно) - что показывать в списке:

```lua
script = { name = "Название", author = "Автор", description = "Что делает" }
```

Без неё имя берётся из имени файла.

## События

Подписка: `events.on(имя, функция)`. На одно событие можно повесить несколько функций.

| Событие | Аргументы | Когда |
|---|---|---|
| `tick` | - | каждый тик игры (20 раз в секунду) |
| `render2d` | - | каждый кадр, рисование на экране (`render.rect`, `render.text`) |
| `render3d` | - | каждый кадр, рисование в мире (`render.box`, `render.line`) |
| `chat` | `text` | пришло сообщение в чат. Вернуть `true` - сообщение будет скрыто |
| `key` | `key`, `action` | нажата/отпущена клавиша. `key` - GLFW-код, `action`: `1` нажата, `0` отпущена |
| `enable` | - | скрипт включили |
| `disable` | - | скрипт выключили |

```lua
events.on("chat", function(text)
  if text:find("купи донат") then
    return true -- скрыть
  end
end)
```

## client

| Функция | Описание |
|---|---|
| `client.print(text)` | сообщение в чат, видно только тебе |
| `client.say(text)` | написать сообщение в чат сервера |
| `client.command(cmd)` | выполнить команду (`"spawn"` или `"/spawn"`) |
| `client.fps()` | текущий FPS |
| `client.time()` | время в миллисекундах |
| `client.server()` | адрес сервера (`""` в одиночной игре) |
| `client.screen()` | имя класса открытого экрана (`""` - экран не открыт) |

Глобальный `print(...)` пишет в **Консоль** вкладки Scripts.

## player

| Функция | Возвращает / делает |
|---|---|
| `player.exists()` | `true`, если игрок в мире |
| `player.name()` | ник |
| `player.pos()` | `x, y, z` |
| `player.velocity()` | скорость `x, y, z` (блоков за тик) |
| `player.yaw()`, `player.pitch()` | поворот камеры |
| `player.setRotation(yaw, pitch)` | повернуть камеру |
| `player.health()`, `player.absorption()` | здоровье, поглощение |
| `player.food()` | голод (0-20) |
| `player.onGround()` | стоит ли на земле |
| `player.sprinting()`, `player.setSprinting(b)` | спринт |
| `player.jump()` | прыжок (если на земле) |
| `player.slot()`, `player.setSlot(n)` | слот хотбара `1-9` |
| `player.item([slot])` | предмет в руке или в слоте инвентаря `1-36`: `id, count` |
| `player.attack()` | ударить сущность под прицелом |
| `player.use()` | использовать предмет в руке |

```lua
local x, y, z = player.pos()
local id, count = player.item()
```

## world

| Функция | Описание |
|---|---|
| `world.players()` | игроки рядом (без тебя) |
| `world.entities([radius])` | сущности в радиусе (по умолчанию 32) |
| `world.block(x, y, z)` | id блока, например `"minecraft:stone"` |
| `world.dimension()` | измерение, например `"minecraft:the_nether"` |

Элемент списка `players()` / `entities()` - таблица:

```lua
{ name = "Nick", type = "minecraft:player", x = 0, y = 64, z = 0, distance = 5.2, health = 20 }
```

## modules

| Функция | Описание |
|---|---|
| `modules.list()` | имена всех модулей |
| `modules.isEnabled(name)` | включён ли модуль |
| `modules.setEnabled(name, b)` | включить / выключить |
| `modules.toggle(name)` | переключить |
| `modules.get(name, setting)` | значение настройки (`boolean`, `number` или `string`) |
| `modules.set(name, setting, value)` | изменить настройку |

```lua
modules.setEnabled("KillAura", true)
modules.set("KillAura", "Attack Range", 3.2)
modules.set("NoSlow", "Item Mode", "Adaptive")
```

## render

Рисование на экране - **только внутри `render2d`**:

| Функция | Описание |
|---|---|
| `render.rect(x, y, w, h, color[, radius])` | прямоугольник (со скруглением) |
| `render.text(text, x, y[, size, color])` | текст (`size` по умолчанию 8, цвет - белый) |
| `render.width(text[, size])` | ширина текста |
| `render.screenWidth()`, `render.screenHeight()` | размер экрана в GUI-пикселях |

Рисование в мире - **только внутри `render3d`** (координаты мира):

| Функция | Описание |
|---|---|
| `render.box(x1, y1, z1, x2, y2, z2, color[, fill])` | коробка (`fill = true` - залитая) |
| `render.line(x1, y1, z1, x2, y2, z2, color)` | линия |

## input

| Функция | Описание |
|---|---|
| `input.isKeyDown(key)` | зажата ли клавиша: имя (`"r"`, `"space"`, `"left.shift"`) или GLFW-код |

## timer

| Функция | Описание |
|---|---|
| `timer.after(ms, fn)` | вызвать `fn` один раз через `ms` миллисекунд |
| `timer.every(ms, fn)` | вызывать `fn` каждые `ms` миллисекунд (минимум 50) |

## color

`color(r, g, b[, a])` - цвет для `render.*` (ARGB-число). `a` по умолчанию 255.

```lua
local white = color(255, 255, 255)
local glass = color(16, 16, 21, 190)
```

Можно писать и сразу числом: `0xFFFFFFFF`.

## Ограничения

Скрипты работают в песочнице:

- нет доступа к файлам, ОС, Java (`io`, `os`, `luajava`, `require`, `load`, `dofile`);
- у каждого события есть лимит инструкций: бесконечный цикл не повесит игру - скрипт остановится с ошибкой;
- ошибка в скрипте выключает его обработчики, текст ошибки виден во вкладке Scripts. Исправь файл и нажми **Обновить**.

Доступны стандартные `string`, `table`, `math`, `bit32`.

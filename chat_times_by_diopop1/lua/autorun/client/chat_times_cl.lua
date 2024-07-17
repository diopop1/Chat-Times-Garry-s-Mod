-- Файл: addons/chat_times/lua/autorun/client/chat_times_cl.lua

local timeColor = Color(200, 200, 200) -- начальный цвет времени (серый)

-- Функция для добавления времени к сообщениям чата
local function AddTimestamp()
    local ply = net.ReadEntity()
    local text = net.ReadString()
    local teamChat = net.ReadBool()
    local time = os.date("%H:%M:%S")

    -- Получаем цвет времени из сети
    timeColor = net.ReadColor()

    -- Форматируем сообщение с добавлением времени и цвета
    local messageTable = {}

    if teamChat then
        table.insert(messageTable, Color(0, 255, 0)) -- цвет для командного чата
        table.insert(messageTable, "[Команда] ")
    end

    table.insert(messageTable, ply)
    table.insert(messageTable, Color(255, 255, 255)) -- цвет для обычного текста
    table.insert(messageTable, ": ")
    table.insert(messageTable, text)
    table.insert(messageTable, timeColor) -- вставляем цвет времени
    table.insert(messageTable, "     (")
    table.insert(messageTable, time)
    table.insert(messageTable, ")")

    -- Выводим сообщение в чат с помощью chat.AddText и таблицы messageTable
    chat.AddText(unpack(messageTable))
end

net.Receive("PlayerChatTimestamp", AddTimestamp)

-- Обработчик для установки цвета времени при подключении игрока
net.Receive("SetTimeColor", function()
    timeColor = net.ReadColor()
end)



/*
| Copyright © diopop1 - 2024 |

[ diopop1 - development. ]
[ ChatGPT - assistance in writing code. ]

All rights reserved, but you can improve the addon and release it as an improved version but with me as the author of the original addon.
*/
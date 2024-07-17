-- Пример сохранения и загрузки конфигурации в Garry's Mod

if SERVER then
    AddCSLuaFile("autorun/client/chat_times_cl.lua")

    util.AddNetworkString("PlayerChatTimestamp")
    util.AddNetworkString("SetTimeColor")

    local defaultColor = {r = 200, g = 200, b = 200}
    local timeColor = Color(defaultColor.r, defaultColor.g, defaultColor.b) -- начальный цвет времени (серый)


    -- Обработчик команды /setcolortime
    concommand.Add("setcolortime", function(ply, cmd, args)
        if not ply:IsAdmin() then
            ply:ChatPrint("You do not have permission to use this command.")
            return
        end

        if #args < 3 then
            ply:ChatPrint("Usage: /setcolortime <r> <g> <b>")
            return
        end

        local r = tonumber(args[1]) or defaultColor.r
        local g = tonumber(args[2]) or defaultColor.g
        local b = tonumber(args[3]) or defaultColor.b

        -- Проверяем, что цвет находится в допустимых пределах (0-255)
        r = math.Clamp(r, 0, 255)
        g = math.Clamp(g, 0, 255)
        b = math.Clamp(b, 0, 255)

        timeColor = Color(r, g, b)


        -- Отправляем цвет всем клиентам
        net.Start("SetTimeColor")
        net.WriteColor(timeColor)
        net.Broadcast()
    end)

    -- Хук для отправки текущего цвета времени новым подключившимся клиентам
    hook.Add("PlayerInitialSpawn", "SendTimeColorToNewPlayer", function(ply)
        net.Start("SetTimeColor")
        net.WriteColor(timeColor)
        net.Send(ply)
    end)

    hook.Add("PlayerSay", "AddTimestampToChat", function(ply, text, teamChat)
        net.Start("PlayerChatTimestamp")
        net.WriteEntity(ply)
        net.WriteString(text)
        net.WriteBool(teamChat)
        net.WriteColor(timeColor) -- Добавляем цвет времени
        net.Send(ply)

        -- Возвращаем пустую строку, чтобы предотвратить стандартный вывод сообщения
        return ""
    end)
end



/*
| Copyright © diopop1 - 2024 |

[ diopop1 - development. ]
[ ChatGPT - assistance in writing code. ]

All rights reserved, but you can improve the addon and release it as an improved version but with me as the author of the original addon.
*/
local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(0)
        if Config.EspEnabled then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                if targetPed ~= playerPed and DoesEntityExist(targetPed) then
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(playerCoords - targetCoords)

                    if distance <= Config.EspDistance then
                        DrawMarker(1, targetCoords.x, targetCoords.y, targetCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.EspSize, Config.EspSize, Config.EspSize, Config.EspColor.r, Config.EspColor.g, Config.EspColor.b, Config.EspColor.a, false, true, 2, false, nil, nil, false)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('espsystem:updateConfig')
AddEventHandler('espsystem:updateConfig', function(config)
    Config = config
end)
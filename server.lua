local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('espsystem:getConfig', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchScalar('SELECT esp_enabled FROM esp_settings WHERE player_id = @player_id', {
            ['@player_id'] = xPlayer.identifier
        }, function(espEnabled)
            if espEnabled == nil then
                espEnabled = Config.EspEnabled
            end

            MySQL.Async.fetchAll('SELECT esp_color, esp_distance, esp_size FROM esp_settings WHERE player_id = @player_id', {
                ['@player_id'] = xPlayer.identifier
            }, function(result)
                local config = {
                    EspEnabled = espEnabled,
                    EspColor = Config.EspColor,
                    EspDistance = Config.EspDistance,
                    EspSize = Config.EspSize
                }

                if result[1] then
                    local color = result[1].esp_color
                    local r, g, b, a = color:match('(%d+),(%d+),(%d+),(%d+)')
                    config.EspColor = {r = tonumber(r), g = tonumber(g), b = tonumber(b), a = tonumber(a)}
                    config.EspDistance = result[1].esp_distance
                    config.EspSize = result[1].esp_size
                end

                cb(config)
            end)
        end)
    else
        cb(Config)
    end
end)

RegisterCommand('esp', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchScalar('SELECT esp_enabled FROM esp_settings WHERE player_id = @player_id', {
            ['@player_id'] = xPlayer.identifier
        }, function(espEnabled)
            if espEnabled == nil then
                espEnabled = Config.EspEnabled
            end

            espEnabled = not espEnabled
            MySQL.Async.execute('INSERT INTO esp_settings (player_id, esp_enabled) VALUES (@player_id, @esp_enabled) ON DUPLICATE KEY UPDATE esp_enabled = @esp_enabled', {
                ['@player_id'] = xPlayer.identifier,
                ['@esp_enabled'] = espEnabled
            }, function(rowsChanged)
                TriggerClientEvent('espsystem:updateConfig', source, {
                    EspEnabled = espEnabled,
                    EspColor = Config.EspColor,
                    EspDistance = Config.EspDistance,
                    EspSize = Config.EspSize
                })
            end)
        end)
    end
end, false)
-- client/client.lua

local ESX, QBCore

if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Load the utility functions
local utilsContent = LoadResourceFile(GetCurrentResourceName(), 'utils.lua')
assert(load(utilsContent))()

local Locales = loadLocale(Config.Locale)

local function _U(str, ...)
    if Locales and Locales[str] then
        if select('#', ...) > 0 then
            return string.format(Locales[str], ...)
        else
            return Locales[str]
        end
    else
        return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
    end
end

if Config.Framework == 'esx' then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
elseif Config.Framework == 'qbcore' then
    Citizen.CreateThread(function()
        while QBCore == nil do
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(0)
        end
    end)
end

local function notify(title, message, messageType)
    messageType = messageType or 'info'

    if Config.NotificationSystem == 'esx' then
        TriggerEvent('chat:addMessage', { args = { title, message } })
    elseif Config.NotificationSystem == 'okokNotify' then
        exports['okokNotify']:Alert(title, message, 5000, messageType, true)
    elseif Config.NotificationSystem == 'origen_notify' then
        if messageType == 'error' then
            exports["origen_notify"]:ShowNotification(message, "error")
        elseif messageType == 'success' then
            exports["origen_notify"]:ShowNotification(message, "success")
        else
            exports["origen_notify"]:ShowNotification(message)
        end
    elseif Config.NotificationSystem == 'custom' then
        -- Custom notification logic here
    else
        TriggerEvent('chat:addMessage', { args = { title, message } })
    end
end

for job, config in pairs(Config.Jobs) do
    RegisterCommand(config.CommandName, function(source, args, rawCommand)
        if Config.Framework == 'esx' then
            -- Check the player's job for ESX
            ESX.TriggerServerCallback('esx:getPlayerData', function(playerData)
                if playerData.job.name == job then
                    -- Open ESX dialog to input number
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'enter_number', {
                        title = _U('enter_number')
                    }, function(data, menu)
                        local number = tonumber(data.value)
                        if number then
                            -- Send the number to the server
                            TriggerServerEvent('sendServiceAvailability', job, number)
                            menu.close()
                        else
                            notify('System', _U('provide_valid_number'), 'error')
                        end
                    end, function(data, menu)
                        menu.close()
                    end)
                else
                    notify('System', _U('no_permission'), 'error')
                end
            end)
        elseif Config.Framework == 'qbcore' then
            -- Check the player's job for QBCore
            local PlayerData = QBCore.Functions.GetPlayerData()
            if PlayerData.job.name == job then
                -- Open QBCore input to input number
                local dialog = exports['qb-input']:ShowInput({
                    header = _U('enter_number'),
                    submitText = "Submit",
                    inputs = {
                        {
                            text = _U('enter_number'),
                            name = "number",
                            type = "number",
                            isRequired = true
                        }
                    }
                })
                if dialog then
                    local number = tonumber(dialog.number)
                    if number then
                        -- Send the number to the server
                        TriggerServerEvent('sendServiceAvailability', job, number)
                    else
                        notify('System', _U('provide_valid_number'), 'error')
                    end
                end
            else
                notify('System', _U('no_permission'), 'error')
            end
        end
    end, false)
end

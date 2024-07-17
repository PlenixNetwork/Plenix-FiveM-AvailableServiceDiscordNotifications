-- client/client.lua

ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

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
        -- Default ESX notification
        TriggerEvent('chat:addMessage', { args = { title, message } })
    end
end

for job, config in pairs(Config.Jobs) do
    -- Register the command for each job
    RegisterCommand(config.CommandName, function(source, args, rawCommand)
        -- Get the number from the command
        local number = tonumber(args[1])

        if number then
            -- Check the player's job
            ESX.TriggerServerCallback('esx:getPlayerData', function(playerData)
                if playerData.job.name == job then
                    -- Send the number to the server
                    TriggerServerEvent('sendServiceAvailability', job, number)
                else
                    -- Notify the user they don't have permission
                    notify('System', 'You do not have permission to use this command.', 'error')
                end
            end)
        else
            -- Notify the user in the game about the error
            notify('System', 'Please provide a valid number.', 'error')
        end
    end, false)
end

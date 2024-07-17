-- server/server.lua

ESX = exports["es_extended"]:getSharedObject()

local jobCooldowns = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local function notify(source, title, message, messageType)
    messageType = messageType or 'info'

    if Config.NotificationSystem == 'esx' then
        TriggerClientEvent('chat:addMessage', source, { args = { title, message } })
    elseif Config.NotificationSystem == 'okokNotify' then
        TriggerClientEvent('okokNotify:Alert', source, title, message, 5000, messageType, true)
    elseif Config.NotificationSystem == 'origen_notify' then
        if messageType == 'error' then
            TriggerClientEvent('origen_notify:ShowNotification', source, message, "error")
        elseif messageType == 'success' then
            TriggerClientEvent('origen_notify:ShowNotification', source, message, "success")
        else
            TriggerClientEvent('origen_notify:ShowNotification', source, message)
        end
    elseif Config.NotificationSystem == 'custom' then
        -- Custom notification logic here
    else
        -- Default ESX notification
        TriggerClientEvent('chat:addMessage', source, { args = { title, message } })
    end
end

-- Function to send a message to Discord
local function sendToDiscord(webhookURL, botUsername, botAvatarURL, message)
    -- Data to send to the webhook
    local data = {
        ["content"] = message,
        ["username"] = botUsername,
        ["avatar_url"] = botAvatarURL
    }
    
    -- Convert data to JSON
    local jsonData = json.encode(data)

    -- Configure HTTP request
    PerformHttpRequest(webhookURL, function(err, text, headers) 
        if Config.DebugMode then
            print("Discord Webhook Response Error: " .. tostring(err))
            print("Discord Webhook Response Text: " .. tostring(text))
        end
    end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end

-- Handle the event sent from the client
RegisterServerEvent('sendServiceAvailability')
AddEventHandler('sendServiceAvailability', function(job, number)
    local source = source
    local jobConfig = Config.Jobs[job]
    if jobConfig then
        local currentTime = os.time()
        local cooldownTime = jobConfig.Delay * 60

        if jobCooldowns[job] == nil or (currentTime - jobCooldowns[job]) >= cooldownTime then
            -- Update the cooldown
            jobCooldowns[job] = currentTime

            -- Build the message to send
            local message = jobConfig.AvailableServiceMessage .. number

            if Config.DebugMode then
                print("Sending message to Discord: " .. message)
            end

            -- Send the message to Discord
            sendToDiscord(jobConfig.WebhookURL, jobConfig.BotUsername, jobConfig.BotAvatarURL, message)

            -- Notify the user in the game
            notify(source, 'System', 'Availability sent to Discord.', 'success')
        else
            -- Calculate remaining time
            local remainingTime = cooldownTime - (currentTime - jobCooldowns[job])
            local minutes = math.floor(remainingTime / 60)
            local seconds = remainingTime % 60

            -- Notify the user about the cooldown
            notify(source, 'Error', string.format('You must wait %d minutes and %d seconds to send another message.', minutes, seconds), 'error')
        end
    else
        print("Invalid job configuration: " .. job)
    end
end)

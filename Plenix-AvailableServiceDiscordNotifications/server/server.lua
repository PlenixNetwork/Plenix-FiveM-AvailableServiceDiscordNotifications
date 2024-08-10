-- server/server.lua

local ESX, QBCore

if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local jobCooldowns = {}

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
        TriggerClientEvent('chat:addMessage', source, { args = { title, message } })
    end
end

local function sendToDiscord(source, webhookURL, botUsername, botAvatarURL, message)
    -- If DevMode is enabled, use the DevWebhookURL
    if Config.DevMode then
        webhookURL = Config.DevWebhookURL
    end

    local data = {
        ["content"] = message,
        ["username"] = botUsername,
        ["avatar_url"] = botAvatarURL
    }
    local jsonData = json.encode(data)

    PerformHttpRequest(webhookURL, function(err, text, headers)
        -- err should be 200 or 204 if the request was successful
        if err == 200 or err == 204 then
            if Config.DebugMode then
                print("Successfully sent message to Discord: " .. text)
            end
            -- Notify the user of the success
            notify(source, 'System', _U('availability_sent'), 'success')
        else
            if Config.DebugMode then
                print("Error sending message to Discord: HTTP " .. tostring(err) .. " - " .. tostring(text))
            end
            -- Notify the user of the error
            notify(source, 'Error', _U('discord_error'), 'error')
        end
    end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('sendServiceAvailability')
AddEventHandler('sendServiceAvailability', function(job, number)
    local source = source
    local jobConfig = Config.Jobs[job]
    if jobConfig then
        local currentTime = os.time()
        local cooldownTime = jobConfig.Delay * 60

        if jobCooldowns[job] == nil or (currentTime - jobCooldowns[job]) >= cooldownTime then
            jobCooldowns[job] = currentTime

            local message = jobConfig.AvailableServiceMessage .. number

            if Config.DebugMode then
                print("Sending message to Discord: " .. message)
            end

            sendToDiscord(source, jobConfig.WebhookURL, jobConfig.BotUsername, jobConfig.BotAvatarURL, message)

        else
            local remainingTime = cooldownTime - (currentTime - jobCooldowns[job])
            local minutes = math.floor(remainingTime / 60)
            local seconds = remainingTime % 60

            notify(source, 'Error', string.format(_U('cooldown_message'), minutes, seconds), 'error')
        end
    else
        print("Invalid job configuration: " .. job)
    end
end)
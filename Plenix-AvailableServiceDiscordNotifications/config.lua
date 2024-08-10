-- config.lua

Config = {}

Config.Framework = 'esx'  -- Choose between 'esx' or 'qbcore' depending on the framework you are using
Config.Locale = 'en'  -- Set default language for translations ('en' for English, 'es' for Spanish, etc.)

-- Notification system: 'default', 'okokNotify', 'origen_notify', or 'custom'
Config.NotificationSystem = 'default'  -- Choose the in-game notification system to use

-- Debug mode
Config.DebugMode = false  -- Enable/disable debug mode. If true, debug information will be printed to the console.

-- Development mode
Config.DevMode = false  -- Enable/disable development mode. If true, all messages will be sent to the DevWebhookURL.
Config.DevWebhookURL = "https://discord.com/api/webhooks/DEV_EXAMPLE"  -- Webhook URL to use in development mode.

-- Jobs and services
Config.Jobs = {
    police = { 
        WebhookURL = "https://discord.com/api/webhooks/EXAMPLE",  -- Discord Webhook URL for police job
        BotUsername = "Police",  -- Discord bot username for police job
        BotAvatarURL = "https://link.to/bot/avatar.png",  -- Discord bot avatar URL for police job
        CommandName = "available_police",  -- Command name to trigger the notification for police
        AvailableServiceMessage = "Available Agents: ",  -- Message format for available police officers
        Delay = 30  -- Cooldown time in minutes before the command can be used again by the same job
    },
    ambulance = { 
        WebhookURL = "https://discord.com/api/webhooks/EXAMPLE",  -- Discord Webhook URL for ambulance job
        BotUsername = "EMS",  -- Discord bot username for ambulance job
        BotAvatarURL = "https://link.to/bot/avatar.png",  -- Discord bot avatar URL for ambulance job
        CommandName = "available_ems",  -- Command name to trigger the notification for ambulance
        AvailableServiceMessage = "Available EMS: ",  -- Message format for available EMS personnel
        Delay = 15  -- Cooldown time in minutes before the command can be used again by the same job
    }
}


-- config.lua

Config = {}

Config.Jobs = {
    police = { -- Job name
        WebhookURL = "https://discord.com/api/webhooks/EXAMPLE", -- Discord Webhook URL
        BotUsername = "Police", -- Discord - Bot username
        BotAvatarURL = "https://link.to/bot/avatar.png", -- Discord - Bot avatar URL
        CommandName = "available_police", -- Command name to trigger the notification
        AvailableServiceMessage = "Available Agents: ",
        Delay = 30 -- Delay in minutes (cooldown)
    },
    ambulance = { -- Job name
        WebhookURL = "https://discord.com/api/webhooks/EXAMPLE", -- Discord Webhook URL
        BotUsername = "EMS", -- Discord - Bot username
        BotAvatarURL = "https://link.to/bot/avatar.png", -- Discord - Bot avatar URL
        CommandName = "available_ems", -- Command name to trigger the notification
        AvailableServiceMessage = "Available EMS: ",
        Delay = 15 -- Delay in minutes (cooldown)
    }
}

-- Notification system: 'default', 'okokNotify', 'origen_notify', or 'custom'
Config.NotificationSystem = 'default'

-- Debug mode
Config.DebugMode = false

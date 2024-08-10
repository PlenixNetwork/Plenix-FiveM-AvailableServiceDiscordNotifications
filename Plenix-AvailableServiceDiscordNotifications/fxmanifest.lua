fx_version 'cerulean'
game 'gta5'

author 'Plenix Network - alexasecas'
description 'Easy Discord Available Service Notification'
version '2.0.0'
-- Latest Release: 10/08/2024

-- Plenix: https://plenix.net
-- Discord: https://discord.plenix.net

client_script 'client/client.lua'
server_script 'server/server.lua'
shared_scripts {
    '@es_extended/imports.lua',   -- For ESX compatibility
    'config.lua',
    'utils.lua'                   -- Include the utility file
}

files {
    'locales/*'
}

-- Optional dependencies for QBCore
optional_dependencies {
    'qb-core'                    -- Make QBCore optional
}

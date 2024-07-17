Easy Discord Available Service Notification
Description:
The Easy Discord Available Service Notification script for FiveM is designed to notify a Discord channel when certain jobs are available within the game. The script uses webhooks to send messages to Discord and supports multiple job configurations, customizable notification systems, and cooldown periods between notifications to prevent spam.

Features:
- Multiple Job Configurations: Customize webhooks, command names, bot usernames, bot avatars, and messages for different jobs.
- Cooldown Management: Configurable delay for each job to prevent repeated notifications within a specified time period.
- Customizable Notification System: Supports default, okokNotify, origen_notify, and custom notification systems for in-game messages.
- Debug Mode: Enable debug mode to print additional information to the console for troubleshooting.

Configuration:
The script is configured through the config.lua file, where you can specify settings for each job and general settings such as the notification system and debug mode.

Installation:
1. Download the script: Download the script and extract it into your resources folder.
2. Configure the script: Edit the config.lua file to suit your needs.
3. Add to server.cfg: Add start EasyDiscordAvailableServiceNotification to your server.cfg file.

Commands:
- Each job has its own command specified in the config.lua file. Players with the corresponding job can use the command to notify Discord of their availability.

Example: /available_police [number]

Notification Systems:
- The script supports different notification systems for in-game messages:
  - default: Uses the built-in ESX notifications.
  - okokNotify: Uses the okokNotify resource for notifications.
  - origen_notify: Uses the origen_notify resource for notifications.
  - custom: Allows you to implement your custom notification logic.

License:
- This project is licensed under the MIT License.

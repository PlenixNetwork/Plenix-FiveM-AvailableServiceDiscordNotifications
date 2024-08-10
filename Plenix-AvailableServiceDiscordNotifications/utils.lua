-- utils.lua

-- Function to load the selected locale
function loadLocale(locale)
    local resource = GetCurrentResourceName()
    local fileName = string.format('locales/%s.lua', locale)
    local content = LoadResourceFile(resource, fileName)
    if content then
        local localeFunc = assert(load(content))
        localeFunc()
        return Locales[locale]
    else
        print('Locale file [' .. locale .. '] not found.')
        return {}
    end
end

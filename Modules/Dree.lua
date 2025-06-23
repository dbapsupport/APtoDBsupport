local loader = {}

local GAME_ID = 5166944221
local GAME_NAME = "Death Ball"
local SCRIPT_URL = "https://raw.githubusercontent.com/5n9c/lilnova/refs/heads/main/deathball/loader.lua"

function loader.loadMainScript(fluent)
    if game.GameId ~= GAME_ID then
        fluent:Notify({
            Title = "error",
            Content = "This script only supports Death Ball",
            Duration = 10,
            Type = "error"
        })
        return
    end

    local success, result = pcall(function()
        local scriptContent = game:HttpGet(SCRIPT_URL, true)
        local scriptFunc = loadstring(scriptContent)
        if scriptFunc then
            scriptFunc()
        else
            error("Failed to compile script")
        end
    end)

    if not success then
        fluent:Notify({
            Title = "error",
            Content = "Failed to load script: " .. tostring(result),
            Duration = 10,
            Type = "error"
        })
    end
end

function loader.Initialize(fluent, auth, license, createAuthWindow)
    if game.GameId ~= GAME_ID then
        fluent:Notify({
            Title = "error",
            Content = "This script only supports Death Ball",
            Duration = 10,
            Type = "error"
        })
        return
    end

    if license and license ~= "" then
        local valid, msg = auth.checkKeyWithAPI(license)
        fluent:Notify({
            Title = valid and "success" or "Error",
            Content = msg,
            Duration = 5,
            Type = valid and "success" or "error"
        })

        if valid then
            getgenv()._authenticated = true
            loader.loadMainScript(fluent)
            return
        end
    end

    createAuthWindow()
end

return loader
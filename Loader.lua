local license = license or ""
local fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local auth = loadstring(game:HttpGet("https://raw.githubusercontent.com/5n9c/lilnova/refs/heads/main/modules/auth.lua"))()
local loader = loadstring(game:HttpGet("https://pastebin.com/raw/Wuxkzq7G"))()

local function createAuthWindow()
    if not fluent then return end

    local window = fluent:CreateWindow({
        Title = "Nova",
        SubTitle = "Authenticator",
        TabWidth = 100,
        Size = UDim2.fromOffset(400, 300),
        Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
        Theme = "Darker",
        MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
    })

    --fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
    local tab = window:AddTab({ Title = "Auth", Icon = "key" })
    local options = fluent.Options

    tab:AddParagraph({
        Title = "Restricted access",
        Content = "enter your license below"
    })

    tab:AddInput("License", {
        Title = "License",
        Placeholder = "Your license here",
        Numeric = false
    })

    tab:AddButton({
        Title = "Login",
        Callback = function()
            local userLicense = options.License.Value

            if userLicense == "" then
                fluent:Notify({
                    Title = "warning",
                    Content = "fill in the field",
                    Duration = 8,
                    Type = "warning"
                })
                return
            end

            local isValid, message = auth.checkKeyWithAPI(userLicense)

            fluent:Notify({
                Title = isValid and "success" or "error",
                Content = message,
                Duration = 5,
                Type = isValid and "success" or "error"
            })

            if isValid then
                getgenv()._authenticated = true
                pcall(window.Destroy, window)
                task.delay(5, function()
                    loader.loadMainScript(fluent)
                end)
            end
        end
    })

    tab:AddButton({
        Title = "Get license",
        Callback = function()
            window:Dialog({
                Title = "Private script",
                Content = "To purchase your license, contact the script owner on discord (5n9c)",
                Buttons = {{ Title = "Ok" }}
            })
        end
    })

    window:SelectTab(1)
end

pcall(function()
    loader.Initialize(fluent, auth, license, createAuthWindow)
end)

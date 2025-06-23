local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local auth = {}

-- Configurações
auth.GLOBAL_LICENSE = "LATINOTHEBEST"
auth.API_URL = "https://keysysnova.squareweb.app/validatekey/"

-- Interpretar resposta da API
function auth.handleAPIResponse(r)
    if r == "VALID" then return true, "License Valid!" end
    if r == "EXPIRED" then return false, "Expired License!" end
    if r == "NOT_FOUND" then return false, "Invalid License!" end
    if r == "ALREADY_IN_USE" then return false, "License in use by another user" end
    if r == "MISSING_USER" then return false, "Roblox username not provided" end

    local iso_timestamp = r:match("^VALID%s+(.+)$")
    if iso_timestamp then
        -- Converte ISO timestamp para formato legível
        local success, date = pcall(function()
            -- Extrai apenas a parte da data e hora (ignora milissegundos e timezone se presente)
            local year, month, day, hour, min, sec = iso_timestamp:match("^(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
            if year then
                return string.format("%02d/%02d/%04d %02d:%02d:%02d", month, day, year, hour, min, sec)
            end
            return iso_timestamp -- Fallback se não puder formatar
        end)
        return true, success and "License valid until: " .. date or "Valid License (Unformattable)"
    end

    return false, "Unknown API response: " .. (type(r) == "string" and r or type(r))
end

-- Checar chave com a API
function auth.checkKeyWithAPI(k)
    if k == auth.GLOBAL_LICENSE then
        return true, "Valid Trial License!"
    end
    if not k or k == "" then
        return false, "License cannot be empty"
    end

    -- Obtém o nome de usuário do jogador local
    local username = Players.LocalPlayer and Players.LocalPlayer.Name or ""
    if username == "" then
        return false, "Could not retrieve Roblox username"
    end

    local ok, r = pcall(function()
        -- Adiciona o parâmetro user na URL
        local url = auth.API_URL .. k .. "?user=" .. HttpService:UrlEncode(username)
        return game:HttpGet(url, true)
    end)

    if not ok then
        return false, "API connection error: " .. tostring(r)
    end

    return auth.handleAPIResponse(r)
end

return auth
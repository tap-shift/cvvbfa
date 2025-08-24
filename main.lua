-- ===== SETTINGS =====
local webhook = "https://discord.com/api/webhooks/1409104663575265370/vtt87aQssj-wRFIwHb2PAJbZyEdbAW1SzPpZDc2J6MqfD1o4Ia7WAdbBVwQ4nFf-3HAt"
local pingwhenuser = "Anonymous27261738" 
local pingme = "1058386462892105829" 
local youprefix = "🟢"
local otherprefix = "⚪"
local friendprefix = "⛓"
-- ====================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function isValidDiscordID(id)
    return tonumber(id) ~= nil
end
local shouldPing = isValidDiscordID(pingme)

local function sendToDiscord(message)
    request({
        Url = webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({["username"] = "Server Chat Logger", ["content"] = message})
    })
end

local function formatMessage(player, msg)
    local prefix = otherprefix
    pcall(function()
        if player == LocalPlayer then
            prefix = youprefix
        elseif LocalPlayer:IsFriendsWith(player.UserId) then
            prefix = friendprefix
        end
    end)
    local finalMsg = prefix.." ["..player.Name.."]: "..msg
    if shouldPing and player.Name == pingwhenuser then
        finalMsg = "<@"..pingme.."> "..finalMsg
    end
    return finalMsg
end

local function onChat(player, msg)
    sendToDiscord(formatMessage(player, msg))
end

for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        onChat(player, msg)
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        onChat(player, msg)
    end)
end)

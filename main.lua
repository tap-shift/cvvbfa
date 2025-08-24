local webhook = "https://discord.com/api/webhooks/1409104663575265370/vtt87aQssj-wRFIwHb2PAJbZyEdbAW1SzPpZDc2J6MqfD1o4Ia7WAdbBVwQ4nFf-3HAt"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function sendToDiscord(username, message)
    request({
        Url = webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            ["username"] = "Server Chat Logger",
            ["content"] = message
        })
    })
end

local function formatMessage(player, msg)
    local prefix = "⚪"  -- default for others
    pcall(function()
        if player == LocalPlayer then
            prefix = "🟢"
        elseif LocalPlayer:IsFriendsWith(player.UserId) then
            prefix = "⛓"
        end
    end)
    return prefix.." ["..player.Name.."]: "..msg
end

local function onChat(player, msg)
    local wrapped = formatMessage(player, msg)
    sendToDiscord(player.Name, wrapped)
end

-- Connect existing players
for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        onChat(player, msg)
    end)
end

-- Connect new players
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        onChat(player, msg)
    end)
end)

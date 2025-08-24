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
            ["content"] = username..": "..message
        })
    })
end

local function onChat(player, msg)
    local wrapped = msg
    pcall(function()
        if LocalPlayer:IsFriendsWith(player.UserId) then
            wrapped = "**"..msg.."**"
        end
    end)
    sendToDiscord(player.Name, wrapped)
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

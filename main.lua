local webhook = "https://discord.com/api/webhooks/1409104663575265370/vtt87aQssj-wRFIwHb2PAJbZyEdbAW1SzPpZDc2J6MqfD1o4Ia7WAdbBVwQ4nFf-3HAt"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")

local function sendToDiscord(message)
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

TextChatService.OnIncomingMessage = function(message)
    if message.TextSource and message.TextSource.UserId then
        local player = Players:GetPlayerByUserId(message.TextSource.UserId)
        if player then
            local wrapped = message.Text

            -- Bold messages from friends
            pcall(function()
                if LocalPlayer:IsFriendsWith(player.UserId) then
                    wrapped = "**"..wrapped.."**"
                end
            end)

            local finalMessage = ""

            if message.ChannelName == "All" then
                -- Public message
                finalMessage = "🟢 "..player.Name..": "..wrapped
            elseif message.ChannelName == "Team" then
                -- Team message
                local teamName = player.Team and player.Team.Name or "Unknown Team"
                finalMessage = "⚪ "..player.Name..": "..wrapped.." ["..teamName.."]"
            else
                -- Private message
                local recipientName = "Unknown"
                if message.TextSource.TargetUserId then
                    local recipient = Players:GetPlayerByUserId(message.TextSource.TargetUserId)
                    if recipient then
                        recipientName = recipient.Name
                    end
                end
                finalMessage = "👁 "..player.Name..": "..wrapped.." ["..player.Name.." to "..recipientName.."]"
            end

            sendToDiscord(finalMessage)
        end
    end
end

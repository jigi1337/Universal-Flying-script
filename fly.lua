local Players = game:GetService("Players")
local player = Players.LocalPlayer

while wait() do
    local args = {
        player
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("TycoonService"):WaitForChild("RF"):WaitForChild("PayIncome"):InvokeServer(unpack(args))
end

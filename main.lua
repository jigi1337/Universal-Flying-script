local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local flying = false
local UIS = game:GetService("UserInputService")

-- Erstelle Physikobjekte
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.P = 9e4
bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bodyGyro.CFrame = hrp.CFrame

local bodyVel = Instance.new("BodyVelocity")
bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bodyVel.Velocity = Vector3.new(0, 0, 0)

-- Geschwindigkeit
local speed = 100

-- Tastenbelegung
local controls = {
    [Enum.KeyCode.W] = Vector3.new(0, 0, -1), -- Vorwärts
    [Enum.KeyCode.S] = Vector3.new(0, 0, 1),  -- Rückwärts
    [Enum.KeyCode.A] = Vector3.new(-1, 0, 0), -- Links
    [Enum.KeyCode.D] = Vector3.new(1, 0, 0),  -- Rechts
    [Enum.KeyCode.E] = Vector3.new(0, 1, 0),  -- Hoch
    [Enum.KeyCode.Q] = Vector3.new(0, -1, 0)  -- Runter
}

-- Toggle Flug mit F
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        
        if flying then
            bodyGyro.Parent = hrp
            bodyVel.Parent = hrp
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        else
            bodyGyro.Parent = nil
            bodyVel.Parent = nil
            bodyVel.Velocity = Vector3.new(0,0,0)
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

-- Bewegung in RenderStepped
game:GetService("RunService").RenderStepped:Connect(function()
    if flying then
        local cam = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Prüfe gedrückte Tasten
        for key, direction in pairs(controls) do
            if UIS:IsKeyDown(key) then
                moveDirection += direction
            end
        end
        
        -- WICHTIG: Bewegung relativ zur Kamera ausrichten
        if moveDirection.Magnitude > 0 then
            local worldDirection = cam.CFrame:VectorToWorldSpace(moveDirection)
            bodyVel.Velocity = worldDirection * speed
        else
            bodyVel.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Rotation auf Kamera ausrichten
        bodyGyro.CFrame = cam.CFrame
    end
end)

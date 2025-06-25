local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local autoFarmEnabled = false
local flySpeed = 80

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoFarmGUI"
gui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Auto Farm: OFF"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = gui

button.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    button.Text = autoFarmEnabled and "Auto Farm: ON" or "Auto Farm: OFF"
end)

local function getClosestNPC()
    local closest = nil
    local shortestDist = math.huge
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChildOfClass("Humanoid") and npc.Name:find("Novice Holy Knight") then
            local dist = (npc.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closest = npc
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    if not autoFarmEnabled then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local target = getClosestNPC()
    if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChildOfClass("Humanoid").Health > 0 then
        local hrp = char.HumanoidRootPart
        local dir = (target.HumanoidRootPart.Position - hrp.Position).Unit
        hrp.CFrame = hrp.CFrame + dir * flySpeed * RunService.RenderStepped:Wait()

        local atkBtn = player.PlayerGui:FindFirstChild("AttackButton") or player.PlayerGui:FindFirstChild("Attack")
        if atkBtn and atkBtn:IsA("TextButton") then
            pcall(function()
                atkBtn:Activate()
            end)
        end
    end
end)

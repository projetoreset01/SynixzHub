--[[
🌐 Synixz Hub - Roblox Script
Desenvolvido por: Synixz
Discord: discord.gg/seulink
--]]

repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SynixzHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 280)
frame.Position = UDim2.new(0, 20, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🌐 Synixz Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local function makeBtn(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Text = text
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 15, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
end

-- Estados
local antiHit, antiLaser, fly, noclip, speedHack = false, false, false, false, false

-- Anti-Hit
local function toggleAntiHit()
    antiHit = not antiHit
    if antiHit then
        print("[Synixz] Anti-Hit ativado")
        spawn(function()
            while antiHit do
                if hum and hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
                wait(0.2)
            end
        end)
    else
        print("[Synixz] Anti-Hit desativado")
    end
end

-- Anti-Laser
local function toggleAntiLaser()
    antiLaser = not antiLaser
    if antiLaser then
        print("[Synixz] Anti-Laser ativado")
        spawn(function()
            while antiLaser do
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                        p.Touched:Connect(function(hit)
                            if hit.Name:lower():find("laser") or hit.Name:lower():find("kill") then
                                hum.Health = hum.MaxHealth
                            end
                        end)
                    end
                end
                wait(0.5)
            end
        end)
    else
        print("[Synixz] Anti-Laser desativado")
    end
end

-- Fly
local flyConn
local function toggleFly()
    fly = not fly
    if fly then
        print("[Synixz] Fly ativado")
        local bp = Instance.new("BodyPosition", char.HumanoidRootPart)
        local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)

        flyConn = game:GetService("RunService").RenderStepped:Connect(function()
            bp.Position = char.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
            bg.CFrame = workspace.CurrentCamera.CFrame
        end)

    else
        if flyConn then flyConn:Disconnect() end
        char.HumanoidRootPart:FindFirstChild("BodyPosition"):Destroy()
        char.HumanoidRootPart:FindFirstChild("BodyGyro"):Destroy()
        print("[Synixz] Fly desativado")
    end
end

-- NoClip
game:GetService("RunService").Stepped:Connect(function()
    if noclip and char and char:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)
local function toggleNoClip()
    noclip = not noclip
    print("[Synixz] NoClip " .. (noclip and "ativado" or "desativado"))
end

-- Speed Hack
local function toggleSpeed()
    speedHack = not speedHack
    if speedHack then
        print("[Synixz] Velocidade aumentada")
        hum.WalkSpeed = 100
    else
        hum.WalkSpeed = 16
        print("[Synixz] Velocidade normal")
    end
end

-- Teleport para pontos fixos (opcional)
local function teleportTo(pos)
    if char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- BOTÕES
makeBtn("🔰 Anti-Hit", 40, toggleAntiHit)
makeBtn("☢️ Anti-Laser", 80, toggleAntiLaser)
makeBtn("🪂 Fly", 120, toggleFly)
makeBtn("🚪 NoClip", 160, toggleNoClip)
makeBtn("⚡ Speed Hack", 200, toggleSpeed)
makeBtn("📍 Teleport (base)", 240, function()
    teleportTo(Vector3.new(0, 200, 0))
end)

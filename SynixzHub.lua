--[[ 🔥 Synixz Hub - Roblox Script 🔥
Desenvolvido por: Synixz
Discord: discord.gg/seulink
]]--

repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character
local plr = game.Players.LocalPlayer
local char = plr.Character
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "SynixzHubGui"

-- Função de botão
function makeBtn(txt, y, func)
    local btn = Instance.new("TextButton", gui)
    btn.Size = UDim2.new(0, 250, 0, 30)
    btn.Position = UDim2.new(0.5, -125, 0, y)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(func)
end

-- Anti-Hit
local antihitOn = false
function toggleAntiHit()
    antihitOn = not antihitOn
    if antihitOn then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
end

-- Anti-Laser
local antilaserOn = false
function toggleAntiLaser()
    antilaserOn = not antilaserOn
    if antilaserOn then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("kill") then
                v.CanTouch = false
                v.CanCollide = false
                v.Transparency = 0.5
            end
        end
    end
end

-- Fly
function enableFly()
    local bp = Instance.new("BodyPosition", char.HumanoidRootPart)
    bp.Position = char.HumanoidRootPart.Position
    bp.MaxForce = Vector3.new(99999, 99999, 99999)
end

-- Invisível
function becomeInvisible()
    for _, p in pairs(char:GetChildren()) do
        if p:IsA("BasePart") then
            p.Transparency = 1
        end
    end
end

-- Teleportar pro lobby
function teleportToLobby()
    char:MoveTo(Vector3.new(0, 100, 0))
end

-- Auto Farm
local function autoFarm()
    spawn(function()
        while true do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") then
                    firetouchinterest(char.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(char.HumanoidRootPart, v.Parent, 1)
                end
            end
            wait(2)
        end
    end)
end

-- ESP
local function enableESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= plr and player.Character and player.Character:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui", player.Character.Head)
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = player.Name
            label.TextColor3 = Color3.new(1, 0, 0)
            label.BackgroundTransparency = 1
        end
    end
end

-- Teleport para outro jogador
local function teleportToPlayer(targetName)
    local target = game.Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end

-- AntiCheat simples
local function basicBypass()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") and v.Name:lower():find("anticheat") then
            v:Destroy()
        end
    end
end

-- === ANTIBAN ===
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    if tostring(self) == "Kick" or getnamecallmethod() == "Kick" then
        warn("[Synixz AntiBan] Kick bloqueado!")
        return
    end
    return old(self, ...)
end)

for _, v in pairs(game:GetDescendants()) do
    if v:IsA("LocalScript") and string.match(v.Name:lower(), "anticheat") then
        v:Destroy()
    end
end

local function protectHumanoid()
    local human = plr.Character:FindFirstChildOfClass("Humanoid")
    if human then
        human.BreakJointsOnDeath = false
        human:GetPropertyChangedSignal("Health"):Connect(function()
            if human.Health <= 5 then
                human.Health = human.MaxHealth
            end
        end)
    end
end
protectHumanoid()

game:GetService("LogService").MessageOut:Connect(function(msg)
    if string.find(msg:lower(), "ban") or string.find(msg:lower(), "log") then
        warn("[Synixz AntiBan] Log suspeito:", msg)
    end
end)

-- === SPEED SYSTEM ===

-- Speed simples
local speedOn = false
function toggleSpeedSimple()
    speedOn = not speedOn
    if speedOn then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = 16
    end
end

-- Speed Tween seguro
function tweenSpeedTo(pos)
    local ts = game:GetService("TweenService")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local goal = {CFrame = CFrame.new(pos)}
    local info = TweenInfo.new(1, Enum.EasingStyle.Linear)
    ts:Create(hrp, info, goal):Play()
end

-- Botões
makeBtn("🛡️ Anti-Hit", 50, toggleAntiHit)
makeBtn("💥 Anti-Laser", 90, toggleAntiLaser)
makeBtn("🚀 Teleportar para Lobby", 130, teleportToLobby)
makeBtn("🕊️ Ativar Fly", 170, enableFly)
makeBtn("👻 Invisibilidade", 210, becomeInvisible)
makeBtn("⚡ Speed Simples", 250, toggleSpeedSimple)
makeBtn("👁️ ESP Players", 290, enableESP)
makeBtn("🤖 Auto Farm", 330, autoFarm)
makeBtn("🔓 Bypass AC", 370, basicBypass)

-- Mensagem
local msg = Instance.new("TextLabel", gui)
msg.Size = UDim2.new(0, 250, 0, 30)
msg.Position = UDim2.new(0.5, -125, 0, 10)
msg.BackgroundTransparency = 1
msg.Text = "✅ Synixz Hub Iniciado!"
msg.TextColor3 = Color3.new(0, 1, 0)
msg.Font = Enum.Font.GothamBold
msg.TextSize = 16
wait(3)
msg:Destroy()

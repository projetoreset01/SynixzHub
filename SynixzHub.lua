-- Synixz Hub - Estilo Chilli Hub com tema preto
-- Desenvolvido por Synixz
-- Discord: discord.gg/seulink

repeat wait() until game:IsLoaded()

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Estados
local antiHit, antiLaser, flyMode, invis, speedOn = false, false, false, false, false

-- Criar botão flutuante (ícone)
local starterGui = game:GetService("StarterGui")
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SynixzHub"
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Name = "OpenCloseButton"
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -30)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "http://www.roblox.com/asset/?id=6031091002" -- ícone (ninja)

-- Criar interface principal
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 400, 0, 320)
main.Position = UDim2.new(0.5, -200, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Visible = false
main.Active = true
main.Draggable = true

-- Abas
local tabs = {
    "Main",
    "Player",
    "Teleport",
    "Extras",
    "Créditos"
}

local tabFrames = {}

local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton", tabBar)
    tabBtn.Size = UDim2.new(0, 80, 1, 0)
    tabBtn.Position = UDim2.new(0, (i - 1) * 80, 0, 0)
    tabBtn.Text = tabName
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 14

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, 0, 1, -40)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    content.Visible = i == 1
    tabFrames[tabName] = content

    tabBtn.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        content.Visible = true
    end)
end

-- Função criar botão em aba
local function addButton(tab, name, callback)
    local btn = Instance.new("TextButton", tabFrames[tab])
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #tabFrames[tab]:GetChildren() * 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = name
    btn.MouseButton1Click:Connect(callback)
end

-- Botões principais
addButton("Main", "🛡️ Anti-Hit", function()
    antiHit = not antiHit
    if antiHit then
        print("[Synixz] Anti-Hit ativado")
        spawn(function()
            while antiHit and hum and hum.Health do
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
                wait(0.2)
            end
        end)
    else
        print("[Synixz] Anti-Hit desativado")
    end
end)

addButton("Main", "💥 Anti-Laser", function()
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
                wait(0.3)
            end
        end)
    else
        print("[Synixz] Anti-Laser desativado")
    end
end)

addButton("Player", "🕊️ Ativar Fly", function()
    flyMode = not flyMode
    if flyMode then
        local bp = Instance.new("BodyPosition", char.HumanoidRootPart)
        bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        spawn(function()
            while flyMode and bp do
                bp.Position = char.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
                wait()
            end
            bp:Destroy()
        end)
    end
end)

addButton("Player", "⚡ Speed x3", function()
    speedOn = not speedOn
    if speedOn then
        hum.WalkSpeed = 48
    else
        hum.WalkSpeed = 16
    end
end)

addButton("Player", "👻 Invisibilidade", function()
    invis = not invis
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = invis and 1 or 0
        end
    end
end)

addButton("Teleport", "🚀 Teleportar para Lobby", function()
    if char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
end)

addButton("Créditos", "🌑 Synixz Hub", function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Synixz Hub",
        Text = "Criado por Synixz • Tema Estilo Chilli",
        Duration = 5
    })
end)

-- Botão abre/fecha
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

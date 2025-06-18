local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- Cria o GUI todo via script
local gui = Instance.new("ScreenGui")
gui.Name = "ExplosaoGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 230)
frame.Position = UDim2.new(0.5, -140, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = gui

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.BackgroundTransparency = 1
titulo.Text = "💥 Explosão Vermelha Raiz"
titulo.Font = Enum.Font.ArialBold
titulo.TextSize = 24
titulo.TextColor3 = Color3.fromRGB(255, 100, 100)
titulo.Parent = frame

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, 0, 0, 40)
dropdown.Position = UDim2.new(0, 0, 0, 45)
dropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Text = "Selecionar jogador"
dropdown.Font = Enum.Font.SourceSansBold
dropdown.TextScaled = true
dropdown.Parent = frame

local menu = Instance.new("Frame")
menu.Size = UDim2.new(1, 0, 1, -95)
menu.Position = UDim2.new(0, 0, 0, 85)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = menu
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 2)

local explodirBtn = Instance.new("TextButton")
explodirBtn.Size = UDim2.new(1, 0, 0, 40)
explodirBtn.Position = UDim2.new(0, 0, 1, -40)
explodirBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
explodirBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
explodirBtn.Text = "💥 Explodir Jogador"
explodirBtn.Font = Enum.Font.SourceSansBold
explodirBtn.TextScaled = true
explodirBtn.Parent = frame

local jogadorSelecionado = nil

-- Atualiza lista de jogadores
local function atualizarLista()
    menu:ClearAllChildren()
    layout.Parent = menu

    for _, jogador in pairs(Players:GetPlayers()) do
        if jogador ~= LocalPlayer then
            local botao = Instance.new("TextButton")
            botao.Size = UDim2.new(1, 0, 0, 30)
            botao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            botao.TextColor3 = Color3.fromRGB(255, 255, 255)
            botao.Font = Enum.Font.SourceSans
            botao.TextScaled = true
            botao.Text = jogador.Name
            botao.Parent = menu

            botao.MouseButton1Click:Connect(function()
                jogadorSelecionado = jogador
                dropdown.Text = "🎯 " .. jogador.Name
                menu.Visible = false
            end)
        end
    end
end

dropdown.MouseButton1Click:Connect(function()
    atualizarLista()
    menu.Visible = not menu.Visible
end)

-- Função da explosão + efeito
local function criarExplosao(posicao, alvo)
    -- Bola vermelha neon
    local bola = Instance.new("Part")
    bola.Shape = Enum.PartType.Ball
    bola.Size = Vector3.new(12, 12, 12)
    bola.Position = posicao + Vector3.new(0, 3, 0)
    bola.Color = Color3.fromRGB(255, 0, 0)
    bola.Material = Enum.Material.Neon
    bola.Anchored = true
    bola.CanCollide = false
    bola.Transparency = 0.3
    bola.Parent = workspace
    Debris:AddItem(bola, 1)

    -- Som de explosão
    local som = Instance.new("Sound")
    som.SoundId = "rbxassetid://138186576" -- som clássico de explosão
    som.Volume = 1
    som.PlayOnRemove = true
    som.Parent = bola
    som:Destroy() -- toca o som uma vez

    -- Empurra o jogador (BodyVelocity)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart") then
        local root = alvo.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = (root.Position - posicao).Unit * 100 + Vector3.new(0, 50, 0) -- empurra pra longe + pra cima
        bv.MaxForce = Vector3.new(400000, 400000, 400000)
        bv.P = 1250
        bv.Parent = root
        Debris:AddItem(bv, 0.3)
    end

    -- Mata o jogador (dá dano total)
    if alvo and alvo.Character and alvo.Character:FindFirstChild("Humanoid") then
        alvo.Character.Humanoid.Health = 0
    end
end

explodirBtn.MouseButton1Click:Connect(function()
    if jogadorSelecionado and jogadorSelecionado.Character and jogadorSelecionado.Character:FindFirstChild("HumanoidRootPart") then
        criarExplosao(jogadorSelecionado.Character.HumanoidRootPart.Position, jogadorSelecionado)
    else
        dropdown.Text = "❌ Jogador inválido"
    end
end)

-- Atualiza lista ao entrar/sair jogadores
Players.PlayerAdded:Connect(atualizarLista)
Players.PlayerRemoving:Connect(atualizarLista)
[

-- ╔══════════════════════════════════════════╗
-- ║          GHOST V2 | Rivals Script        ║
-- ║      Aimbot + ESP | UI: Glass Effect     ║
-- ╚══════════════════════════════════════════╝

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local Workspace      = game:GetService("Workspace")
local Camera         = Workspace.CurrentCamera

local LocalPlayer    = Players.LocalPlayer
local Mouse          = LocalPlayer:GetMouse()

-- ══════════════════════════════════════════
--              НАСТРОЙКИ
-- ══════════════════════════════════════════

local Config = {
    AimBot = {
        Enabled      = false,
        Smooth       = 0.18,      -- плавность (0.05 быстро, 0.4 медленно)
        FOV          = 300,       -- радиус захвата (пиксели)
        HitPart      = "Head",    -- "Head" или "HumanoidRootPart"
        ShowFOV      = true,
    },
    ESP = {
        Enabled      = false,
        ShowBox      = true,
        ShowHealth   = true,
        ShowDistance = true,
        ShowName     = true,
        HighlightThrough = true,
        BoxColor     = Color3.fromRGB(200, 200, 215),
        HealthColor  = Color3.fromRGB(80, 255, 120),
        TextColor    = Color3.fromRGB(255, 255, 255),
        HighlightColor = Color3.fromRGB(180, 180, 220),
        MaxDistance  = 500,
    },
}

-- ══════════════════════════════════════════
--              ЭКРАННЫЙ GUI
-- ══════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name          = "GhostV2"
ScreenGui.ResetOnSpawn  = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent        = (gethui and gethui()) or game:GetService("CoreGui")

-- ══════════════════════════════════════════
--         КНОПКА ОТКРЫТИЯ "ghost"
-- ══════════════════════════════════════════

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size          = UDim2.new(0, 80, 0, 32)
ToggleBtn.Position      = UDim2.new(0, 14, 0.5, -16)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
ToggleBtn.BackgroundTransparency = 0.18
ToggleBtn.Text          = "ghost"
ToggleBtn.TextColor3    = Color3.fromRGB(220, 220, 230)
ToggleBtn.TextSize      = 15
ToggleBtn.Font          = Enum.Font.GothamBold
ToggleBtn.BorderSizePixel = 0
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent        = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

local ToggleGrad = Instance.new("UIGradient")
ToggleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 210, 215)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 190)),
}
ToggleGrad.Rotation = 90
ToggleGrad.Parent = ToggleBtn

-- Анимация переливания текста кнопки
local shimmerOffset = 0
RunService.Heartbeat:Connect(function(dt)
    shimmerOffset = (shimmerOffset + dt * 0.55) % 1
    local r = math.floor(shimmerOffset * 360)
    ToggleGrad.Rotation = r
end)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(180, 180, 200)
ToggleStroke.Thickness = 1
ToggleStroke.Transparency = 0.4
ToggleStroke.Parent = ToggleBtn

-- ══════════════════════════════════════════
--         ГЛАВНОЕ ОКНО (GLASS MENU)
-- ══════════════════════════════════════════

local MenuFrame = Instance.new("Frame")
MenuFrame.Size          = UDim2.new(0, 310, 0, 230)
MenuFrame.Position      = UDim2.new(0.5, -155, 0, 12)   -- вверху по центру
MenuFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
MenuFrame.BackgroundTransparency = 0.12
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible       = false
MenuFrame.Parent        = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 16)
MenuCorner.Parent = MenuFrame

-- Эффект стекла — внутренний блик
local GlassHighlight = Instance.new("Frame")
GlassHighlight.Size = UDim2.new(1, 0, 0.5, 0)
GlassHighlight.Position = UDim2.new(0, 0, 0, 0)
GlassHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassHighlight.BackgroundTransparency = 0.88
GlassHighlight.BorderSizePixel = 0
GlassHighlight.ZIndex = 2
GlassHighlight.Parent = MenuFrame

local GlassCorner = Instance.new("UICorner")
GlassCorner.CornerRadius = UDim.new(0, 16)
GlassCorner.Parent = GlassHighlight

-- Градиент фона меню (серо-белый)
local MenuGrad = Instance.new("UIGradient")
MenuGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(60, 60, 68)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 90, 100)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(48, 48, 56)),
}
MenuGrad.Rotation = 135
MenuGrad.Parent = MenuFrame

-- Обводка окна
local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Color3.fromRGB(200, 200, 215)
MenuStroke.Thickness = 1.2
MenuStroke.Transparency = 0.35
MenuStroke.Parent = MenuFrame

-- ══════════════════════════════════════════
--         ЗАГОЛОВОК "ghost v2" (правый верх)
-- ══════════════════════════════════════════

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size          = UDim2.new(1, -14, 0, 36)
TitleLabel.Position      = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text          = "ghost v2"
TitleLabel.TextColor3    = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize      = 18
TitleLabel.Font          = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Right
TitleLabel.ZIndex        = 5
TitleLabel.Parent        = MenuFrame

-- Переливание заголовка серый → белый
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(155, 155, 170)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(155, 155, 170)),
}
titleGrad.Rotation = 0
titleGrad.Parent = TitleLabel

local titleOffset = 0
RunService.Heartbeat:Connect(function(dt)
    titleOffset = (titleOffset + dt * 0.4) % 1
    titleGrad.Offset = Vector2.new(math.sin(titleOffset * math.pi * 2) * 0.5, 0)
end)

-- Разделитель под заголовком
local Divider = Instance.new("Frame")
Divider.Size            = UDim2.new(1, -20, 0, 1)
Divider.Position        = UDim2.new(0, 10, 0, 38)
Divider.BackgroundColor3 = Color3.fromRGB(200, 200, 215)
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.ZIndex          = 4
Divider.Parent          = MenuFrame

-- ══════════════════════════════════════════
--      ФУНКЦИЯ СОЗДАНИЯ КНОПКИ-ТОГГЛЕРА
-- ══════════════════════════════════════════

local function CreateToggle(parent, text, icon, posY, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -24, 0, 44)
    Row.Position = UDim2.new(0, 12, 0, posY)
    Row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Row.BackgroundTransparency = 0.92
    Row.BorderSizePixel = 0
    Row.ZIndex = 5
    Row.Parent = parent

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 10)
    RowCorner.Parent = Row

    local RowStroke = Instance.new("UIStroke")
    RowStroke.Color = Color3.fromRGB(200, 200, 220)
    RowStroke.Thickness = 0.8
    RowStroke.Transparency = 0.6
    RowStroke.Parent = Row

    local IconLbl = Instance.new("TextLabel")
    IconLbl.Size = UDim2.new(0, 30, 1, 0)
    IconLbl.Position = UDim2.new(0, 8, 0, 0)
    IconLbl.BackgroundTransparency = 1
    IconLbl.Text = icon
    IconLbl.TextSize = 20
    IconLbl.Font = Enum.Font.GothamBold
    IconLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    IconLbl.ZIndex = 6
    IconLbl.Parent = Row

    local TextLbl = Instance.new("TextLabel")
    TextLbl.Size = UDim2.new(1, -100, 1, 0)
    TextLbl.Position = UDim2.new(0, 44, 0, 0)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextColor3 = Color3.fromRGB(230, 230, 240)
    TextLbl.TextSize = 14
    TextLbl.Font = Enum.Font.GothamSemibold
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.ZIndex = 6
    TextLbl.Parent = Row

    -- Сам переключатель
    local SwitchBG = Instance.new("Frame")
    SwitchBG.Size = UDim2.new(0, 44, 0, 24)
    SwitchBG.Position = UDim2.new(1, -52, 0.5, -12)
    SwitchBG.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SwitchBG.BorderSizePixel = 0
    SwitchBG.ZIndex = 6
    SwitchBG.Parent = Row

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBG

    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
    SwitchKnob.Position = UDim2.new(0, 3, 0.5, -9)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 215)
    SwitchKnob.BorderSizePixel = 0
    SwitchKnob.ZIndex = 7
    SwitchKnob.Parent = SwitchBG

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SwitchKnob

    local enabled = false

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.ZIndex = 8
    ClickBtn.Parent = Row

    ClickBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 210, 175)}):Play()
            TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 23, 0.5, -9)}):Play()
        else
            TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
        callback(enabled)
    end)

    return Row
end

-- ══════════════════════════════════════════
--           СОЗДАНИЕ КНОПОК МЕНЮ
-- ══════════════════════════════════════════

CreateToggle(MenuFrame, "Aimbot  [Авто-прицел]", "⊕", 50, function(state)
    Config.AimBot.Enabled = state
end)

CreateToggle(MenuFrame, "ESP  [Подсветка врагов]", "◈", 104, function(state)
    Config.ESP.Enabled = state
end)

-- Нижний статус
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -20, 0, 22)
StatusBar.Position = UDim2.new(0, 10, 1, -28)
StatusBar.BackgroundTransparency = 1
StatusBar.Text = "ghost v2  •  rivals"
StatusBar.TextColor3 = Color3.fromRGB(120, 120, 140)
StatusBar.TextSize = 11
StatusBar.Font = Enum.Font.Gotham
StatusBar.TextXAlignment = Enum.TextXAlignment.Left
StatusBar.ZIndex = 5
StatusBar.Parent = MenuFrame

-- ══════════════════════════════════════════
--        ОТКРЫТИЕ / ЗАКРЫТИЕ МЕНЮ
-- ══════════════════════════════════════════

local menuOpen = false

local function OpenMenu()
    MenuFrame.Visible = true
    MenuFrame.BackgroundTransparency = 1
    MenuFrame.Size = UDim2.new(0, 280, 0, 200)
    TweenService:Create(MenuFrame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.12,
        Size = UDim2.new(0, 310, 0, 230),
    }):Play()
end

local function CloseMenu()
    TweenService:Create(MenuFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 280, 0, 200),
    }):Play()
    task.delay(0.22, function()
        MenuFrame.Visible = false
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then OpenMenu() else CloseMenu() end
end)

-- Перетаскивание меню
local dragging, dragStart, startPos = false, nil, nil
MenuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = input.Position
        startPos  = MenuFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MenuFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ══════════════════════════════════════════
--            FOV CIRCLE (АИМБОТ)
-- ══════════════════════════════════════════

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible    = false
FOVCircle.Radius     = Config.AimBot.FOV
FOVCircle.Color      = Color3.fromRGB(200, 200, 220)
FOVCircle.Thickness  = 1
FOVCircle.Filled     = false
FOVCircle.Transparency = 0.5

-- ══════════════════════════════════════════
--       ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ══════════════════════════════════════════

local function GetCharacter(player)
    return player and player.Character
end

local function GetHumanoid(char)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function IsAlive(player)
    local char = GetCharacter(player)
    local hum  = GetHumanoid(char)
    return char and hum and hum.Health > 0
end

local function GetClosestPlayerToMouse()
    local closest, closestDist = nil, math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not IsAlive(player) then continue end

        local char = GetCharacter(player)
        local part = char:FindFirstChild(Config.AimBot.HitPart) or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end

        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local sp2 = Vector2.new(screenPos.X, screenPos.Y)
        local dist = (sp2 - mousePos).Magnitude

        if dist < Config.AimBot.FOV and dist < closestDist then
            closestDist = dist
            closest     = player
        end
    end
    return closest
end

-- ══════════════════════════════════════════
--              ESP ДАННЫЕ
-- ══════════════════════════════════════════

local ESPObjects = {}

local function RemoveESP(player)
    local obj = ESPObjects[player]
    if not obj then return end
    for _, v in pairs(obj) do
        if v and v.Remove then v:Remove()
        elseif v and v.Destroy then pcall(v.Destroy, v) end
    end
    ESPObjects[player] = nil
end

local function CreateESP(player)
    if ESPObjects[player] then RemoveESP(player) end

    local box       = Drawing.new("Square")
    local healthBG  = Drawing.new("Square")
    local healthBar = Drawing.new("Square")
    local nameLbl   = Drawing.new("Text")
    local distLbl   = Drawing.new("Text")
    local hpLbl     = Drawing.new("Text")

    -- Коробка
    box.Visible     = false
    box.Color       = Config.ESP.BoxColor
    box.Thickness   = 1.4
    box.Filled      = false
    box.Transparency = 1

    -- Бэкграунд полоски здоровья
    healthBG.Visible    = false
    healthBG.Color      = Color3.fromRGB(20, 20, 20)
    healthBG.Filled     = true
    healthBG.Transparency = 0.65

    -- Полоска здоровья
    healthBar.Visible    = false
    healthBar.Color      = Config.ESP.HealthColor
    healthBar.Filled     = true
    healthBar.Transparency = 1

    -- Имя
    nameLbl.Visible   = false
    nameLbl.Size      = 13
    nameLbl.Font      = 2
    nameLbl.Color     = Config.ESP.TextColor
    nameLbl.Outline   = true
    nameLbl.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameLbl.Center    = true
    nameLbl.Transparency = 1

    -- Дистанция
    distLbl.Visible   = false
    distLbl.Size      = 12
    distLbl.Font      = 2
    distLbl.Color     = Color3.fromRGB(180, 180, 200)
    distLbl.Outline   = true
    distLbl.OutlineColor = Color3.fromRGB(0, 0, 0)
    distLbl.Center    = true
    distLbl.Transparency = 1

    -- HP текст
    hpLbl.Visible    = false
    hpLbl.Size       = 11
    hpLbl.Font       = 2
    hpLbl.Color      = Config.ESP.HealthColor
    hpLbl.Outline    = true
    hpLbl.OutlineColor = Color3.fromRGB(0, 0, 0)
    hpLbl.Center     = false
    hpLbl.Transparency = 1

    -- Подсветка через стены
    local highlight = nil
    local char = GetCharacter(player)
    if char then
        highlight = Instance.new("SelectionBox")
        highlight.Color3          = Config.ESP.HighlightColor
        highlight.LineThickness   = 0.06
        highlight.SurfaceTransparency = 0.82
        highlight.SurfaceColor3   = Config.ESP.HighlightColor
        highlight.Adornee         = char
        highlight.Parent          = ScreenGui
    end

    ESPObjects[player] = {
        box         = box,
        healthBG    = healthBG,
        healthBar   = healthBar,
        nameLbl     = nameLbl,
        distLbl     = distLbl,
        hpLbl       = hpLbl,
        highlight   = highlight,
    }
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local obj = ESPObjects[player]

        if not Config.ESP.Enabled then
            if obj then
                obj.box.Visible       = false
                obj.healthBG.Visible  = false
                obj.healthBar.Visible = false
                obj.nameLbl.Visible   = false
                obj.distLbl.Visible   = false
                obj.hpLbl.Visible     = false
                if obj.highlight then obj.highlight.Adornee = nil end
            end
            continue
        end

        if not obj then CreateESP(player) obj = ESPObjects[player] end

        local char = GetCharacter(player)
        local hum  = GetHumanoid(char)
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        if not (char and hum and root and head and hum.Health > 0) then
            if obj then
                obj.box.Visible       = false
                obj.healthBG.Visible  = false
                obj.healthBar.Visible = false
                obj.nameLbl.Visible   = false
                obj.distLbl.Visible   = false
                obj.hpLbl.Visible     = false
                if obj.highlight then obj.highlight.Adornee = nil end
            end
            continue
        end

        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local distance = myRoot and (root.Position - myRoot.Position).Magnitude or 0

        if distance > Config.ESP.MaxDistance then
            obj.box.Visible       = false
            obj.healthBG.Visible  = false
            obj.healthBar.Visible = false
            obj.nameLbl.Visible   = false
            obj.distLbl.Visible   = false
            obj.hpLbl.Visible     = false
            if obj.highlight then obj.highlight.Adornee = nil end
            continue
        end

        -- Вычисляем 2D bounding box через голову и ноги
        local topPos, topOnScreen   = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y / 2, 0))
        local botPos, botOnScreen   = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

        if not (topOnScreen and botOnScreen) then
            obj.box.Visible       = false
            obj.healthBG.Visible  = false
            obj.healthBar.Visible = false
            obj.nameLbl.Visible   = false
            obj.distLbl.Visible   = false
            obj.hpLbl.Visible     = false
            continue
        end

        local height = math.abs(botPos.Y - topPos.Y)
        local width  = height * 0.5
        local x      = topPos.X - width / 2
        local y      = topPos.Y

        -- Коробка
        if Config.ESP.ShowBox then
            obj.box.Size     = Vector2.new(width, height)
            obj.box.Position = Vector2.new(x, y)
            obj.box.Visible  = true
        else
            obj.box.Visible = false
        end

        -- Полоска здоровья
        if Config.ESP.ShowHealth then
            local hpRatio  = hum.Health / hum.MaxHealth
            local barH     = height
            local barW     = 5
            local barX     = x - barW - 3
            local barY     = y

            obj.healthBG.Size     = Vector2.new(barW, barH)
            obj.healthBG.Position = Vector2.new(barX, barY)
            obj.healthBG.Visible  = true

            obj.healthBar.Size     = Vector2.new(barW, barH * hpRatio)
            obj.healthBar.Position = Vector2.new(barX, barY + barH * (1 - hpRatio))
            obj.healthBar.Visible  = true

            obj.hpLbl.Text     = math.floor(hum.Health) .. " HP"
            obj.hpLbl.Position = Vector2.new(barX - 2, y - 14)
            obj.hpLbl.Visible  = true
        else
            obj.healthBG.Visible  = false
            obj.healthBar.Visible = false
            obj.hpLbl.Visible     = false
        end

        -- Имя
        if Config.ESP.ShowName then
            obj.nameLbl.Text     = player.DisplayName
            obj.nameLbl.Position = Vector2.new(x + width / 2, y - 16)
            obj.nameLbl.Visible  = true
        else
            obj.nameLbl.Visible = false
        end

        -- Дистанция
        if Config.ESP.ShowDistance then
            obj.distLbl.Text     = math.floor(distance) .. " m"
            obj.distLbl.Position = Vector2.new(x + width / 2, y + height + 2)
            obj.distLbl.Visible  = true
        else
            obj.distLbl.Visible = false
        end

        -- Подсветка через стены
        if Config.ESP.HighlightThrough and obj.highlight then
            obj.highlight.Adornee = char
        elseif obj.highlight then
            obj.highlight.Adornee = nil
        end
    end
end

-- Удаление ESP при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- ══════════════════════════════════════════
--               АИМБОТ ЛОГИКА
-- ══════════════════════════════════════════

local function UpdateAimBot()
    -- FOV круг
    local vpSize = Camera.ViewportSize
    FOVCircle.Position  = Vector2.new(vpSize.X / 2, vpSize.Y / 2)
    FOVCircle.Visible   = Config.AimBot.Enabled and Config.AimBot.ShowFOV

    if not Config.AimBot.Enabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

    local target = GetClosestPlayerToMouse()
    if not target then return end

    local char = GetCharacter(target)
    if not char then return end

    local part = char:FindFirstChild(Config.AimBot.HitPart) or char:FindFirstChild("HumanoidRootPart")
    if not part then return end

    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return end

    -- Плавный аим
    local currentX, currentY = Mouse.X, Mouse.Y
    local targetX, targetY   = screenPos.X, screenPos.Y
    local smooth             = Config.AimBot.Smooth

    local newX = currentX + (targetX - currentX) * smooth
    local newY = currentY + (targetY - currentY) * smooth

    -- mousemoverel работает в большинстве эксплойт-клиентов
    if mousemoverel then
        mousemoverel(newX - currentX, newY - currentY)
    elseif Mouse.Move then
        Mouse:Move(newX, newY)
    end
end

-- ══════════════════════════════════════════
--               ГЛАВНЫЙ ЦИКЛ
-- ══════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    UpdateAimBot()
    UpdateESP()
end)

-- ══════════════════════════════════════════
print("[ ghost v2 ] loaded — нажми кнопку ghost")
-- ══════════════════════════════════════════

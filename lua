--[[
 ██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗    ██╗   ██╗██████╗ 
██╔════╝ ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝    ██║   ██║╚════██╗
██║  ███╗███████║██║   ██║███████╗   ██║       ██║   ██║ █████╔╝
██║   ██║██╔══██║██║   ██║╚════██║   ██║       ╚██╗ ██╔╝██╔═══╝ 
╚██████╔╝██║  ██║╚██████╔╝███████║   ██║        ╚████╔╝ ███████╗
 ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝         ╚═══╝  ╚══════╝
                        RIVALS SCRIPT
         Aimbot + ESP + Beautiful Glass UI
         Author: ghost v2 | Optimized Build
]]--

-- ═══════════════════════════════════════════════════════════════
--                        SERVICES
-- ═══════════════════════════════════════════════════════════════

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local StarterGui         = game:GetService("StarterGui")
local Workspace          = game:GetService("Workspace")

local Camera             = Workspace.CurrentCamera
local LP                 = Players.LocalPlayer
local Mouse              = LP:GetMouse()

-- ═══════════════════════════════════════════════════════════════
--                       CONSTANTS
-- ═══════════════════════════════════════════════════════════════

local SCREEN             = Camera.ViewportSize
local PI                 = math.pi
local HALF               = 0.5
local INF                = math.huge

local VERSION            = "v2.0"
local SCRIPT_NAME        = "ghost"

-- Цветовая палитра
local COLORS = {
    BG_DARK        = Color3.fromRGB(20,  20,  26),
    BG_MID         = Color3.fromRGB(28,  28,  36),
    BG_LIGHT       = Color3.fromRGB(38,  38,  48),
    ACCENT         = Color3.fromRGB(120, 180, 255),
    ACCENT2        = Color3.fromRGB(160, 120, 255),
    WHITE          = Color3.fromRGB(255, 255, 255),
    GRAY_LIGHT     = Color3.fromRGB(200, 200, 215),
    GRAY_MID       = Color3.fromRGB(140, 140, 160),
    GRAY_DARK      = Color3.fromRGB(80,  80,  95),
    GREEN          = Color3.fromRGB(80,  220, 140),
    RED            = Color3.fromRGB(255, 80,  80),
    YELLOW         = Color3.fromRGB(255, 210, 60),
    GLASS_WHITE    = Color3.fromRGB(255, 255, 255),
    STROKE         = Color3.fromRGB(180, 180, 210),
    TOGGLE_OFF     = Color3.fromRGB(50,  50,  62),
    TOGGLE_ON      = Color3.fromRGB(80,  200, 140),
    ESP_BOX        = Color3.fromRGB(200, 200, 220),
    ESP_HEALTH     = Color3.fromRGB(80,  220, 120),
    ESP_NAME       = Color3.fromRGB(255, 255, 255),
    ESP_DIST       = Color3.fromRGB(160, 180, 210),
    ESP_HIGHLIGHT  = Color3.fromRGB(140, 160, 255),
    FOV_CIRCLE     = Color3.fromRGB(200, 200, 230),
}

-- Шрифты
local FONTS = {
    BOLD     = Enum.Font.GothamBold,
    SEMI     = Enum.Font.GothamSemibold,
    REGULAR  = Enum.Font.Gotham,
    MONO     = Enum.Font.Code,
}

-- ═══════════════════════════════════════════════════════════════
--                       CONFIGURATION
-- ═══════════════════════════════════════════════════════════════

local Config = {
    -- ── Аимбот ──────────────────────────────────────
    Aimbot = {
        Enabled       = false,
        Smooth        = 0.15,       -- 0.05=быстрый, 0.5=медленный
        FOV           = 200,        -- радиус в пикселях
        HitPart       = "Head",     -- "Head" / "HumanoidRootPart" / "Neck"
        ShowFOV       = true,
        FOVFilled     = false,
        PredictMotion = true,       -- упреждение движения
        PredictFactor = 0.08,       -- сила упреждения
        TriggerOnRMB  = true,       -- активация на ПКМ
        SilentAim     = false,      -- тихий аим
    },

    -- ── ESP ─────────────────────────────────────────
    ESP = {
        Enabled       = false,
        Box           = true,
        BoxStyle      = "Corner",   -- "Full" / "Corner"
        HealthBar     = true,
        HealthText    = true,
        Name          = true,
        Distance      = true,
        Highlight     = true,
        MaxDist       = 800,
        BoxThick      = 1.4,
        CornerLen     = 6,
    },

    -- ── Визуал ──────────────────────────────────────
    Visual = {
        Crosshair     = false,
        FPSCounter    = true,
        PingDisplay   = true,
    },

    -- ── UI ──────────────────────────────────────────
    UI = {
        Opacity       = 0.06,
        AnimSpeed     = 0.25,
        RainbowTitle  = true,
    },
}

-- ═══════════════════════════════════════════════════════════════
--                     UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local Utils = {}

function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

function Utils.clamp(v, min, max)
    return math.max(min, math.min(max, v))
end

function Utils.round(n, dec)
    dec = dec or 0
    local m = 10 ^ dec
    return math.floor(n * m + 0.5) / m
end

function Utils.getCharacter(player)
    return player and player.Character or nil
end

function Utils.getHumanoid(char)
    return char and char:FindFirstChildOfClass("Humanoid") or nil
end

function Utils.getRootPart(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildOfClass("BasePart")) or nil
end

function Utils.getHead(char)
    return char and char:FindFirstChild("Head") or nil
end

function Utils.isAlive(player)
    local c = Utils.getCharacter(player)
    local h = Utils.getHumanoid(c)
    return c ~= nil and h ~= nil and h.Health > 0
end

function Utils.worldToScreen(pos)
    local sp, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), onScreen, sp.Z
end

function Utils.getDistance(a, b)
    return (a - b).Magnitude
end

function Utils.screenDistance(a, b)
    return (a - b).Magnitude
end

function Utils.getMousePos()
    return Vector2.new(Mouse.X, Mouse.Y)
end

function Utils.getPing()
    local ok, ping = pcall(function()
        return math.floor(LP:GetNetworkPing() * 1000)
    end)
    return ok and ping or 0
end

function Utils.hpColor(ratio)
    ratio = Utils.clamp(ratio, 0, 1)
    if ratio > 0.6 then
        return Utils.lerpColor(COLORS.YELLOW, COLORS.GREEN, (ratio - 0.6) / 0.4)
    else
        return Utils.lerpColor(COLORS.RED, COLORS.YELLOW, ratio / 0.6)
    end
end

function Utils.lerpColor(c1, c2, t)
    t = Utils.clamp(t, 0, 1)
    return Color3.new(
        Utils.lerp(c1.R, c2.R, t),
        Utils.lerp(c1.G, c2.G, t),
        Utils.lerp(c1.B, c2.B, t)
    )
end

function Utils.rainbowColor(offset)
    local h = (tick() * 0.3 + (offset or 0)) % 1
    return Color3.fromHSV(h, 0.55, 1)
end

function Utils.tweenQuick(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function Utils.tweenBounce(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props):Play()
end

-- ═══════════════════════════════════════════════════════════════
--                    DRAWING UTILITY
-- ═══════════════════════════════════════════════════════════════

local Draw = {}

function Draw.newLine(props)
    local l = Drawing.new("Line")
    l.Visible      = false
    l.Color        = props.Color        or COLORS.WHITE
    l.Thickness    = props.Thickness    or 1
    l.Transparency = props.Transparency or 1
    l.ZIndex       = props.ZIndex       or 1
    return l
end

function Draw.newSquare(props)
    local s = Drawing.new("Square")
    s.Visible      = false
    s.Color        = props.Color        or COLORS.WHITE
    s.Thickness    = props.Thickness    or 1
    s.Filled       = props.Filled       or false
    s.Transparency = props.Transparency or 1
    s.ZIndex       = props.ZIndex       or 1
    return s
end

function Draw.newCircle(props)
    local c = Drawing.new("Circle")
    c.Visible      = false
    c.Color        = props.Color        or COLORS.WHITE
    c.Thickness    = props.Thickness    or 1
    c.Filled       = props.Filled       or false
    c.Transparency = props.Transparency or 1
    c.ZIndex       = props.ZIndex       or 1
    c.Radius       = props.Radius       or 100
    return c
end

function Draw.newText(props)
    local t = Drawing.new("Text")
    t.Visible      = false
    t.Color        = props.Color        or COLORS.WHITE
    t.Size         = props.Size         or 13
    t.Font         = props.Font         or 2
    t.Center       = props.Center       or false
    t.Outline      = props.Outline ~= nil and props.Outline or true
    t.OutlineColor = props.OutlineColor or Color3.new(0,0,0)
    t.Transparency = props.Transparency or 1
    t.ZIndex       = props.ZIndex       or 1
    t.Text         = props.Text         or ""
    return t
end

function Draw.remove(obj)
    if obj and obj.Remove then pcall(function() obj:Remove() end) end
end

-- ═══════════════════════════════════════════════════════════════
--                      GUI BUILDER
-- ═══════════════════════════════════════════════════════════════

local GUI = {}

function GUI.newInstance(class, parent, props)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            pcall(function() inst[k] = v end)
        end
    end
    if parent then inst.Parent = parent end
    return inst
end

function GUI.addCorner(parent, radius)
    return GUI.newInstance("UICorner", parent, {
        CornerRadius = UDim.new(0, radius or 8)
    })
end

function GUI.addStroke(parent, color, thickness, transparency)
    return GUI.newInstance("UIStroke", parent, {
        Color        = color        or COLORS.STROKE,
        Thickness    = thickness    or 1,
        Transparency = transparency or 0.3,
    })
end

function GUI.addGradient(parent, colors, rotation)
    local kps = {}
    for i, c in ipairs(colors) do
        kps[i] = ColorSequenceKeypoint.new((i-1)/(#colors-1), c)
    end
    return GUI.newInstance("UIGradient", parent, {
        Color    = ColorSequence.new(kps),
        Rotation = rotation or 0,
    })
end

function GUI.addPadding(parent, t, b, l, r)
    return GUI.newInstance("UIPadding", parent, {
        PaddingTop    = UDim.new(0, t or 4),
        PaddingBottom = UDim.new(0, b or 4),
        PaddingLeft   = UDim.new(0, l or 4),
        PaddingRight  = UDim.new(0, r or 4),
    })
end

function GUI.addListLayout(parent, padding, direction)
    return GUI.newInstance("UIListLayout", parent, {
        Padding         = UDim.new(0, padding or 6),
        FillDirection   = direction or Enum.FillDirection.Vertical,
        SortOrder       = Enum.SortOrder.LayoutOrder,
    })
end

function GUI.frame(parent, size, pos, color, trans)
    return GUI.newInstance("Frame", parent, {
        Size                   = size or UDim2.new(1,0,1,0),
        Position               = pos  or UDim2.new(0,0,0,0),
        BackgroundColor3       = color or COLORS.BG_MID,
        BackgroundTransparency = trans or 0,
        BorderSizePixel        = 0,
    })
end

function GUI.textLabel(parent, size, pos, text, textSize, font, color, xAlign)
    return GUI.newInstance("TextLabel", parent, {
        Size                   = size,
        Position               = pos  or UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        Text                   = text or "",
        TextSize               = textSize or 13,
        Font                   = font or FONTS.REGULAR,
        TextColor3             = color or COLORS.WHITE,
        TextXAlignment         = xAlign or Enum.TextXAlignment.Left,
        BorderSizePixel        = 0,
    })
end

function GUI.textButton(parent, size, pos, text, textSize, font, color)
    return GUI.newInstance("TextButton", parent, {
        Size                   = size,
        Position               = pos or UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        Text                   = text or "",
        TextSize               = textSize or 13,
        Font                   = font or FONTS.REGULAR,
        TextColor3             = color or COLORS.WHITE,
        AutoButtonColor        = false,
        BorderSizePixel        = 0,
    })
end

-- ═══════════════════════════════════════════════════════════════
--                     SCREEN GUI ROOT
-- ═══════════════════════════════════════════════════════════════

local ScreenGui = GUI.newInstance("ScreenGui", nil, {
    Name            = "GhostV2_UI",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    DisplayOrder    = 999,
})

local parentSuccess = pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
end)
if not parentSuccess or not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = LP:WaitForChild("PlayerGui") end)
end

-- ═══════════════════════════════════════════════════════════════
--                    TOGGLE BUTTON "ghost"
-- ═══════════════════════════════════════════════════════════════

local ToggleContainer = GUI.frame(ScreenGui,
    UDim2.new(0, 78, 0, 32),
    UDim2.new(0, 10, 0.5, -16),
    COLORS.BG_DARK, 0.05
)
ToggleContainer.ZIndex = 10
GUI.addCorner(ToggleContainer, 10)

GUI.addGradient(ToggleContainer, {
    Color3.fromRGB(30,30,38),
    Color3.fromRGB(45,45,58),
    Color3.fromRGB(30,30,38),
}, 135)

GUI.addStroke(ToggleContainer, COLORS.STROKE, 1, 0.4)

local togGlare = GUI.frame(ToggleContainer,
    UDim2.new(1,0,0.5,0),
    UDim2.new(0,0,0,0),
    COLORS.WHITE, 0.92
)
togGlare.ZIndex = 11
GUI.addCorner(togGlare, 10)

local ToggleBtn = GUI.textButton(ToggleContainer,
    UDim2.new(1,0,1,0), nil,
    SCRIPT_NAME, 14, FONTS.BOLD, COLORS.WHITE
)
ToggleBtn.ZIndex = 12

local togTextGrad = GUI.newInstance("UIGradient", ToggleBtn, {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(150,150,170)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(150,150,170)),
    },
    Rotation = 0,
})

local StatusDot = GUI.frame(ToggleContainer,
    UDim2.new(0,6,0,6),
    UDim2.new(1,-9,0,4),
    COLORS.GRAY_DARK, 0
)
StatusDot.ZIndex = 13
GUI.addCorner(StatusDot, 3)

-- ═══════════════════════════════════════════════════════════════
--                      MAIN MENU WINDOW
-- ═══════════════════════════════════════════════════════════════

local MenuWindow = GUI.frame(ScreenGui,
    UDim2.new(0, 340, 0, 480),
    UDim2.new(0.5, -170, 0, 8),
    COLORS.BG_DARK, Config.UI.Opacity
)
MenuWindow.ZIndex = 20
MenuWindow.Visible = false
GUI.addCorner(MenuWindow, 16)

GUI.addGradient(MenuWindow, {
    Color3.fromRGB(22,22,30),
    Color3.fromRGB(32,32,42),
    Color3.fromRGB(20,20,28),
}, 145)

local menuStroke = GUI.addStroke(MenuWindow, COLORS.STROKE, 1.2, 0.25)

-- Стеклянный блик
local GlassTop = GUI.frame(MenuWindow,
    UDim2.new(1,0,0.38,0),
    UDim2.new(0,0,0,0),
    COLORS.WHITE, 0.90
)
GlassTop.ZIndex = 21
GUI.addCorner(GlassTop, 16)

local GlassSide = GUI.frame(MenuWindow,
    UDim2.new(0,2,1,-32),
    UDim2.new(0,0,0,16),
    COLORS.WHITE, 0.88
)
GlassSide.ZIndex = 21
GUI.addCorner(GlassSide, 2)

-- ═══════════════════════════════════════════════════════════════
--                        HEADER AREA
-- ═══════════════════════════════════════════════════════════════

local HeaderFrame = GUI.frame(MenuWindow,
    UDim2.new(1,0,0,50),
    UDim2.new(0,0,0,0),
    COLORS.BG_DARK, 0.5
)
HeaderFrame.ZIndex = 22
GUI.addCorner(HeaderFrame, 16)

local HeaderBot = GUI.frame(HeaderFrame,
    UDim2.new(1,0,0.5,0),
    UDim2.new(0,0,0.5,0),
    COLORS.BG_DARK, 0.5
)
HeaderBot.ZIndex = 22

local headerAccent = GUI.frame(HeaderFrame,
    UDim2.new(0,3,0,24),
    UDim2.new(0,14,0.5,-12),
    COLORS.ACCENT, 0
)
headerAccent.ZIndex = 24
GUI.addCorner(headerAccent, 2)

local TitleLabel = GUI.textLabel(HeaderFrame,
    UDim2.new(1,-18,1,0),
    UDim2.new(0,26,0,0),
    SCRIPT_NAME .. " " .. VERSION,
    20, FONTS.BOLD, COLORS.WHITE,
    Enum.TextXAlignment.Right
)
TitleLabel.ZIndex = 24

local titleShimmer = GUI.newInstance("UIGradient", TitleLabel, {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(130,130,155)),
        ColorSequenceKeypoint.new(0.35,Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.65,Color3.fromRGB(200,210,255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(130,130,155)),
    },
    Rotation = 0,
})

local SubTitle = GUI.textLabel(HeaderFrame,
    UDim2.new(1,-26,0,16),
    UDim2.new(0,26,1,-18),
    "rivals  •  aimbot  •  esp",
    10, FONTS.REGULAR, COLORS.GRAY_DARK,
    Enum.TextXAlignment.Right
)
SubTitle.ZIndex = 24

local Divider = GUI.frame(MenuWindow,
    UDim2.new(1,-24,0,1),
    UDim2.new(0,12,0,52),
    COLORS.STROKE, 0.55
)
Divider.ZIndex = 23

-- ═══════════════════════════════════════════════════════════════
--                     TAB NAVIGATION
-- ═══════════════════════════════════════════════════════════════

local TabContainer = GUI.frame(MenuWindow,
    UDim2.new(1,-24,0,30),
    UDim2.new(0,12,0,60),
    Color3.fromRGB(18,18,24), 0
)
TabContainer.ZIndex = 23
GUI.addCorner(TabContainer, 8)
GUI.addStroke(TabContainer, COLORS.STROKE, 1, 0.6)

local tabNames  = {"AIMBOT", "ESP", "VISUAL", "CONFIG"}
local tabBtns   = {}
local tabPages  = {}
local activeTab = 1

local function CreateTab(name, index)
    local btn = GUI.textButton(TabContainer,
        UDim2.new(1/#tabNames,0,1,0),
        UDim2.new((index-1)/#tabNames,0,0,0),
        name, 11, FONTS.BOLD,
        index == 1 and COLORS.WHITE or COLORS.GRAY_DARK
    )
    btn.ZIndex = 25
    local indicator = GUI.frame(btn,
        UDim2.new(0.7,0,0,2),
        UDim2.new(0.15,0,1,-2),
        COLORS.ACCENT, index == 1 and 0 or 1
    )
    indicator.ZIndex = 26
    GUI.addCorner(indicator, 1)
    tabBtns[index] = { btn = btn, indicator = indicator }
end

for i, name in ipairs(tabNames) do CreateTab(name, i) end

local PageContainer = GUI.frame(MenuWindow,
    UDim2.new(1,-24,0,360),
    UDim2.new(0,12,0,98),
    Color3.new(0,0,0), 1
)
PageContainer.ZIndex = 23
PageContainer.ClipsDescendants = true

for i = 1, #tabNames do
    local page = GUI.frame(PageContainer,
        UDim2.new(1,0,1,0), nil,
        Color3.new(0,0,0), 1
    )
    page.ZIndex = 24
    page.Visible = (i == 1)
    GUI.addListLayout(page, 6)
    GUI.addPadding(page, 4, 4, 0, 0)
    tabPages[i] = page
end

local function SwitchTab(index)
    if index == activeTab then return end
    for i, data in ipairs(tabBtns) do
        if i == index then
            Utils.tweenQuick(data.btn, 0.15, {TextColor3 = COLORS.WHITE})
            Utils.tweenQuick(data.indicator, 0.15, {BackgroundTransparency = 0})
        else
            Utils.tweenQuick(data.btn, 0.15, {TextColor3 = COLORS.GRAY_DARK})
            Utils.tweenQuick(data.indicator, 0.15, {BackgroundTransparency = 1})
        end
        tabPages[i].Visible = (i == index)
    end
    activeTab = index
end

for i, data in ipairs(tabBtns) do
    data.btn.MouseButton1Click:Connect(function() SwitchTab(i) end)
end

-- ═══════════════════════════════════════════════════════════════
--                    UI COMPONENTS
-- ═══════════════════════════════════════════════════════════════

local function CreateSection(page, text)
    local row = GUI.frame(page, UDim2.new(1,0,0,20), nil, Color3.new(0,0,0), 1)
    row.ZIndex = 25
    local lbl = GUI.textLabel(row,
        UDim2.new(1,-20,1,0), UDim2.new(0,8,0,0),
        "── " .. text:upper() .. " ──", 10, FONTS.BOLD, COLORS.GRAY_DARK
    )
    lbl.ZIndex = 26
    return row
end

local function CreateInfoRow(page, key, value)
    local row = GUI.frame(page, UDim2.new(1,0,0,28), nil, Color3.fromRGB(255,255,255), 0.96)
    row.ZIndex = 25
    GUI.addCorner(row, 8)
    local k = GUI.textLabel(row, UDim2.new(0.55,0,1,0), UDim2.new(0,10,0,0), key, 11, FONTS.SEMI, COLORS.GRAY_MID)
    k.ZIndex = 26
    local v = GUI.textLabel(row, UDim2.new(0.4,0,1,0), UDim2.new(0.55,0,0,0), value, 11, FONTS.BOLD, COLORS.ACCENT, Enum.TextXAlignment.Right)
    v.ZIndex = 26
    return row
end

-- ── Toggle ───────────────────────────────────────────────────
local function CreateToggle(page, labelText, descText, defaultVal, callback)
    local row = GUI.frame(page, UDim2.new(1,0,0,50), nil, Color3.fromRGB(255,255,255), 0.93)
    row.ZIndex = 25
    GUI.addCorner(row, 10)
    GUI.addStroke(row, COLORS.STROKE, 0.8, 0.65)

    local accentBar = GUI.frame(row, UDim2.new(0,3,0,22), UDim2.new(0,0,0.5,-11),
        defaultVal and COLORS.TOGGLE_ON or COLORS.GRAY_DARK, 0)
    accentBar.ZIndex = 26
    GUI.addCorner(accentBar, 2)

    local labelL = GUI.textLabel(row, UDim2.new(1,-70,0,20), UDim2.new(0,12,0,7),
        labelText, 13, FONTS.BOLD, defaultVal and COLORS.WHITE or COLORS.GRAY_LIGHT)
    labelL.ZIndex = 26

    if descText and descText ~= "" then
        local d = GUI.textLabel(row, UDim2.new(1,-70,0,14), UDim2.new(0,12,0,28),
            descText, 10, FONTS.REGULAR, COLORS.GRAY_DARK)
        d.ZIndex = 26
    end

    local switchBG = GUI.frame(row, UDim2.new(0,44,0,24), UDim2.new(1,-52,0.5,-12),
        defaultVal and COLORS.TOGGLE_ON or COLORS.TOGGLE_OFF, 0)
    switchBG.ZIndex = 26
    GUI.addCorner(switchBG, 12)

    local knob = GUI.frame(switchBG, UDim2.new(0,18,0,18),
        defaultVal and UDim2.new(0,23,0.5,-9) or UDim2.new(0,3,0.5,-9),
        COLORS.WHITE, 0)
    knob.ZIndex = 27
    GUI.addCorner(knob, 9)

    local knobGlare = GUI.frame(knob, UDim2.new(1,0,0.5,0), nil, COLORS.WHITE, 0.7)
    knobGlare.ZIndex = 28
    GUI.addCorner(knobGlare, 9)

    local state = defaultVal or false
    local clickBtn = GUI.textButton(row, UDim2.new(1,0,1,0), nil, "", 0)
    clickBtn.ZIndex = 30

    local function setState(newState)
        state = newState
        local kPos = state and UDim2.new(0,23,0.5,-9) or UDim2.new(0,3,0.5,-9)
        Utils.tweenQuick(switchBG, 0.2, {BackgroundColor3 = state and COLORS.TOGGLE_ON or COLORS.TOGGLE_OFF})
        Utils.tweenQuick(knob,     0.2, {Position = kPos})
        Utils.tweenQuick(labelL,   0.15,{TextColor3 = state and COLORS.WHITE or COLORS.GRAY_LIGHT})
        Utils.tweenQuick(accentBar,0.2, {BackgroundColor3 = state and COLORS.TOGGLE_ON or COLORS.GRAY_DARK})
        if callback then callback(state) end
    end

    clickBtn.MouseButton1Click:Connect(function() setState(not state) end)
    return { setState = setState, getState = function() return state end, row = row }
end

-- ── Slider ───────────────────────────────────────────────────
local function CreateSlider(page, labelText, minVal, maxVal, defaultVal, step, callback)
    local row = GUI.frame(page, UDim2.new(1,0,0,54), nil, Color3.fromRGB(255,255,255), 0.93)
    row.ZIndex = 25
    GUI.addCorner(row, 10)
    GUI.addStroke(row, COLORS.STROKE, 0.8, 0.65)

    local lbl = GUI.textLabel(row, UDim2.new(1,-60,0,16), UDim2.new(0,12,0,6),
        labelText, 12, FONTS.BOLD, COLORS.GRAY_LIGHT)
    lbl.ZIndex = 26

    local valLbl = GUI.textLabel(row, UDim2.new(0,50,0,16), UDim2.new(1,-58,0,6),
        tostring(defaultVal), 12, FONTS.BOLD, COLORS.ACCENT, Enum.TextXAlignment.Right)
    valLbl.ZIndex = 26

    local trackBG = GUI.frame(row, UDim2.new(1,-24,0,6), UDim2.new(0,12,0,32),
        Color3.fromRGB(30,30,40), 0)
    trackBG.ZIndex = 26
    GUI.addCorner(trackBG, 3)

    local ratio = (defaultVal - minVal) / (maxVal - minVal)
    local trackFill = GUI.frame(trackBG, UDim2.new(ratio,0,1,0), nil, COLORS.ACCENT, 0)
    trackFill.ZIndex = 27
    GUI.addCorner(trackFill, 3)
    GUI.addGradient(trackFill, {COLORS.ACCENT, COLORS.ACCENT2}, 90)

    local sliderKnob = GUI.frame(trackBG, UDim2.new(0,14,0,14),
        UDim2.new(ratio,-7,0.5,-7), COLORS.WHITE, 0)
    sliderKnob.ZIndex = 28
    GUI.addCorner(sliderKnob, 7)

    local currentVal = defaultVal
    local dragging   = false

    local function updateSlider(inputPos)
        local absPos  = trackBG.AbsolutePosition
        local absSize = trackBG.AbsoluteSize
        local rel = Utils.clamp((inputPos.X - absPos.X) / absSize.X, 0, 1)
        local raw = minVal + rel * (maxVal - minVal)
        if step and step > 0 then raw = math.floor(raw / step + 0.5) * step end
        raw = Utils.clamp(raw, minVal, maxVal)
        currentVal = raw
        local nr = (raw - minVal) / (maxVal - minVal)
        trackFill.Size      = UDim2.new(nr, 0, 1, 0)
        sliderKnob.Position = UDim2.new(nr, -7, 0.5, -7)
        local display = (step and step < 1) and Utils.round(raw, 2) or math.floor(raw)
        valLbl.Text = tostring(display)
        if callback then callback(raw) end
    end

    local clickArea = GUI.textButton(row, UDim2.new(1,0,1,0), nil, "", 0)
    clickArea.ZIndex = 30
    clickArea.MouseButton1Down:Connect(function()
        dragging = true
        updateSlider(UserInputService:GetMouseLocation())
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(UserInputService:GetMouseLocation())
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    return { getValue = function() return currentVal end, row = row }
end

-- ── Dropdown ─────────────────────────────────────────────────
local function CreateDropdown(page, labelText, options, defaultIdx, callback)
    local row = GUI.frame(page, UDim2.new(1,0,0,44), nil, Color3.fromRGB(255,255,255), 0.93)
    row.ZIndex = 25
    GUI.addCorner(row, 10)
    GUI.addStroke(row, COLORS.STROKE, 0.8, 0.65)

    GUI.textLabel(row, UDim2.new(0.5,0,0,16), UDim2.new(0,12,0,6),
        labelText, 12, FONTS.BOLD, COLORS.GRAY_LIGHT).ZIndex = 26

    local selectedLbl = GUI.textLabel(row, UDim2.new(0.4,-12,0,20), UDim2.new(0.5,6,0.5,-10),
        options[defaultIdx] or options[1], 12, FONTS.BOLD, COLORS.ACCENT, Enum.TextXAlignment.Right)
    selectedLbl.ZIndex = 26

    local arrow = GUI.textLabel(row, UDim2.new(0,16,0,16), UDim2.new(1,-22,0.5,-8),
        "▾", 14, FONTS.BOLD, COLORS.GRAY_MID)
    arrow.ZIndex = 26

    local dropList = GUI.frame(ScreenGui,
        UDim2.new(0,100,0,0), UDim2.new(0,0,0,0),
        COLORS.BG_DARK, 0)
    dropList.Visible = false
    dropList.ZIndex  = 50
    GUI.addCorner(dropList, 8)
    GUI.addStroke(dropList, COLORS.STROKE, 1, 0.4)
    GUI.addListLayout(dropList, 2)
    GUI.addPadding(dropList, 4, 4, 4, 4)

    local currentIdx = defaultIdx or 1
    local dropOpen   = false

    local function closeDropdown()
        dropList.Visible = false
        dropOpen = false
        Utils.tweenQuick(arrow, 0.15, {Rotation = 0})
    end

    local function openDropdown()
        local absPos = row.AbsolutePosition
        dropList.Size     = UDim2.new(0, row.AbsoluteSize.X, 0, #options * 28 + 12)
        dropList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + row.AbsoluteSize.Y + 4)
        dropList.Visible  = true
        dropOpen = true
        Utils.tweenQuick(arrow, 0.15, {Rotation = 180})
    end

    for i, opt in ipairs(options) do
        local optRow = GUI.frame(dropList, UDim2.new(1,0,0,26), nil,
            i == currentIdx and COLORS.ACCENT or Color3.new(0,0,0),
            i == currentIdx and 0.85 or 1)
        optRow.ZIndex = 51
        GUI.addCorner(optRow, 6)

        local optLbl = GUI.textLabel(optRow, UDim2.new(1,-16,1,0), UDim2.new(0,8,0,0),
            opt, 12, FONTS.SEMI,
            i == currentIdx and COLORS.WHITE or COLORS.GRAY_MID)
        optLbl.ZIndex = 52

        local optClick = GUI.textButton(optRow, UDim2.new(1,0,1,0), nil, "", 0)
        optClick.ZIndex = 53
        optClick.MouseButton1Click:Connect(function()
            currentIdx = i
            selectedLbl.Text = opt
            if callback then callback(opt, i) end
            closeDropdown()
        end)
    end

    local clickBtn = GUI.textButton(row, UDim2.new(1,0,1,0), nil, "", 0)
    clickBtn.ZIndex = 30
    clickBtn.MouseButton1Click:Connect(function()
        if dropOpen then closeDropdown() else openDropdown() end
    end)

    return { getValue = function() return options[currentIdx], currentIdx end, row = row }
end

-- ═══════════════════════════════════════════════════════════════
--                  PAGE 1: AIMBOT SETTINGS
-- ═══════════════════════════════════════════════════════════════

local P1 = tabPages[1]

CreateSection(P1, "Основные")

CreateToggle(P1, "Aimbot", "Автоматический прицел",
    Config.Aimbot.Enabled, function(v) Config.Aimbot.Enabled = v end)

CreateToggle(P1, "Silent Aim", "Без движения мыши",
    Config.Aimbot.SilentAim, function(v) Config.Aimbot.SilentAim = v end)

CreateToggle(P1, "Prediction", "Упреждение движения",
    Config.Aimbot.PredictMotion, function(v) Config.Aimbot.PredictMotion = v end)

CreateSection(P1, "Параметры")

CreateSlider(P1, "Плавность", 1, 100,
    math.floor((1 - Config.Aimbot.Smooth) * 100), 1,
    function(v) Config.Aimbot.Smooth = 1 - (v / 100) end)

CreateSlider(P1, "Радиус FOV", 50, 600,
    Config.Aimbot.FOV, 10,
    function(v) Config.Aimbot.FOV = v end)

CreateToggle(P1, "Показывать FOV", "",
    Config.Aimbot.ShowFOV, function(v) Config.Aimbot.ShowFOV = v end)

CreateDropdown(P1, "Цель стрельбы",
    {"Head", "HumanoidRootPart", "Neck", "UpperTorso"},
    1, function(v) Config.Aimbot.HitPart = v end)

-- ═══════════════════════════════════════════════════════════════
--                  PAGE 2: ESP SETTINGS
-- ═══════════════════════════════════════════════════════════════

local P2 = tabPages[2]

CreateSection(P2, "ESP")

CreateToggle(P2, "ESP", "Подсветка игроков",
    Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end)

CreateToggle(P2, "Коробка", "Рамка вокруг игрока",
    Config.ESP.Box, function(v) Config.ESP.Box = v end)

CreateToggle(P2, "Полоска здоровья", "",
    Config.ESP.HealthBar, function(v) Config.ESP.HealthBar = v end)

CreateToggle(P2, "Имя игрока", "",
    Config.ESP.Name, function(v) Config.ESP.Name = v end)

CreateToggle(P2, "Дистанция", "",
    Config.ESP.Distance, function(v) Config.ESP.Distance = v end)

CreateToggle(P2, "Подсветка через стены", "SelectionBox highlight",
    Config.ESP.Highlight, function(v) Config.ESP.Highlight = v end)

CreateSection(P2, "Параметры")

CreateSlider(P2, "Макс. дистанция", 100, 1000,
    Config.ESP.MaxDist, 50, function(v) Config.ESP.MaxDist = v end)

CreateDropdown(P2, "Стиль рамки",
    {"Corner", "Full"},
    1, function(v) Config.ESP.BoxStyle = v end)

-- ═══════════════════════════════════════════════════════════════
--                  PAGE 3: VISUAL SETTINGS
-- ═══════════════════════════════════════════════════════════════

local P3 = tabPages[3]

CreateSection(P3, "HUD")

CreateToggle(P3, "Прицел (Crosshair)", "",
    Config.Visual.Crosshair, function(v) Config.Visual.Crosshair = v end)

CreateToggle(P3, "FPS счётчик", "",
    Config.Visual.FPSCounter, function(v) Config.Visual.FPSCounter = v end)

CreateToggle(P3, "Пинг", "",
    Config.Visual.PingDisplay, function(v) Config.Visual.PingDisplay = v end)

CreateSection(P3, "UI")

CreateToggle(P3, "Радужный заголовок", "",
    Config.UI.RainbowTitle, function(v) Config.UI.RainbowTitle = v end)

-- ═══════════════════════════════════════════════════════════════
--                  PAGE 4: CONFIG / INFO
-- ═══════════════════════════════════════════════════════════════

local P4 = tabPages[4]

CreateSection(P4, "Бинды")
CreateInfoRow(P4, "Открыть/закрыть",  "ghost [кнопка]")
CreateInfoRow(P4, "Аимбот",           "ПКМ удерживать")
CreateInfoRow(P4, "Вкладки",          "Клик по вкладке")
CreateInfoRow(P4, "Перетаскивание",   "ЛКМ за заголовок")

CreateSection(P4, "Информация")
CreateInfoRow(P4, "Версия",           VERSION)
CreateInfoRow(P4, "Игра",             "Rivals")
CreateInfoRow(P4, "Aimbot цель",      "Ближайший в FOV")
CreateInfoRow(P4, "FOV радиус",       tostring(Config.Aimbot.FOV) .. "px")

-- ═══════════════════════════════════════════════════════════════
--                    BOTTOM STATUS BAR
-- ═══════════════════════════════════════════════════════════════

local BottomBar = GUI.frame(MenuWindow,
    UDim2.new(1,-24,0,22),
    UDim2.new(0,12,1,-28),
    Color3.fromRGB(18,18,24), 0.2
)
BottomBar.ZIndex = 23
GUI.addCorner(BottomBar, 6)

local BottomLeft = GUI.textLabel(BottomBar,
    UDim2.new(0.5,0,1,0), UDim2.new(0,8,0,0),
    "ghost " .. VERSION, 10, FONTS.BOLD, COLORS.GRAY_DARK)
BottomLeft.ZIndex = 24

local BottomRight = GUI.textLabel(BottomBar,
    UDim2.new(0.5,-8,1,0), UDim2.new(0.5,0,0,0),
    "FPS: 0  |  Ping: 0ms", 10, FONTS.REGULAR, COLORS.GRAY_DARK,
    Enum.TextXAlignment.Right)
BottomRight.ZIndex = 24

-- ═══════════════════════════════════════════════════════════════
--                  MENU OPEN / CLOSE LOGIC
-- ═══════════════════════════════════════════════════════════════

local menuOpen        = false
local menuTweenActive = false

local function OpenMenu()
    if menuTweenActive then return end
    menuTweenActive = true
    menuOpen        = true
    MenuWindow.Visible              = true
    MenuWindow.BackgroundTransparency = 1
    MenuWindow.Size = UDim2.new(0,300,0,430)
    Utils.tweenBounce(MenuWindow, Config.UI.AnimSpeed, {
        BackgroundTransparency = Config.UI.Opacity,
        Size = UDim2.new(0,340,0,480),
    })
    Utils.tweenQuick(StatusDot, 0.2, {BackgroundColor3 = COLORS.GREEN})
    task.delay(Config.UI.AnimSpeed + 0.05, function() menuTweenActive = false end)
end

local function CloseMenu()
    if menuTweenActive then return end
    menuTweenActive = true
    menuOpen        = false
    Utils.tweenQuick(MenuWindow, Config.UI.AnimSpeed * 0.8, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0,310,0,450),
    })
    Utils.tweenQuick(StatusDot, 0.2, {BackgroundColor3 = COLORS.GRAY_DARK})
    task.delay(Config.UI.AnimSpeed, function()
        MenuWindow.Visible  = false
        menuTweenActive     = false
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if menuOpen then CloseMenu() else OpenMenu() end
end)

ToggleBtn.MouseEnter:Connect(function()
    Utils.tweenQuick(ToggleContainer, 0.15, {BackgroundTransparency = 0})
end)
ToggleBtn.MouseLeave:Connect(function()
    Utils.tweenQuick(ToggleContainer, 0.15, {BackgroundTransparency = 0.05})
end)

-- ═══════════════════════════════════════════════════════════════
--                  DRAGGING MENU WINDOW
-- ═══════════════════════════════════════════════════════════════

local dragData = { active = false, startPos = nil, startWin = nil }

HeaderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.active   = true
        dragData.startPos = input.Position
        dragData.startWin = MenuWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragData.active and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragData.startPos
        MenuWindow.Position = UDim2.new(
            dragData.startWin.X.Scale, dragData.startWin.X.Offset + delta.X,
            dragData.startWin.Y.Scale, dragData.startWin.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.active = false
    end
end)

-- ═══════════════════════════════════════════════════════════════
--                     FOV CIRCLE
-- ═══════════════════════════════════════════════════════════════

local FOVCircle = Draw.newCircle({
    Color = COLORS.FOV_CIRCLE, Thickness = 1.2,
    Filled = false, Transparency = 0.6, Radius = Config.Aimbot.FOV,
})

local FOVDot = Draw.newCircle({
    Color = COLORS.ACCENT, Thickness = 1,
    Filled = true, Transparency = 0.8, Radius = 2,
})

-- ═══════════════════════════════════════════════════════════════
--                     CROSSHAIR
-- ═══════════════════════════════════════════════════════════════

local CrosshairLines = {}
for i = 1, 4 do
    CrosshairLines[i] = Draw.newLine({Color = COLORS.WHITE, Thickness = 1.5, Transparency = 0.9})
end

-- ═══════════════════════════════════════════════════════════════
--                       HUD OVERLAY
-- ═══════════════════════════════════════════════════════════════

local HudFrame = GUI.frame(ScreenGui,
    UDim2.new(0,140,0,48),
    UDim2.new(1,-148,1,-56),
    COLORS.BG_DARK, 0.2
)
HudFrame.ZIndex = 5
GUI.addCorner(HudFrame, 8)
GUI.addStroke(HudFrame, COLORS.STROKE, 1, 0.6)

local HudFPS  = GUI.textLabel(HudFrame, UDim2.new(1,-12,0,18), UDim2.new(0,8,0,4),
    "FPS  0", 12, FONTS.BOLD, COLORS.GRAY_MID)
HudFPS.ZIndex = 6

local HudPing = GUI.textLabel(HudFrame, UDim2.new(1,-12,0,18), UDim2.new(0,8,0,24),
    "PING  0ms", 12, FONTS.BOLD, COLORS.GRAY_MID)
HudPing.ZIndex = 6

-- ═══════════════════════════════════════════════════════════════
--                       ESP SYSTEM
-- ═══════════════════════════════════════════════════════════════

local ESP_DATA = {}

local function createESPForPlayer(player)
    if ESP_DATA[player] then return end
    local e = {}

    -- 8 угловых линий
    e.cornerLines = {}
    for i = 1, 8 do
        e.cornerLines[i] = Draw.newLine({
            Color = COLORS.ESP_BOX, Thickness = Config.ESP.BoxThick, Transparency = 1
        })
    end

    e.fullBox = Draw.newSquare({Color = COLORS.ESP_BOX, Thickness = Config.ESP.BoxThick, Transparency = 1})
    e.hpBG    = Draw.newSquare({Color = Color3.fromRGB(10,10,14), Filled = true, Transparency = 0.55})
    e.hpBar   = Draw.newSquare({Filled = true, Transparency = 1})
    e.hpLow   = Draw.newSquare({Filled = true, Transparency = 1})
    e.nameLbl = Draw.newText({Center = true, Size = 13, Transparency = 1})
    e.distLbl = Draw.newText({Center = true, Size = 11, Color = COLORS.ESP_DIST, Transparency = 1})
    e.hpText  = Draw.newText({Center = false, Size = 10, Color = COLORS.ESP_HEALTH, Transparency = 1})

    local sel = Instance.new("SelectionBox")
    sel.LineThickness        = 0.06
    sel.Color3               = COLORS.ESP_HIGHLIGHT
    sel.SurfaceColor3        = COLORS.ESP_HIGHLIGHT
    sel.SurfaceTransparency  = 0.82
    sel.Parent               = ScreenGui
    e.sel = sel

    ESP_DATA[player] = e
end

local function destroyESP(player)
    local e = ESP_DATA[player]
    if not e then return end
    for _, l in ipairs(e.cornerLines) do Draw.remove(l) end
    Draw.remove(e.fullBox); Draw.remove(e.hpBG); Draw.remove(e.hpBar)
    Draw.remove(e.hpLow);   Draw.remove(e.nameLbl); Draw.remove(e.distLbl)
    Draw.remove(e.hpText)
    pcall(function() e.sel:Destroy() end)
    ESP_DATA[player] = nil
end

local function hideESP(e)
    if not e then return end
    for _, l in ipairs(e.cornerLines) do l.Visible = false end
    e.fullBox.Visible = false; e.hpBG.Visible   = false
    e.hpBar.Visible   = false; e.hpLow.Visible  = false
    e.nameLbl.Visible = false; e.distLbl.Visible = false
    e.hpText.Visible  = false; e.sel.Adornee    = nil
end

local function drawCornerBox(e, x, y, w, h)
    local cl   = Config.ESP.CornerLen
    local col  = COLORS.ESP_BOX
    local ls   = e.cornerLines
    ls[1].From=Vector2.new(x,y);       ls[1].To=Vector2.new(x+cl,y)
    ls[2].From=Vector2.new(x,y);       ls[2].To=Vector2.new(x,y+cl)
    ls[3].From=Vector2.new(x+w,y);     ls[3].To=Vector2.new(x+w-cl,y)
    ls[4].From=Vector2.new(x+w,y);     ls[4].To=Vector2.new(x+w,y+cl)
    ls[5].From=Vector2.new(x,y+h);     ls[5].To=Vector2.new(x+cl,y+h)
    ls[6].From=Vector2.new(x,y+h);     ls[6].To=Vector2.new(x,y+h-cl)
    ls[7].From=Vector2.new(x+w,y+h);   ls[7].To=Vector2.new(x+w-cl,y+h)
    ls[8].From=Vector2.new(x+w,y+h);   ls[8].To=Vector2.new(x+w,y+h-cl)
    for _, l in ipairs(ls) do l.Color = col; l.Visible = true end
    e.fullBox.Visible = false
end

local function drawFullBox(e, x, y, w, h)
    e.fullBox.Size     = Vector2.new(w, h)
    e.fullBox.Position = Vector2.new(x, y)
    e.fullBox.Color    = COLORS.ESP_BOX
    e.fullBox.Visible  = true
    for _, l in ipairs(e.cornerLines) do l.Visible = false end
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end

        local e = ESP_DATA[player]

        if not Config.ESP.Enabled then
            if e then hideESP(e) end
            continue
        end

        if not e then createESPForPlayer(player); e = ESP_DATA[player] end

        local char = Utils.getCharacter(player)
        local hum  = Utils.getHumanoid(char)
        local root = Utils.getRootPart(char)
        local head = Utils.getHead(char)

        if not (char and hum and root and head and hum.Health > 0) then
            hideESP(e); continue
        end

        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local dist   = myRoot and Utils.getDistance(root.Position, myRoot.Position) or 0

        if dist > Config.ESP.MaxDist then hideESP(e); continue end

        local topPos, topOn = Utils.worldToScreen(head.Position + Vector3.new(0,0.7,0))
        local botPos, botOn = Utils.worldToScreen(root.Position - Vector3.new(0,3.2,0))

        if not (topOn and botOn and topPos.Y < botPos.Y) then hideESP(e); continue end

        local h = botPos.Y - topPos.Y
        local w = h * 0.5
        local x = topPos.X - w * HALF
        local y = topPos.Y

        -- Коробка
        if Config.ESP.Box then
            if Config.ESP.BoxStyle == "Corner" then
                drawCornerBox(e, x, y, w, h)
            else
                drawFullBox(e, x, y, w, h)
            end
        else
            for _, l in ipairs(e.cornerLines) do l.Visible = false end
            e.fullBox.Visible = false
        end

        -- HP бар
        if Config.ESP.HealthBar then
            local ratio = Utils.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local bx = x - 9; local by = y
            local bw = 5; local bh = h
            e.hpBG.Size     = Vector2.new(bw, bh)
            e.hpBG.Position = Vector2.new(bx, by)
            e.hpBG.Visible  = true
            local fillH = bh * ratio
            e.hpBar.Size     = Vector2.new(bw, fillH)
            e.hpBar.Position = Vector2.new(bx, by + bh - fillH)
            e.hpBar.Color    = Utils.hpColor(ratio)
            e.hpBar.Visible  = true
            if ratio < 0.25 then
                e.hpLow.Size     = Vector2.new(bw+2, fillH+2)
                e.hpLow.Position = Vector2.new(bx-1, by+bh-fillH-1)
                e.hpLow.Color    = COLORS.RED
                e.hpLow.Transparency = 0.5 + math.sin(tick() * 8) * 0.4
                e.hpLow.Visible  = true
            else
                e.hpLow.Visible = false
            end
            if Config.ESP.HealthText then
                e.hpText.Text     = math.ceil(hum.Health) .. " HP"
                e.hpText.Position = Vector2.new(bx - 1, y - 12)
                e.hpText.Color    = Utils.hpColor(ratio)
                e.hpText.Visible  = true
            else
                e.hpText.Visible = false
            end
        else
            e.hpBG.Visible   = false; e.hpBar.Visible  = false
            e.hpLow.Visible  = false; e.hpText.Visible = false
        end

        -- Имя
        if Config.ESP.Name then
            e.nameLbl.Text     = player.DisplayName
            e.nameLbl.Position = Vector2.new(x + w * HALF, y - 16)
            e.nameLbl.Color    = COLORS.ESP_NAME
            e.nameLbl.Visible  = true
        else
            e.nameLbl.Visible = false
        end

        -- Дистанция
        if Config.ESP.Distance then
            e.distLbl.Text     = "[" .. math.floor(dist) .. "m]"
            e.distLbl.Position = Vector2.new(x + w * HALF, y + h + 3)
            e.distLbl.Visible  = true
        else
            e.distLbl.Visible = false
        end

        -- Подсветка
        e.sel.Adornee = Config.ESP.Highlight and char or nil
    end
end

-- ═══════════════════════════════════════════════════════════════
--                    AIMBOT SYSTEM
-- ═══════════════════════════════════════════════════════════════

local Aimbot       = {}
local lastPositions= {}

function Aimbot.getVelocity(player)
    local char = Utils.getCharacter(player)
    local root = Utils.getRootPart(char)
    if not root then return Vector3.zero end
    local now = tick()
    local lp  = lastPositions[player]
    local vel = Vector3.zero
    if lp then
        local dt = now - lp.time
        if dt > 0 then vel = (root.Position - lp.pos) / dt end
    end
    lastPositions[player] = {pos = root.Position, time = now}
    return vel
end

function Aimbot.getPredictedPos(player)
    local char = Utils.getCharacter(player)
    if not char then return nil end
    local part = char:FindFirstChild(Config.Aimbot.HitPart) or Utils.getRootPart(char)
    if not part then return nil end
    local pos = part.Position
    if Config.Aimbot.PredictMotion then
        local vel  = Aimbot.getVelocity(player)
        local dist = Utils.getDistance(Camera.CFrame.Position, pos)
        local lag  = Utils.getPing() / 1000
        pos = pos + vel * (lag + Config.Aimbot.PredictFactor) * (dist / 120)
    end
    return pos
end

function Aimbot.getTarget()
    local mp   = Utils.getMousePos()
    local best = nil
    local bestDist = INF
    local bestScreen = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        if not Utils.isAlive(player) then continue end

        local targetPos = Aimbot.getPredictedPos(player)
        if not targetPos then continue end

        local sp, onScreen = Utils.worldToScreen(targetPos)
        if not onScreen then continue end

        local sd = Utils.screenDistance(sp, mp)
        if sd < Config.Aimbot.FOV and sd < bestDist then
            bestDist   = sd
            best       = player
            bestScreen = sp
        end
    end

    return best, bestScreen
end

function Aimbot.update()
    local vp = Camera.ViewportSize
    local cx = vp.X * HALF
    local cy = vp.Y * HALF

    FOVCircle.Position = Vector2.new(cx, cy)
    FOVCircle.Radius   = Config.Aimbot.FOV
    FOVCircle.Visible  = Config.Aimbot.Enabled and Config.Aimbot.ShowFOV

    FOVDot.Position = Vector2.new(cx, cy)
    FOVDot.Visible  = Config.Aimbot.Enabled and Config.Aimbot.ShowFOV

    if not Config.Aimbot.Enabled then return end
    if Config.Aimbot.TriggerOnRMB then
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    end

    local target, screenPos = Aimbot.getTarget()
    if not target or not screenPos then return end

    local mp = Utils.getMousePos()
    local dx = (screenPos.X - mp.X) * Config.Aimbot.Smooth
    local dy = (screenPos.Y - mp.Y) * Config.Aimbot.Smooth

    if Config.Aimbot.SilentAim then
        local char = Utils.getCharacter(target)
        local part = char and (char:FindFirstChild(Config.Aimbot.HitPart) or Utils.getRootPart(char))
        if part then
            local dir = (part.Position - Camera.CFrame.Position).Unit
            local cf  = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + dir)
            Camera.CFrame = Camera.CFrame:Lerp(cf, Config.Aimbot.Smooth * 0.5)
        end
    else
        if mousemoverel then
            mousemoverel(dx, dy)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
--                    CROSSHAIR UPDATE
-- ═══════════════════════════════════════════════════════════════

local function UpdateCrosshair()
    local visible = Config.Visual.Crosshair
    local vp = Camera.ViewportSize
    local cx = vp.X * HALF
    local cy = vp.Y * HALF
    local gap = 6; local len = 8

    CrosshairLines[1].From = Vector2.new(cx-gap-len,cy); CrosshairLines[1].To = Vector2.new(cx-gap,cy)
    CrosshairLines[2].From = Vector2.new(cx+gap,cy);     CrosshairLines[2].To = Vector2.new(cx+gap+len,cy)
    CrosshairLines[3].From = Vector2.new(cx,cy-gap-len); CrosshairLines[3].To = Vector2.new(cx,cy-gap)
    CrosshairLines[4].From = Vector2.new(cx,cy+gap);     CrosshairLines[4].To = Vector2.new(cx,cy+gap+len)

    for _, l in ipairs(CrosshairLines) do l.Visible = visible end
end

-- ═══════════════════════════════════════════════════════════════
--                      HUD UPDATE
-- ═══════════════════════════════════════════════════════════════

local fpsCounter = 0
local fpsClock   = 0
local fpsDisplay = 0

local function UpdateHUD(dt)
    HudFrame.Visible = Config.Visual.FPSCounter or Config.Visual.PingDisplay

    fpsCounter = fpsCounter + 1
    fpsClock   = fpsClock + dt
    if fpsClock >= 0.5 then
        fpsDisplay = math.floor(fpsCounter / fpsClock)
        fpsCounter = 0; fpsClock = 0
    end

    local ping = Utils.getPing()

    if Config.Visual.FPSCounter then
        local col = fpsDisplay >= 60 and COLORS.GREEN or fpsDisplay >= 30 and COLORS.YELLOW or COLORS.RED
        HudFPS.Text = "FPS  " .. fpsDisplay
        HudFPS.TextColor3 = col
        HudFPS.Visible = true
    else
        HudFPS.Visible = false
    end

    if Config.Visual.PingDisplay then
        local col = ping <= 60 and COLORS.GREEN or ping <= 120 and COLORS.YELLOW or COLORS.RED
        HudPing.Text = "PING  " .. ping .. "ms"
        HudPing.TextColor3 = col
        HudPing.Visible = true
    else
        HudPing.Visible = false
    end

    BottomRight.Text = "FPS: " .. fpsDisplay .. "  |  Ping: " .. ping .. "ms"
end

-- ═══════════════════════════════════════════════════════════════
--                  ANIMATION UPDATE LOOP
-- ═══════════════════════════════════════════════════════════════

local animTime = 0

local function UpdateAnimations(dt)
    animTime = animTime + dt

    -- Переливание кнопки
    togTextGrad.Rotation = math.floor((animTime * 55) % 360)

    -- Заголовок
    if Config.UI.RainbowTitle then
        local hue = (animTime * 0.14) % 1
        local c1  = Color3.fromHSV(hue, 0.4, 1)
        local c2  = Color3.fromHSV((hue + 0.18) % 1, 0.15, 1)
        titleShimmer.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(130,130,155)),
            ColorSequenceKeypoint.new(0.35,c1),
            ColorSequenceKeypoint.new(0.65,c2),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(130,130,155)),
        }
    else
        titleShimmer.Offset = Vector2.new(math.sin(animTime * 0.8) * 0.35, 0)
    end

    -- Акцентная полоска
    local pulse = (math.sin(animTime * 3) + 1) * HALF
    headerAccent.BackgroundTransparency = Utils.lerp(0.1, 0.5, pulse)
    if Config.UI.RainbowTitle then
        headerAccent.BackgroundColor3 = Utils.rainbowColor(0)
    end

    -- Точка статуса
    if menuOpen then
        StatusDot.BackgroundTransparency = Utils.lerp(0, 0.3, (math.sin(animTime * 4) + 1) * HALF)
    end
end

-- ═══════════════════════════════════════════════════════════════
--                   PLAYER MANAGEMENT
-- ═══════════════════════════════════════════════════════════════

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LP then createESPForPlayer(player) end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LP then
        createESPForPlayer(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            destroyESP(player)
            createESPForPlayer(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    destroyESP(player)
    lastPositions[player] = nil
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LP then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            destroyESP(player)
            createESPForPlayer(player)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════
--                     MAIN RENDER LOOP
-- ═══════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function(dt)
    UpdateAnimations(dt)
    UpdateHUD(dt)
    Aimbot.update()
    UpdateCrosshair()
end)

local espStep = 0
RunService.Heartbeat:Connect(function(dt)
    espStep = espStep + dt
    if espStep >= 0.016 then
        espStep = 0
        UpdateESP()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--                    CLEANUP ON REMOVE
-- ═══════════════════════════════════════════════════════════════

LP.AncestryChanged:Connect(function()
    pcall(function()
        FOVCircle:Remove(); FOVDot:Remove()
        for _, l in ipairs(CrosshairLines) do l:Remove() end
        for player, _ in pairs(ESP_DATA) do destroyESP(player) end
        ScreenGui:Destroy()
    end)
end)

-- ═══════════════════════════════════════════════════════════════
--                        STARTUP
-- ═══════════════════════════════════════════════════════════════

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title    = "ghost v2",
        Text     = "Загружен успешно! Нажми кнопку [ghost]",
        Duration = 5,
    })
end)

print("╔═══════════════════════════════╗")
print("║      ghost v2 — loaded ✓      ║")
print("║   Aimbot + ESP + Glass UI     ║")
print("║   Нажми кнопку [ghost]        ║")
print("╚═══════════════════════════════╝")

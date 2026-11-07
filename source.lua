--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║  Celestial UI Library for Roblox (Luau)                       ║
    ║  Копия ClickGUI майнкрафт-клиента Celestial                   ║
    ║  Загрузка:                                                    ║
    ║  local Library = loadstring(game:HttpGet(                     ║
    ║    "https://raw.githubusercontent.com/xolylol/celestial/"..   ║
    ║    "main/source.lua"))()                                      ║
    ║  Документация: GUIDE.md                                       ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Library = {}
Library.__index = Library
Library.Version = "1.0.0"
Library.Folder = "Celestial"                       -- папка в workspace экзекутора
Library.IconBase = "https://raw.githubusercontent.com/xolylol/celestial/main/icons/"
Library.Icons = {}                                 -- Library.Icons.combat = "rbxassetid://123" (необязательно)
Library.Language = "ru"                            -- "ru" | "en"
Library.NotifyOnToggle = true                      -- уведомления при вкл/выкл модуля
Library.ArrayListHide = { Render = true }          -- категории, скрытые в Array List
Library.Visible = false
Library.Modules = {}
Library.Categories = {}
Library.Windows = {}

-- ───────────────────────────── окружение ─────────────────────────────
local genv = (getgenv and getgenv()) or _G
if genv.CelestialLibrary and type(genv.CelestialLibrary.Unload) == "function" then
    pcall(function() genv.CelestialLibrary:Unload() end)
end
genv.CelestialLibrary = Library

local function svc(name)
    local s = game:GetService(name)
    if cloneref then
        local ok, r = pcall(cloneref, s)
        if ok and r then s = r end
    end
    return s
end

local Players = svc("Players")
local RunService = svc("RunService")
local UIS = svc("UserInputService")
local TweenService = svc("TweenService")
local HttpService = svc("HttpService")
local Lighting = svc("Lighting")
local TextService = svc("TextService")
local LocalPlayer = Players.LocalPlayer

local function guiParent()
    if gethui then
        local ok, r = pcall(gethui)
        if ok and r then return r end
    end
    local ok, cg = pcall(function() return svc("CoreGui") end)
    if ok and cg then
        local probe = Instance.new("Folder")
        local ok2 = pcall(function() probe.Parent = cg end)
        if ok2 and probe.Parent == cg then
            probe:Destroy()
            return cg
        end
        pcall(function() probe:Destroy() end)
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ───────────────────────────── локализация ─────────────────────────────
Library.Languages = {
    ru = {
        Search = "Поиск", Logout = "Выйти", Settings = "Настройка",
        OpenMenu = "Открыть меню", Color = "Цвет", ModeClient = "Клиентский", ModeCustom = "Кастомный",
        FirstColor = "Первый цвет", SecondColor = "Второй цвет", ColorSpeed = "Скорость цвета",
        ColorBlend = "Смешивание цветов", Blur = "Размытие", Glow = "Свечение",
        Enabled = "включен", Disabled = "выключен", Selected = "выбрано", NothingSelected = "Не выбрано",
        ConfigName = "Название конфига", Save = "Сохранить", Load = "Загрузить", Delete = "Удалить",
        Created = "Конфиг сохранён", Loaded = "Конфиг загружен", Deleted = "Конфиг удалён",
        NoConfigs = "Конфигов пока нет", Themes = "Темы", Configs = "Конфиги", Press = "Нажмите клавишу...",
    },
    en = {
        Search = "Search", Logout = "Logout", Settings = "Settings",
        OpenMenu = "Open menu", Color = "Color", ModeClient = "Client", ModeCustom = "Custom",
        FirstColor = "First color", SecondColor = "Second color", ColorSpeed = "Color speed",
        ColorBlend = "Color blending", Blur = "Blur", Glow = "Glow",
        Enabled = "enabled", Disabled = "disabled", Selected = "selected", NothingSelected = "Nothing selected",
        ConfigName = "Config name", Save = "Save", Load = "Load", Delete = "Delete",
        Created = "Config saved", Loaded = "Config loaded", Deleted = "Config deleted",
        NoConfigs = "No configs yet", Themes = "Themes", Configs = "Configs", Press = "Press a key...",
    },
}
local function L(key)
    local t = Library.Languages[Library.Language] or Library.Languages.ru
    return t[key] or Library.Languages.ru[key] or key
end
Library.L = L

-- ───────────────────────────── палитра ─────────────────────────────
local P = {
    Window = Color3.fromRGB(13, 13, 15),
    Panel = Color3.fromRGB(19, 19, 22),
    Card = Color3.fromRGB(24, 24, 27),
    CardHover = Color3.fromRGB(33, 33, 37),
    Row = Color3.fromRGB(27, 27, 31),
    Group = Color3.fromRGB(18, 18, 21),
    Stroke = Color3.fromRGB(44, 44, 50),
    Text = Color3.fromRGB(244, 244, 248),
    Sub = Color3.fromRGB(150, 150, 163),
    Dim = Color3.fromRGB(98, 98, 110),
    Off = Color3.fromRGB(48, 48, 54),
    White = Color3.new(1, 1, 1),
    Danger = Color3.fromRGB(215, 40, 40),
    Success = Color3.fromRGB(65, 172, 73),
    Warn = Color3.fromRGB(252, 190, 55),
}
Library.Palette = P

-- ───────────────────────────── утилиты ─────────────────────────────
local function create(class, props, children)
    local inst = Instance.new(class)
    local parent
    if props then
        for k, v in pairs(props) do
            if k == "Parent" then parent = v else inst[k] = v end
        end
    end
    if children then
        for _, c in ipairs(children) do c.Parent = inst end
    end
    if parent then inst.Parent = parent end
    return inst
end

local fontCache = {}
local function getFont(weight)
    if fontCache[weight] == nil then
        local ok, f = pcall(function()
            return Font.fromName("Montserrat", Enum.FontWeight[weight])
        end)
        fontCache[weight] = ok and f or false
    end
    return fontCache[weight]
end

local function setFont(inst, weight)
    local f = getFont(weight or "Medium")
    if f then
        local ok = pcall(function() inst.FontFace = f end)
        if ok then return end
    end
    pcall(function() inst.Font = Enum.Font.Montserrat end)
end

local function newText(class, props, weight)
    local o = Instance.new(class)
    o.BackgroundTransparency = 1
    o.BorderSizePixel = 0
    o.TextColor3 = P.Text
    o.TextSize = 13
    o.TextXAlignment = Enum.TextXAlignment.Left
    o.TextYAlignment = Enum.TextYAlignment.Center
    o.Text = ""
    pcall(function() o.AutoLocalize = false end)
    setFont(o, weight)
    local parent
    for k, v in pairs(props or {}) do
        if k == "Parent" then parent = v else o[k] = v end
    end
    if parent then o.Parent = parent end
    return o
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

local function stroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or P.Stroke, Thickness = thickness or 1, Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent,
    })
end

local function padding(parent, l, t, r, b)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, l or 0), PaddingTop = UDim.new(0, t or l or 0),
        PaddingRight = UDim.new(0, r or l or 0), PaddingBottom = UDim.new(0, b or t or l or 0),
        Parent = parent,
    })
end

local function listLayout(parent, gap, hAlign)
    return create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, gap or 6),
        HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left, Parent = parent,
    })
end

local function tween(inst, time, props, style, dir)
    local tw = TweenService:Create(inst, TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quad,
        dir or Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function isPress(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function isMove(i)
    return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

local function decimals(step)
    local s = string.format("%.6f", step)
    s = s:gsub("0+$", "")
    local d = s:match("%.(%d*)")
    return d and #d or 0
end
local function fmtNumber(v, dec)
    return string.format("%." .. (dec or 0) .. "f", v)
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[Celestial] " .. tostring(err)) end
end

function Library:Connect(signal, fn)
    local c = signal:Connect(fn)
    self._conns = self._conns or {}
    table.insert(self._conns, c)
    return c
end

function Library:MakeDraggable(handle, target, canDrag)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if isPress(input) and (not canDrag or canDrag()) then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)
    self:Connect(UIS.InputChanged, function(input)
        if dragging and isMove(input) then
            local d = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    self:Connect(UIS.InputEnded, function(input)
        if isPress(input) then dragging = false end
    end)
end

-- ───────────────────────────── темы / градиенты ─────────────────────────────
Library.Themes = {
    { Name = "Peach",    C1 = Color3.fromRGB(255, 178, 152), C2 = Color3.fromRGB(236, 128, 112) },
    { Name = "Sunset",   C1 = Color3.fromRGB(255, 150, 110), C2 = Color3.fromRGB(214, 88, 140) },
    { Name = "Rose",     C1 = Color3.fromRGB(255, 160, 190), C2 = Color3.fromRGB(214, 98, 150) },
    { Name = "Violet",   C1 = Color3.fromRGB(190, 101, 255), C2 = Color3.fromRGB(96, 52, 190) },
    { Name = "Ocean",    C1 = Color3.fromRGB(96, 190, 255), C2 = Color3.fromRGB(52, 100, 220) },
    { Name = "Ice",      C1 = Color3.fromRGB(190, 240, 255), C2 = Color3.fromRGB(120, 180, 240) },
    { Name = "Mint",     C1 = Color3.fromRGB(140, 255, 200), C2 = Color3.fromRGB(52, 178, 150) },
    { Name = "Lime",     C1 = Color3.fromRGB(205, 255, 120), C2 = Color3.fromRGB(96, 190, 70) },
    { Name = "Gold",     C1 = Color3.fromRGB(255, 226, 130), C2 = Color3.fromRGB(230, 150, 50) },
    { Name = "Crimson",  C1 = Color3.fromRGB(255, 110, 110), C2 = Color3.fromRGB(160, 30, 60) },
    { Name = "Cherry",   C1 = Color3.fromRGB(255, 90, 150), C2 = Color3.fromRGB(150, 30, 110) },
    { Name = "Mono",     C1 = Color3.fromRGB(235, 235, 240), C2 = Color3.fromRGB(120, 120, 135) },
}

Library.Theme = {
    Mode = "client",                                -- "client" | "custom"
    Index = 1,
    Custom1 = Color3.fromRGB(190, 101, 255),        -- -4299265 из сурсов
    Custom2 = Color3.fromRGB(62, 21, 104),          -- -12708504 из сурсов
    Speed = 3, Blend = false, Blur = true, Glow = true,
}

Library._time = 0
Library._grads = {}        -- градиенты внутри GUI (обновляются только когда меню открыто)
Library._hudGrads = {}     -- градиенты HUD / уведомлений (обновляются всегда)

function Library:GetColors()
    local t = self.Theme
    if t.Mode == "custom" then return t.Custom1, t.Custom2 end
    local th = self.Themes[t.Index] or self.Themes[1]
    return th.C1, th.C2
end

local function wave(x, smooth)
    local f = x % 2
    if f > 1 then f = 2 - f end
    if smooth then f = f * f * (3 - 2 * f) end
    return f
end

function Library:ColorAt(p)
    local c1, c2 = self:GetColors()
    local speed = 0.12 + (self.Theme.Speed - 1) * 0.12
    return c1:Lerp(c2, wave(self._time * speed + p, self.Theme.Blend))
end

function Library:_sequence(spread)
    local pts = {}
    for i = 0, 4 do
        local p = i / 4
        pts[#pts + 1] = ColorSequenceKeypoint.new(p, self:ColorAt(p * spread))
    end
    return ColorSequence.new(pts)
end

function Library:BindGradient(grad, spread, hud)
    local set = hud and self._hudGrads or self._grads
    set[grad] = spread or 0.6
    grad.Color = self:_sequence(spread or 0.6)
end
function Library:UnbindGradient(grad)
    self._grads[grad] = nil
    self._hudGrads[grad] = nil
end

function Library:_updateSet(set)
    local cache = {}
    for grad, spread in pairs(set) do
        if grad.Parent == nil then
            set[grad] = nil
        else
            local seq = cache[spread]
            if not seq then
                seq = self:_sequence(spread)
                cache[spread] = seq
            end
            grad.Color = seq
        end
    end
end

function Library:SetTheme(name)
    for i, t in ipairs(self.Themes) do
        if t.Name == name then
            self.Theme.Index = i
            self.Theme.Mode = "client"
            self:_syncThemeUI()
            return true
        end
    end
    return false
end

function Library:SetCustomColors(c1, c2)
    self.Theme.Custom1, self.Theme.Custom2 = c1, c2
    self.Theme.Mode = "custom"
    self:_syncThemeUI()
end

function Library:_syncThemeUI()
    for _, w in ipairs(self.Windows) do
        if w._onThemeChanged then w:_onThemeChanged() end
    end
end

-- ───────────────────────────── иконки ─────────────────────────────
local Glyphs = {
    combat = "⚔", movement = "➤", render = "◉", player = "☻", util = "✱", configs = "☰", themes = "◐",
    autobuy_items = "▦", autobuy_history = "↺", gear = "⚙", attach = "⚲", search = "⌕", folder = "▤",
    close = "✕", logout = "⏻", plus = "+", save = "▣", load = "▼", trash = "✖", play = "▶",
    info = "i", success = "✓", error = "✕", danger = "!",
}
local IconAssets, IconWaiters = {}, {}

local function ensureFolders()
    if not makefolder then return end
    pcall(function()
        if isfolder and not isfolder(Library.Folder) then makefolder(Library.Folder) end
        if isfolder and not isfolder(Library.Folder .. "/icons") then makefolder(Library.Folder .. "/icons") end
        if isfolder and not isfolder(Library.Folder .. "/configs") then makefolder(Library.Folder .. "/configs") end
    end)
end

local function requestIcon(name, cb)
    if IconAssets[name] then cb(IconAssets[name]) return end
    if not (writefile and isfile and getcustomasset) then return end
    local w = IconWaiters[name]
    if not w then
        w = { busy = false }
        IconWaiters[name] = w
    end
    table.insert(w, cb)
    if w.busy then return end
    w.busy = true
    task.spawn(function()
        local ok = pcall(function()
            ensureFolders()
            local path = Library.Folder .. "/icons/" .. name .. ".png"
            if not isfile(path) then
                local data = game:HttpGet(Library.IconBase .. name .. ".png")
                if type(data) ~= "string" or data:sub(2, 4) ~= "PNG" then error("icon " .. name .. " not found") end
                writefile(path, data)
            end
            IconAssets[name] = getcustomasset(path)
        end)
        if ok and IconAssets[name] then
            for _, f in ipairs(w) do pcall(f, IconAssets[name]) end
        end
    end)
end

local function makeIcon(name, parent, size, color)
    local btn = create("ImageButton", {
        Name = "Icon_" .. name, BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.fromOffset(size, size), ImageColor3 = color or P.White, AutoButtonColor = false,
        ScaleType = Enum.ScaleType.Fit, Parent = parent,
    })
    local glyph = newText("TextLabel", {
        Name = "Glyph", Size = UDim2.fromScale(1, 1), Text = Glyphs[name] or "?", TextSize = math.floor(size * 0.9),
        TextColor3 = color or P.White, TextXAlignment = Enum.TextXAlignment.Center, Parent = btn,
    }, "Bold")
    local function apply(asset)
        if btn.Parent == nil then return end
        btn.Image = asset
        glyph.Visible = false
    end
    local override = Library.Icons[name]
    if override then apply(override) else requestIcon(name, apply) end
    return btn
end

local function tintIcon(btn, color)
    btn.ImageColor3 = color
    local g = btn:FindFirstChild("Glyph")
    if g then g.TextColor3 = color end
end

Library._P = P
Library._util = {
    create = create, newText = newText, corner = corner, stroke = stroke, padding = padding,
    listLayout = listLayout, tween = tween, isPress = isPress, isMove = isMove, decimals = decimals,
    fmtNumber = fmtNumber, safeCall = safeCall, makeIcon = makeIcon, tintIcon = tintIcon,
    svc = svc, guiParent = guiParent, ensureFolders = ensureFolders,
}

-- ───────────────────────────── настройки (Container) ─────────────────────────────
local Setting = {}
Setting.__index = Setting

function Setting:Get() return self.Value end

function Setting:Set(v, silent)
    if self._normalize then v = self._normalize(v) end
    self.Value = v
    if self._render then self._render() end
    if not silent then self:_fire() end
    self.Module:_refreshVisibility()
end

function Setting:_fire()
    safeCall(self.Callback, self.Value)
    for _, fn in ipairs(self._listeners) do safeCall(fn, self.Value) end
end

function Setting:OnChanged(fn)
    table.insert(self._listeners, fn)
    return self
end

function Setting:SetVisible(v)
    self.VisibleFn = v
    self.Module:_refreshVisibility()
end

local Container = {}
Container.__index = Container

local function newSetting(self, kind, o)
    o = o or {}
    local s = setmetatable({
        Type = kind, Name = o.Name or kind, Callback = o.Callback, VisibleFn = o.Visible,
        Module = self._module, Parent = self, _listeners = {},
    }, Setting)
    self._order = (self._order or 0) + 1
    s._baseKey = (self._path and (self._path .. "/") or "") .. s.Name
    local keys = self._module._keys
    keys[s._baseKey] = (keys[s._baseKey] or 0) + 1
    s._key = keys[s._baseKey] > 1 and (s._baseKey .. "#" .. keys[s._baseKey]) or s._baseKey
    table.insert(self._module.Settings, s)
    table.insert(self._children, s)
    return s
end

local function newRow(self, s, height)
    local row = create("Frame", {
        Name = s.Name, Size = UDim2.new(1, 0, 0, height or 36), BackgroundColor3 = P.Row,
        BorderSizePixel = 0, LayoutOrder = self._order, Parent = self._holder,
    })
    corner(row, 9)
    s._frame = row
    return row
end

local function rowLabel(row, text, rightGap)
    return newText("TextLabel", {
        Name = "Label", Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -(rightGap or 60), 1, 0),
        Text = text, TextSize = 12, TextWrapped = true, TextColor3 = P.Text, Parent = row,
    }, "Medium")
end

local function gradientFrame(self, parent, spread)
    local g = create("UIGradient", { Parent = parent })
    self._module:_regGrad(g, spread)
    return g
end

-- Toggle ----------------------------------------------------------------
function Container:AddToggle(o)
    local s = newSetting(self, "Toggle", o)
    s.Value = o.Default == true
    s._normalize = function(v) return v and true or false end
    local row = newRow(self, s, 36)
    rowLabel(row, s.Name, 64)
    local track = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = P.Off, BorderSizePixel = 0, Parent = row,
    })
    corner(track, 9)
    local fill = create("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BackgroundTransparency = 1,
        BorderSizePixel = 0, Parent = track,
    })
    corner(fill, 9)
    gradientFrame(self, fill, 0.5)
    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = track,
    })
    corner(knob, 7)
    s._render = function()
        tween(fill, 0.15, { BackgroundTransparency = s.Value and 0 or 1 })
        tween(knob, 0.15, { Position = UDim2.new(0, s.Value and 18 or 2, 0.5, 0) })
    end
    local hit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = row })
    hit.MouseButton1Click:Connect(function() s:Set(not s.Value) end)
    fill.BackgroundTransparency = s.Value and 0 or 1
    knob.Position = UDim2.new(0, s.Value and 18 or 2, 0.5, 0)
    return s
end

-- Slider ----------------------------------------------------------------
function Container:AddSlider(o)
    local s = newSetting(self, "Slider", o)
    local min, max = o.Min or 0, o.Max or 100
    local step = o.Step or 1
    local dec = decimals(step)
    s.Min, s.Max, s.Step = min, max, step
    s._normalize = function(v)
        v = tonumber(v) or min
        v = math.floor((v - min) / step + 0.5) * step + min
        v = math.clamp(v, min, max)
        return tonumber(fmtNumber(v, dec))
    end
    s.Value = s._normalize(o.Default or min)
    local row = newRow(self, s, 48)
    local lbl = rowLabel(row, s.Name, 90)
    lbl.Size = UDim2.new(1, -90, 0, 26)
    lbl.Position = UDim2.fromOffset(12, 2)
    local box = newText("TextBox", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 5), Size = UDim2.fromOffset(64, 20),
        Text = fmtNumber(s.Value, dec), TextSize = 12, TextColor3 = P.Sub, TextXAlignment = Enum.TextXAlignment.Right,
        ClearTextOnFocus = false, Parent = row,
    }, "SemiBold")
    local track = create("Frame", {
        Position = UDim2.new(0, 12, 0, 34), Size = UDim2.new(1, -24, 0, 5), BackgroundColor3 = P.Off,
        BorderSizePixel = 0, Parent = row,
    })
    corner(track, 3)
    local fill = create("Frame", {
        Size = UDim2.fromScale(0, 1), BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = track,
    })
    corner(fill, 3)
    gradientFrame(self, fill, 0.5)
    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(11, 11),
        BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = fill,
    })
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    corner(knob, 6)
    local function alpha() return (s.Value - min) / math.max(max - min, 1e-9) end
    s._render = function()
        box.Text = fmtNumber(s.Value, dec)
        tween(fill, 0.08, { Size = UDim2.fromScale(alpha(), 1) })
    end
    fill.Size = UDim2.fromScale(alpha(), 1)
    local hit = create("TextButton", {
        Position = UDim2.new(0, 6, 0, 24), Size = UDim2.new(1, -12, 0, 24), BackgroundTransparency = 1, Text = "", Parent = row,
    })
    local dragging = false
    local function setFromX(x)
        local w = math.max(track.AbsoluteSize.X, 1)
        local a = math.clamp((x - track.AbsolutePosition.X) / w, 0, 1)
        local nv = s._normalize(min + (max - min) * a)
        if nv ~= s.Value then s:Set(nv) end
    end
    hit.InputBegan:Connect(function(i)
        if isPress(i) then dragging = true setFromX(i.Position.X) end
    end)
    Library:Connect(UIS.InputChanged, function(i)
        if dragging and isMove(i) then setFromX(i.Position.X) end
    end)
    Library:Connect(UIS.InputEnded, function(i)
        if isPress(i) then dragging = false end
    end)
    box.FocusLost:Connect(function()
        local n = tonumber((box.Text:gsub(",", ".")))
        if n then s:Set(n) else box.Text = fmtNumber(s.Value, dec) end
    end)
    return s
end

-- Mode (одиночный выбор) ------------------------------------------------
local function expandable(self, s, height)
    local holder = create("Frame", {
        Name = s.Name, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = P.Row, BorderSizePixel = 0, LayoutOrder = self._order, ClipsDescendants = true,
        Parent = self._holder,
    })
    corner(holder, 9)
    listLayout(holder, 0)
    s._frame = holder
    local head = create("TextButton", {
        Name = "Head", Size = UDim2.new(1, 0, 0, height or 36), BackgroundTransparency = 1, Text = "",
        LayoutOrder = 0, Parent = holder,
    })
    local body = create("Frame", {
        Name = "Body", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        Visible = false, LayoutOrder = 1, Parent = holder,
    })
    return holder, head, body
end

local function chevron(head)
    return newText("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(14, 14),
        Text = "›", TextSize = 18, TextColor3 = P.Sub, TextXAlignment = Enum.TextXAlignment.Center,
        Rotation = 90, Parent = head,
    }, "Bold")
end

function Container:AddMode(o)
    local s = newSetting(self, "Mode", o)
    s.Options = o.Options or {}
    s.Value = o.Default or s.Options[1]
    s._normalize = function(v)
        if table.find(s.Options, v) then return v end
        return s.Value
    end
    local _, head, body = expandable(self, s, 36)
    rowLabel(head, s.Name, 150)
    local cur = newText("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -30, 0.5, 0), Size = UDim2.new(0, 120, 1, 0),
        Text = tostring(s.Value), TextSize = 12, TextColor3 = P.Sub, TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = head,
    }, "SemiBold")
    local arrow = chevron(head)
    local lay = listLayout(body, 2)
    padding(body, 6, 0, 6, 6)
    local buttons = {}
    local function renderButtons()
        for _, b in pairs(buttons) do b.btn:Destroy() end
        buttons = {}
        for i, opt in ipairs(s.Options) do
            local btn = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = P.White, BackgroundTransparency = 1,
                Text = "", LayoutOrder = i, AutoButtonColor = false, Parent = body,
            })
            corner(btn, 7)
            local g = create("UIGradient", { Parent = btn })
            self._module:_regGrad(g, 0.5)
            local t = newText("TextLabel", {
                Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0), Text = tostring(opt),
                TextSize = 12, Parent = btn,
            }, "Medium")
            btn.MouseButton1Click:Connect(function()
                s:Set(opt)
                s._open(false)
            end)
            buttons[opt] = { btn = btn, label = t }
        end
        for opt, b in pairs(buttons) do
            b.btn.BackgroundTransparency = (opt == s.Value) and 0.72 or 1
            b.label.TextColor3 = (opt == s.Value) and P.White or P.Sub
        end
    end
    s._open = function(state)
        body.Visible = state
        tween(arrow, 0.15, { Rotation = state and -90 or 90 })
    end
    s._render = function()
        cur.Text = tostring(s.Value)
        for opt, b in pairs(buttons) do
            b.btn.BackgroundTransparency = (opt == s.Value) and 0.72 or 1
            b.label.TextColor3 = (opt == s.Value) and P.White or P.Sub
        end
    end
    function s:SetOptions(list, keep)
        self.Options = list
        if not keep or not table.find(list, self.Value) then self.Value = list[1] end
        renderButtons()
        cur.Text = tostring(self.Value)
    end
    head.MouseButton1Click:Connect(function() s._open(not body.Visible) end)
    renderButtons()
    return s
end

-- MultiSelect -----------------------------------------------------------
function Container:AddMultiSelect(o)
    local s = newSetting(self, "MultiSelect", o)
    s.Options = {}
    s.Value = {}
    for _, opt in ipairs(o.Options or {}) do
        local name, def
        if type(opt) == "table" then name, def = opt.Name, opt.Default else name, def = opt, false end
        table.insert(s.Options, name)
        s.Value[name] = def == true
    end
    if o.Default then
        for _, name in ipairs(o.Default) do s.Value[name] = true end
    end
    s._normalize = function(v)
        local nv = {}
        for _, name in ipairs(s.Options) do nv[name] = (type(v) == "table" and v[name] == true) end
        return nv
    end
    function s:IsSelected(name) return self.Value[name] == true end
    function s:GetSelected()
        local r = {}
        for _, name in ipairs(self.Options) do if self.Value[name] then r[#r + 1] = name end end
        return r
    end
    local _, head, body = expandable(self, s, 36)
    rowLabel(head, s.Name, 150)
    local cur = newText("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -30, 0.5, 0), Size = UDim2.new(0, 120, 1, 0),
        TextSize = 12, TextColor3 = P.Sub, TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = head,
    }, "SemiBold")
    local arrow = chevron(head)
    listLayout(body, 2)
    padding(body, 6, 0, 6, 6)
    local items = {}
    local function summary()
        local sel = s:GetSelected()
        if #sel == 0 then return L("NothingSelected") end
        if #sel == 1 then return sel[1] end
        return #sel .. " " .. L("Selected")
    end
    local function renderItems()
        for name, it in pairs(items) do
            local on = s.Value[name]
            it.fill.BackgroundTransparency = on and 0 or 1
            it.label.TextColor3 = on and P.White or P.Sub
        end
        cur.Text = summary()
    end
    for i, name in ipairs(s.Options) do
        local btn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = "", LayoutOrder = i,
            AutoButtonColor = false, Parent = body,
        })
        local box = create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(14, 14),
            BackgroundColor3 = P.Off, BorderSizePixel = 0, Parent = btn,
        })
        corner(box, 4)
        local fill = create("Frame", {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BackgroundTransparency = 1,
            BorderSizePixel = 0, Parent = box,
        })
        corner(fill, 4)
        local g = create("UIGradient", { Parent = fill })
        self._module:_regGrad(g, 0.5)
        local t = newText("TextLabel", {
            Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -36, 1, 0), Text = tostring(name),
            TextSize = 12, Parent = btn,
        }, "Medium")
        items[name] = { fill = fill, label = t }
        btn.MouseButton1Click:Connect(function()
            s.Value[name] = not s.Value[name]
            renderItems()
            s:_fire()
        end)
    end
    s._render = renderItems
    head.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        tween(arrow, 0.15, { Rotation = body.Visible and -90 or 90 })
    end)
    renderItems()
    return s
end

-- Color -----------------------------------------------------------------
function Container:AddColor(o)
    local s = newSetting(self, "Color", o)
    s.Value = o.Default or Color3.new(1, 1, 1)
    local h, sat, val = s.Value:ToHSV()
    s._normalize = function(v)
        if typeof(v) == "Color3" then
            h, sat, val = v:ToHSV()
            return v
        end
        return s.Value
    end
    local _, head, body = expandable(self, s, 36)
    rowLabel(head, s.Name, 60)
    local swatch = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(30, 16),
        BackgroundColor3 = s.Value, BorderSizePixel = 0, Parent = head,
    })
    corner(swatch, 5)
    stroke(swatch, P.Stroke, 1)
    body.Size = UDim2.new(1, 0, 0, 0)
    local sv = create("Frame", {
        Position = UDim2.fromOffset(10, 4), Size = UDim2.new(1, -20, 0, 84), BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        BorderSizePixel = 0, Parent = body,
    })
    corner(sv, 6)
    local white = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = sv })
    corner(white, 6)
    create("UIGradient", {
        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
        Parent = white,
    })
    local black = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = sv })
    corner(black, 6)
    create("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
        Parent = black,
    })
    local svKnob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10), BackgroundTransparency = 1,
        BorderSizePixel = 0, Parent = sv,
    })
    corner(svKnob, 5)
    stroke(svKnob, P.White, 2)
    local hue = create("Frame", {
        Position = UDim2.fromOffset(10, 96), Size = UDim2.new(1, -20, 0, 12), BackgroundColor3 = P.White,
        BorderSizePixel = 0, Parent = body,
    })
    corner(hue, 6)
    local kps = {}
    for i = 0, 6 do kps[#kps + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)) end
    create("UIGradient", { Color = ColorSequence.new(kps), Parent = hue })
    local hueKnob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(6, 16),
        BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = hue,
    })
    corner(hueKnob, 3)
    create("Frame", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.fromOffset(0, 112), BackgroundTransparency = 1, Parent = body })
    body.Size = UDim2.new(1, 0, 0, 128)
    body.AutomaticSize = Enum.AutomaticSize.None

    local function visuals()
        swatch.BackgroundColor3 = s.Value
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svKnob.Position = UDim2.new(sat, 0, 1 - val, 0)
        hueKnob.Position = UDim2.new(h, 0, 0.5, 0)
    end
    s._render = visuals
    local function commit()
        s.Value = Color3.fromHSV(h, sat, val)
        visuals()
        s:_fire()
        s.Module:_refreshVisibility()
    end
    local dragSV, dragH = false, false
    local function updSV(pos)
        sat = math.clamp((pos.X - sv.AbsolutePosition.X) / math.max(sv.AbsoluteSize.X, 1), 0, 1)
        val = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / math.max(sv.AbsoluteSize.Y, 1), 0, 1)
        commit()
    end
    local function updH(pos)
        h = math.clamp((pos.X - hue.AbsolutePosition.X) / math.max(hue.AbsoluteSize.X, 1), 0, 0.999)
        commit()
    end
    sv.InputBegan:Connect(function(i) if isPress(i) then dragSV = true updSV(i.Position) end end)
    hue.InputBegan:Connect(function(i) if isPress(i) then dragH = true updH(i.Position) end end)
    Library:Connect(UIS.InputChanged, function(i)
        if isMove(i) then
            if dragSV then updSV(i.Position) elseif dragH then updH(i.Position) end
        end
    end)
    Library:Connect(UIS.InputEnded, function(i) if isPress(i) then dragSV, dragH = false, false end end)
    head.MouseButton1Click:Connect(function() body.Visible = not body.Visible end)
    visuals()
    return s
end

-- Keybind ---------------------------------------------------------------
local function keyName(k)
    if not k then return "None" end
    return k.Name
end
Library._keyName = keyName

function Container:AddKeybind(o)
    local s = newSetting(self, "Keybind", o)
    s.Value = o.Default            -- Enum.KeyCode | Enum.UserInputType | nil
    s._normalize = function(v) return v end
    local row = newRow(self, s, 36)
    rowLabel(row, s.Name, 110)
    local btn = newText("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(88, 22),
        BackgroundTransparency = 0, BackgroundColor3 = P.Panel, Text = keyName(s.Value), TextSize = 11,
        TextColor3 = P.Sub, TextXAlignment = Enum.TextXAlignment.Center, AutoButtonColor = false, Parent = row,
    }, "SemiBold")
    corner(btn, 6)
    s._render = function()
        btn.Text = keyName(s.Value)
        btn.TextColor3 = s.Value and P.Text or P.Sub
    end
    s._listenDone = function(key, cancelled)
        Library._listening = nil
        if not cancelled then s:Set(key) else btn.Text = keyName(s.Value) end
    end
    btn.MouseButton1Click:Connect(function()
        if Library._listening then Library._listening._listenDone(nil, true) end
        btn.Text = L("Press")
        Library._listening = s
    end)
    s._render()
    return s
end

-- TextBox ---------------------------------------------------------------
function Container:AddTextBox(o)
    local s = newSetting(self, "TextBox", o)
    s.Value = o.Default or ""
    s._normalize = function(v) return tostring(v or "") end
    local row = newRow(self, s, 36)
    rowLabel(row, s.Name, 170)
    local box = newText("TextBox", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(150, 24),
        BackgroundTransparency = 0, BackgroundColor3 = P.Panel, Text = s.Value, PlaceholderText = o.Placeholder or "...",
        PlaceholderColor3 = P.Dim, TextSize = 12, TextColor3 = P.Text, ClearTextOnFocus = false, Parent = row,
    }, "Medium")
    corner(box, 6)
    padding(box, 8, 0, 8, 0)
    s._render = function() box.Text = s.Value end
    box.FocusLost:Connect(function() s:Set(box.Text) end)
    return s
end

-- Button / Label --------------------------------------------------------
function Container:AddButton(o)
    local s = newSetting(self, "Button", o)
    local row = newRow(self, s, 34)
    local btn = newText("TextButton", {
        Size = UDim2.fromScale(1, 1), Text = s.Name, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
        AutoButtonColor = false, Parent = row,
    }, "SemiBold")
    btn.MouseEnter:Connect(function() tween(row, 0.12, { BackgroundColor3 = P.CardHover }) end)
    btn.MouseLeave:Connect(function() tween(row, 0.12, { BackgroundColor3 = P.Row }) end)
    btn.MouseButton1Click:Connect(function() s:_fire() end)
    s._render = nil
    return s
end

function Container:AddLabel(text)
    local s = newSetting(self, "Label", { Name = text })
    local row = newRow(self, s, 30)
    local l = rowLabel(row, text, 24)
    l.TextColor3 = P.Sub
    function s:SetText(t) l.Text = t end
    return s
end

-- Group -----------------------------------------------------------------
local Group = setmetatable({}, { __index = Container })
Group.__index = Group

function Container:AddGroup(name, builder)
    self._order = (self._order or 0) + 1
    local frame = create("Frame", {
        Name = "Group_" .. name, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = P.Group, BorderSizePixel = 0, LayoutOrder = self._order, Parent = self._holder,
    })
    corner(frame, 11)
    stroke(frame, P.Stroke, 1, 0.4)
    padding(frame, 8, 8, 8, 8)
    listLayout(frame, 5)
    newText("TextLabel", {
        Name = "Title", Size = UDim2.new(1, 0, 0, 16), Text = name, TextSize = 11, TextColor3 = P.Sub,
        LayoutOrder = 0, Parent = frame,
    }, "Bold")
    local g = setmetatable({
        _module = self._module, _holder = frame, _order = 0, _children = {}, _frame = frame, Name = name,
        _path = (self._path and (self._path .. "/") or "") .. name,
    }, Group)
    table.insert(self._children, g)
    if builder then safeCall(builder, g) end
    return g
end

function Group:_visibleAny()
    for _, c in ipairs(self._children) do
        if c.Type then
            local vis = true
            if c.VisibleFn then
                if type(c.VisibleFn) == "function" then
                    local ok, r = pcall(c.VisibleFn)
                    vis = ok and r ~= false
                else
                    vis = c.VisibleFn ~= false
                end
            end
            if vis then return true end
        elseif c._visibleAny and c:_visibleAny() then
            return true
        end
    end
    return false
end

Library._Container = Container
Library._Group = Group
Library._Setting = Setting

-- ───────────────────────────── Module ─────────────────────────────
local Module = setmetatable({}, { __index = Container })
Module.__index = Module

local function newModuleCore(window, name, desc)
    local m = setmetatable({
        Name = name, Description = desc or "", Window = window, Enabled = false, Settings = {}, _children = {},
        _keys = {}, _grads = {}, _order = 0, _toggleListeners = {},
    }, Module)
    m._module = m
    local panel = create("ScrollingFrame", {
        Name = "Panel_" .. name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = P.Dim, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, VerticalScrollBarInset = Enum.ScrollBarInset.None,
    })
    listLayout(panel, 6)
    padding(panel, 10, 8, 10, 12)
    m._holder = panel
    m._panel = panel
    return m
end

function Module:_regGrad(g, spread)
    spread = spread or 0.5
    table.insert(self._grads, { g, spread })
    g.Color = Library:_sequence(spread)
    if self._active then Library:BindGradient(g, spread) end
end

function Module:_activate(on)
    self._active = on
    for _, e in ipairs(self._grads) do
        if on then Library:BindGradient(e[1], e[2]) else Library:UnbindGradient(e[1]) end
    end
    if on then self:_refreshVisibility() end
end

local function evalVisible(fn)
    if fn == nil then return true end
    if type(fn) == "function" then
        local ok, r = pcall(fn)
        return ok and r ~= false
    end
    return fn ~= false
end

function Module:_refreshVisibility()
    local function walk(container)
        for _, c in ipairs(container._children) do
            if c.Type then
                if c._frame then c._frame.Visible = evalVisible(c.VisibleFn) end
            else
                walk(c)
                if c._frame then c._frame.Visible = c:_visibleAny() end
            end
        end
    end
    walk(self)
end

function Module:OnToggle(fn)
    table.insert(self._toggleListeners, fn)
    return self
end

function Module:Toggle() self:SetEnabled(not self.Enabled) end

function Module:SetEnabled(state, silent)
    state = state and true or false
    if self.Enabled == state then return end
    self.Enabled = state
    if self._renderCard then self._renderCard() end
    if silent then return end
    safeCall(self.Callback, state)
    for _, fn in ipairs(self._toggleListeners) do safeCall(fn, state) end
    if Library.NotifyOnToggle and self.Category then
        Library:Notify({
            Title = self.Name, Content = state and L("Enabled") or L("Disabled"),
            Type = state and "success" or "error", Duration = 2,
        })
    end
    Library:_refreshArrayList()
end

function Module:SetKeybind(key)
    self.Bind = key
    if self._renderBind then self._renderBind() end
end

function Module:SetDescription(text)
    self.Description = text
    if self._descLabel then self._descLabel.Text = text end
end

function Module:Destroy()
    if self._card then self._card:Destroy() end
    if self._panel then self._panel:Destroy() end
    for i, m in ipairs(Library.Modules) do if m == self then table.remove(Library.Modules, i) break end end
    if self.Category then
        for i, m in ipairs(self.Category.Modules) do if m == self then table.remove(self.Category.Modules, i) break end end
    end
    self:_activate(false)
    Library:_refreshArrayList()
end

-- ───────────────────────────── Category ─────────────────────────────
local Category = {}
Category.__index = Category

local moduleCounter = 0

local function fitGrid(page, grid, w0)
    local function apply()
        local w = page.AbsoluteSize.X > 40 and (page.AbsoluteSize.X - 12 - 10) / 2 or w0
        grid.CellSize = UDim2.fromOffset(math.floor(w), 54)
    end
    apply()
    page:GetPropertyChangedSignal("AbsoluteSize"):Connect(apply)
end

function Category:AddModule(o)
    o = o or {}
    local W = self.Window
    moduleCounter = moduleCounter + 1
    local m = newModuleCore(W, o.Name or "Module", o.Description or "")
    m.Category = self
    m.Callback = o.Callback
    m.Bind = o.Keybind
    m._index = moduleCounter
    m._key = self.Name .. "/" .. m.Name
    for _, other in ipairs(Library.Modules) do
        if other._key == m._key then m._key = m._key .. "#" .. moduleCounter break end
    end

    local card = create("TextButton", {
        Name = "Card_" .. m.Name, BackgroundColor3 = P.Card, BorderSizePixel = 0, Text = "", AutoButtonColor = false,
        LayoutOrder = moduleCounter, Parent = self.Page,
    })
    corner(card, 11)
    local cardStroke = stroke(card, P.Stroke, 1, 0.35)
    local cardGrad = create("UIGradient", { Rotation = 20, Enabled = false, Parent = card })
    m._card = card
    m._home = self.Page

    local top = create("Frame", {
        Position = UDim2.fromOffset(12, 7), Size = UDim2.new(1, -24, 0, 18), BackgroundTransparency = 1, Parent = card,
    })
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = top,
    })
    local title = newText("TextLabel", {
        Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, Text = m.Name, TextSize = 14,
        LayoutOrder = 1, Parent = top,
    }, "SemiBold")
    local gear = makeIcon("gear", top, 13, P.Sub)
    gear.LayoutOrder = 2
    local clip = makeIcon("attach", top, 13, P.Sub)
    clip.LayoutOrder = 3
    local bindLabel = newText("TextLabel", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 8), Size = UDim2.fromOffset(60, 14),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = P.Sub, Text = "", Parent = card,
    }, "SemiBold")
    local desc = newText("TextLabel", {
        Position = UDim2.fromOffset(12, 27), Size = UDim2.new(1, -24, 1, -30), Text = m.Description, TextSize = 10,
        TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, TextColor3 = P.Dim, Parent = card,
    }, "Medium")
    m._descLabel = desc

    m._renderBind = function()
        bindLabel.Text = m.Bind and ("[" .. keyName(m.Bind) .. "]") or ""
    end
    m._renderCard = function()
        local on = m.Enabled
        cardGrad.Enabled = on
        if on then Library:BindGradient(cardGrad, 0.6) else Library:UnbindGradient(cardGrad) end
        tween(card, 0.15, { BackgroundColor3 = on and P.White or P.Card })
        tween(cardStroke, 0.15, { Transparency = on and 1 or 0.35 })
        tween(title, 0.15, { TextColor3 = on and P.White or P.Text })
        tween(desc, 0.15, { TextColor3 = on and Color3.fromRGB(255, 244, 240) or P.Dim })
        tween(bindLabel, 0.15, { TextColor3 = on and P.White or P.Sub })
        tintIcon(gear, on and P.White or P.Sub)
        tintIcon(clip, on and P.White or P.Sub)
    end

    card.MouseEnter:Connect(function()
        if not m.Enabled then tween(card, 0.12, { BackgroundColor3 = P.CardHover }) end
    end)
    card.MouseLeave:Connect(function()
        if not m.Enabled then tween(card, 0.12, { BackgroundColor3 = P.Card }) end
    end)
    card.MouseButton1Click:Connect(function() m:Toggle() end)
    card.MouseButton2Click:Connect(function() W:OpenSettings(m) end)
    gear.MouseButton1Click:Connect(function() W:OpenSettings(m) end)

    local listener = {
        _listenDone = function(key, cancelled)
            Library._listening = nil
            if not cancelled then m:SetKeybind(key) else m._renderBind() end
        end,
    }
    clip.MouseButton1Click:Connect(function()
        if Library._listening then Library._listening._listenDone(nil, true) end
        Library._listening = listener
        bindLabel.Text = "..."
    end)

    m._renderBind()
    if o.Default then m:SetEnabled(true, true) end
    table.insert(self.Modules, m)
    table.insert(Library.Modules, m)
    return m
end

-- ───────────────────────────── Window ─────────────────────────────
local Window = {}
Window.__index = Window

local function bindMatches(bind, input)
    if not bind then return false end
    if bind.EnumType == Enum.KeyCode then return input.KeyCode == bind end
    return input.UserInputType == bind
end

function Library:_blur(on)
    local want = on and self.Theme.Blur
    local fx = Lighting:FindFirstChild("CelestialBlur")
    if want then
        if not fx then fx = create("BlurEffect", { Name = "CelestialBlur", Size = 0, Parent = Lighting }) end
        tween(fx, 0.25, { Size = 14 })
    elseif fx then
        tween(fx, 0.2, { Size = 0 })
        task.delay(0.25, function()
            if fx.Parent and not (self.Visible and self.Theme.Blur) then fx:Destroy() end
        end)
    end
end

function Library:CreateWindow(o)
    o = o or {}
    if o.Language then Library.Language = o.Language end
    ensureFolders()
    local W = setmetatable({ Categories = {}, _groupIndex = {}, _groupCount = 0, _persist = {}, Open = false, Library = Library }, Window)
    W.Title = o.Title or "Celestial"
    W.OnLogout = o.OnLogout
    local size = o.Size or Vector2.new(700, 480)

    local gui = create("ScreenGui", {
        Name = HttpService:GenerateGUID(false), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true, DisplayOrder = 999,
    })
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    gui.Parent = guiParent()
    W.Gui = gui
    Library.Gui = gui

    local main = create("CanvasGroup", {
        Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(size.X, size.Y), BackgroundColor3 = P.Window, BackgroundTransparency = 0.03,
        BorderSizePixel = 0, GroupTransparency = 1, Visible = false, Parent = gui,
    })
    corner(main, 16)
    local glow = stroke(main, P.White, 1.5, 0.15)
    local glowGrad = create("UIGradient", { Rotation = 35, Parent = glow })
    table.insert(W._persist, { glowGrad, 0.9 })
    W.Glow = glow
    local baseScale = o.Scale or 1
    pcall(function()
        local vp = workspace.CurrentCamera.ViewportSize
        baseScale = math.min(baseScale, vp.X / (size.X + 40), vp.Y / (size.Y + 40))
    end)
    local uiScale = create("UIScale", { Scale = baseScale, Parent = main })
    W.Main = main

    local modal = create("TextButton", { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1, Text = "", Modal = false, Parent = gui })

    -- ── сайдбар ──
    local side = create("Frame", { Name = "Sidebar", Size = UDim2.new(0, 176, 1, 0), BackgroundTransparency = 1, Active = true, Parent = main })
    Library:MakeDraggable(side, main)
    local avatar = create("ImageLabel", {
        Position = UDim2.fromOffset(14, 14), Size = UDim2.fromOffset(38, 38), BackgroundColor3 = P.Panel,
        BorderSizePixel = 0, Parent = side,
    })
    corner(avatar, 10)
    pcall(function()
        avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    end)
    newText("TextLabel", {
        Position = UDim2.fromOffset(60, 14), Size = UDim2.new(1, -66, 0, 38), Text = W.Title, TextSize = 19, Parent = side,
    }, "Bold")
    local nav = create("ScrollingFrame", {
        Name = "Nav", Position = UDim2.fromOffset(0, 62), Size = UDim2.new(1, 0, 1, -118), BackgroundTransparency = 1,
        BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = side,
    })
    listLayout(nav, 3)
    padding(nav, 12, 0, 12, 4)
    W.Nav = nav

    local logout = create("TextButton", {
        Position = UDim2.new(0, 12, 1, -48), Size = UDim2.new(1, -24, 0, 34), BackgroundColor3 = P.White,
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = side,
    })
    corner(logout, 10)
    local logoIcon = makeIcon("logout", logout, 18, P.Sub)
    logoIcon.Position = UDim2.new(0, 10, 0.5, -9)
    local logoText = newText("TextLabel", {
        Position = UDim2.fromOffset(38, 0), Size = UDim2.new(1, -44, 1, 0), Text = L("Logout"), TextSize = 13,
        TextColor3 = P.Sub, Parent = logout,
    }, "SemiBold")
    logout.MouseEnter:Connect(function()
        tween(logout, 0.12, { BackgroundTransparency = 0.88, BackgroundColor3 = P.Danger })
        tween(logoText, 0.12, { TextColor3 = P.Text })
    end)
    logout.MouseLeave:Connect(function()
        tween(logout, 0.12, { BackgroundTransparency = 1 })
        tween(logoText, 0.12, { TextColor3 = P.Sub })
    end)
    logout.MouseButton1Click:Connect(function()
        if W.OnLogout then safeCall(W.OnLogout) else Library:Unload() end
    end)

    -- ── контент ──
    local content = create("Frame", { Name = "Content", Position = UDim2.fromOffset(176, 0), Size = UDim2.new(1, -176, 1, 0), BackgroundTransparency = 1, Parent = main })
    padding(content, 6, 12, 14, 12)
    local bar = create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = content })
    local searchBg = create("Frame", { Size = UDim2.new(1, -84, 1, 0), BackgroundColor3 = P.Panel, BorderSizePixel = 0, Parent = bar })
    corner(searchBg, 11)
    local sIcon = makeIcon("search", searchBg, 15, P.Sub)
    sIcon.Position = UDim2.new(0, 11, 0.5, -7)
    local searchBox = newText("TextBox", {
        Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -44, 1, 0), PlaceholderText = L("Search"),
        PlaceholderColor3 = P.Sub, TextSize = 13, ClearTextOnFocus = false, Parent = searchBg,
    }, "Medium")
    local folderBtn = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -40, 0, 0), Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = P.Panel, Text = "", AutoButtonColor = false, Parent = bar,
    })
    corner(folderBtn, 11)
    local fIcon = makeIcon("folder", folderBtn, 17, P.Sub)
    fIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    local gearBtn = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = P.Panel, Text = "", AutoButtonColor = false, Parent = bar,
    })
    corner(gearBtn, 11)
    local gIcon = makeIcon("gear", gearBtn, 17, P.Sub)
    gIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    for _, b in ipairs({ folderBtn, gearBtn }) do
        b.MouseEnter:Connect(function() tween(b, 0.12, { BackgroundColor3 = P.CardHover }) end)
        b.MouseLeave:Connect(function() tween(b, 0.12, { BackgroundColor3 = P.Panel }) end)
    end

    local pages = create("Frame", {
        Name = "Pages", Position = UDim2.fromOffset(0, 48), Size = UDim2.new(1, 0, 1, -48), BackgroundTransparency = 1,
        ClipsDescendants = true, Parent = content,
    })
    W.Pages = pages
    W._cardW = math.floor((size.X - 208 - 10) / 2)

    -- страница поиска
    local searchPage = create("ScrollingFrame", {
        Name = "SearchPage", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = P.Dim, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, VerticalScrollBarInset = Enum.ScrollBarInset.None,
        Visible = false, Parent = pages,
    })
    local sGrid = create("UIGridLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, CellPadding = UDim2.fromOffset(10, 10), CellSize = UDim2.fromOffset(W._cardW, 54),
        Parent = searchPage,
    })
    padding(searchPage, 0, 2, 12, 10)
    fitGrid(searchPage, sGrid, W._cardW)
    W.SearchPage = searchPage

    function W:_applySearch(q)
        q = (q or ""):lower()
        if q == "" then
            searchPage.Visible = false
            for _, m in ipairs(Library.Modules) do
                if m._card and m._card.Parent == searchPage then m._card.Parent = m._home end
            end
            if self.Current then self.Current.Page.Visible = true end
            return
        end
        if self.Current then self.Current.Page.Visible = false end
        searchPage.Visible = true
        for _, m in ipairs(Library.Modules) do
            if m._card and m.Category and m.Window == self then
                local hit = m.Name:lower():find(q, 1, true) or m.Description:lower():find(q, 1, true)
                if hit then m._card.Parent = searchPage else m._card.Parent = m._home end
            end
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(function() W:_applySearch(searchBox.Text) end)
    W.SearchBox = searchBox

    -- ── popup настроек ──
    local popup = create("Frame", { Name = "Popup", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 50, Parent = main })
    local dim = create("TextButton", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, Parent = popup,
    })
    local box = create("CanvasGroup", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, 340, 0.84, 0),
        BackgroundColor3 = P.Window, BorderSizePixel = 0, GroupTransparency = 1, Parent = popup,
    })
    corner(box, 14)
    local boxStroke = stroke(box, P.Stroke, 1)
    local boxScale = create("UIScale", { Scale = 0.94, Parent = box })
    local pTitle = newText("TextLabel", {
        Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -60, 0, 42), TextSize = 15, Parent = box,
    }, "Bold")
    local pClose = makeIcon("close", box, 13, P.Sub)
    pClose.AnchorPoint = Vector2.new(1, 0.5)
    pClose.Position = UDim2.new(1, -16, 0, 21)
    local pBody = create("Frame", { Position = UDim2.fromOffset(0, 42), Size = UDim2.new(1, 0, 1, -42), BackgroundTransparency = 1, ClipsDescendants = true, Parent = box })
    W._popup = { frame = popup, dim = dim, box = box, scale = boxScale, title = pTitle, body = pBody }

    function W:OpenSettings(m)
        if self._popupModule then self:CloseSettings(true) end
        self._popupModule = m
        pTitle.Text = m.Name
        m._panel.Parent = pBody
        m:_activate(true)
        popup.Visible = true
        tween(dim, 0.18, { BackgroundTransparency = 0.5 })
        tween(box, 0.18, { GroupTransparency = 0 })
        tween(boxScale, 0.18, { Scale = 1 })
    end
    function W:CloseSettings(instant)
        local m = self._popupModule
        if not m then return end
        self._popupModule = nil
        m._panel.Parent = nil
        m:_activate(false)
        if instant then
            popup.Visible = false
            dim.BackgroundTransparency = 1
            box.GroupTransparency = 1
            boxScale.Scale = 0.94
            return
        end
        tween(dim, 0.15, { BackgroundTransparency = 1 })
        tween(box, 0.15, { GroupTransparency = 1 })
        tween(boxScale, 0.15, { Scale = 0.94 })
        task.delay(0.17, function()
            if not self._popupModule then popup.Visible = false end
        end)
    end
    dim.MouseButton1Click:Connect(function() W:CloseSettings() end)
    pClose.MouseButton1Click:Connect(function() W:CloseSettings() end)

    -- ── категории ──
    function W:AddCategory(c)
        c = c or {}
        local cat = setmetatable({
            Name = c.Name or "Category", Group = c.Group or "Основные", Icon = c.Icon or (c.Name or "category"):lower(),
            Modules = {}, Window = self, Kind = c.Kind or "modules",
        }, Category)
        local gi = self._groupIndex[cat.Group]
        if not gi then
            self._groupCount = self._groupCount + 1
            gi = self._groupCount
            self._groupIndex[cat.Group] = gi
            newText("TextLabel", {
                Name = "Header_" .. cat.Group, Size = UDim2.new(1, 0, 0, 24), Text = cat.Group, TextSize = 11,
                TextColor3 = P.Dim, LayoutOrder = gi * 1000, Parent = nav,
            }, "SemiBold")
        end
        cat._order = gi * 1000 + #self.Categories + 1
        local btn = create("TextButton", {
            Name = "Nav_" .. cat.Name, Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false, LayoutOrder = cat._order, Parent = nav,
        })
        local fill = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = btn })
        corner(fill, 10)
        local fg = create("UIGradient", { Rotation = 0, Parent = fill })
        table.insert(self._persist, { fg, 0.6 })
        fg.Color = Library:_sequence(0.6)
        local icon = makeIcon(cat.Icon, btn, 18, P.Sub)
        icon.Position = UDim2.new(0, 11, 0.5, -9)
        local lbl = newText("TextLabel", {
            Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -46, 1, 0), Text = cat.Name, TextSize = 13,
            TextColor3 = P.Sub, Parent = btn,
        }, "SemiBold")
        cat.Button, cat._fill, cat._icon, cat._label = btn, fill, icon, lbl
        btn.MouseEnter:Connect(function()
            if self.Current ~= cat then tween(fill, 0.12, { BackgroundTransparency = 0.9 }) end
        end)
        btn.MouseLeave:Connect(function()
            if self.Current ~= cat then tween(fill, 0.12, { BackgroundTransparency = 1 }) end
        end)
        btn.MouseButton1Click:Connect(function() self:Select(cat) end)

        if c.Custom then
            cat.Page = create("Frame", { Name = "Page_" .. cat.Name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = pages })
            safeCall(c.Custom, cat, cat.Page)
        else
            local page = create("ScrollingFrame", {
                Name = "Page_" .. cat.Name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 3, ScrollBarImageColor3 = P.Dim, CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y, VerticalScrollBarInset = Enum.ScrollBarInset.None,
                Visible = false, Parent = pages,
            })
            local grid = create("UIGridLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder, CellPadding = UDim2.fromOffset(10, 10),
                CellSize = UDim2.fromOffset(self._cardW, 54), Parent = page,
            })
            padding(page, 0, 2, 12, 10)
            fitGrid(page, grid, self._cardW)
            cat.Page = page
        end
        table.insert(self.Categories, cat)
        table.insert(Library.Categories, cat)
        if not self.Current and not c.NoAutoSelect then self:Select(cat) end
        return cat
    end

    function W:Select(cat)
        if type(cat) == "string" then
            for _, c in ipairs(self.Categories) do if c.Name == cat then cat = c break end end
        end
        if type(cat) ~= "table" then return end
        if searchBox.Text ~= "" then searchBox.Text = "" end
        self:CloseSettings(true)
        local prev = self.Current
        if prev and prev ~= cat then
            prev.Page.Visible = false
            tween(prev._fill, 0.15, { BackgroundTransparency = 1 })
            tween(prev._label, 0.15, { TextColor3 = P.Sub })
            tintIcon(prev._icon, P.Sub)
        end
        self.Current = cat
        cat.Page.Visible = true
        tween(cat._fill, 0.15, { BackgroundTransparency = 0 })
        tween(cat._label, 0.15, { TextColor3 = P.White })
        tintIcon(cat._icon, P.White)
    end

    function W:GetCategory(name)
        for _, c in ipairs(self.Categories) do if c.Name == name then return c end end
    end

    folderBtn.MouseButton1Click:Connect(function()
        for _, c in ipairs(W.Categories) do
            if c.Kind == "configs" then W:Select(c) return end
        end
    end)

    -- ── настройки GUI (шестерёнка) ──
    local gs = newModuleCore(W, L("Settings"), "")
    W.GuiSettings = gs
    local T = Library.Theme
    local modeSetting = gs:AddMode({
        Name = L("Color"), Options = { L("ModeClient"), L("ModeCustom") }, Default = L("ModeClient"),
        Callback = function(v)
            local prevMode = T.Mode
            T.Mode = (v == L("ModeCustom")) and "custom" or "client"
            if T.Mode == "client" and prevMode ~= "client" then
                for _, c in ipairs(W.Categories) do if c.Kind == "themes" then W:Select(c) break end end
            end
            if W._refreshThemes then W._refreshThemes() end
        end,
    })
    W.ModeSetting = modeSetting
    local function isCustom() return modeSetting:Get() == L("ModeCustom") end
    gs:AddColor({ Name = L("FirstColor"), Default = T.Custom1, Visible = isCustom,
        Callback = function(c) T.Custom1 = c end })
    gs:AddColor({ Name = L("SecondColor"), Default = T.Custom2, Visible = isCustom,
        Callback = function(c) T.Custom2 = c end })
    gs:AddSlider({ Name = L("ColorSpeed"), Default = T.Speed, Min = 1, Max = 5, Step = 1,
        Callback = function(v) T.Speed = v end })
    gs:AddToggle({ Name = L("ColorBlend"), Default = T.Blend, Callback = function(v) T.Blend = v end })
    gs:AddToggle({ Name = L("Blur"), Default = T.Blur, Callback = function(v)
        T.Blur = v
        if W.Open then Library:_blur(true) end
    end })
    gs:AddToggle({ Name = L("Glow"), Default = T.Glow, Callback = function(v)
        T.Glow = v
        glow.Enabled = v
    end })
    W.MenuKey = gs:AddKeybind({ Name = L("OpenMenu"), Default = o.Keybind or Enum.KeyCode.RightShift })
    gearBtn.MouseButton1Click:Connect(function() W:OpenSettings(gs) end)

    function W:_onThemeChanged()
        local t = Library.Theme
        local wantMode = (t.Mode == "custom") and L("ModeCustom") or L("ModeClient")
        if modeSetting:Get() ~= wantMode then modeSetting:Set(wantMode, true) end
        if self._refreshThemes then self._refreshThemes() end
    end

    -- ── показать / скрыть ──
    function W:Toggle(state)
        if state == nil then state = not self.Open end
        if state == self.Open then return end
        self.Open = state
        Library.Visible = state
        if state then
            main.Visible = true
            for _, e in ipairs(self._persist) do Library:BindGradient(e[1], e[2]) end
            modal.Modal = true
            uiScale.Scale = baseScale * 0.94
            tween(main, 0.2, { GroupTransparency = 0 })
            tween(uiScale, 0.2, { Scale = baseScale }, Enum.EasingStyle.Back)
        else
            self:CloseSettings(true)
            tween(main, 0.16, { GroupTransparency = 1 })
            tween(uiScale, 0.16, { Scale = baseScale * 0.96 })
            task.delay(0.18, function()
                if not self.Open then
                    main.Visible = false
                    modal.Modal = false
                    for _, e in ipairs(self._persist) do Library:UnbindGradient(e[1]) end
                end
            end)
        end
        Library:_blur(state)
    end

    function W:Destroy()
        gui:Destroy()
    end

    glow.Enabled = Library.Theme.Glow
    table.insert(Library.Windows, W)
    Library.Window = W
    Library:_start()
    return W
end

-- встроенные страницы -------------------------------------------------------
function Window:AddThemes(o)
    o = o or {}
    local W = self
    return self:AddCategory({
        Name = o.Name or "Themes", Group = o.Group or "Другие", Icon = "themes", Kind = "themes",
        Custom = function(cat, page)
            local scroll = create("ScrollingFrame", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
                ScrollBarImageColor3 = P.Dim, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
                VerticalScrollBarInset = Enum.ScrollBarInset.None, Parent = page,
            })
            local grid = create("UIGridLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder, CellPadding = UDim2.fromOffset(10, 10),
                CellSize = UDim2.fromOffset(W._cardW, 54), Parent = scroll,
            })
            padding(scroll, 0, 2, 12, 10)
            fitGrid(scroll, grid, W._cardW)
            local cards = {}
            for i, th in ipairs(Library.Themes) do
                local b = create("TextButton", {
                    Name = th.Name, BackgroundColor3 = P.White, BorderSizePixel = 0, Text = "", AutoButtonColor = false,
                    LayoutOrder = i, Parent = scroll,
                })
                corner(b, 11)
                create("UIGradient", { Color = ColorSequence.new(th.C1, th.C2), Rotation = 20, Parent = b })
                local st = stroke(b, P.White, 2, 1)
                newText("TextLabel", {
                    Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -28, 1, 0), Text = th.Name, TextSize = 14,
                    TextColor3 = Color3.fromRGB(30, 22, 24), Parent = b,
                }, "Bold")
                b.MouseButton1Click:Connect(function() Library:SetTheme(th.Name) end)
                cards[i] = st
            end
            W._refreshThemes = function()
                for i, st in ipairs(cards) do
                    local sel = Library.Theme.Mode == "client" and Library.Theme.Index == i
                    tween(st, 0.15, { Transparency = sel and 0 or 1 })
                end
            end
            W._refreshThemes()
        end,
    })
end

function Window:AddConfigs(o)
    o = o or {}
    local W = self
    return self:AddCategory({
        Name = o.Name or "Configs", Group = o.Group or "Другие", Icon = "configs", Kind = "configs",
        Custom = function(cat, page)
            local top = create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = page })
            local nameBg = create("Frame", { Size = UDim2.new(1, -46, 1, 0), BackgroundColor3 = P.Panel, BorderSizePixel = 0, Parent = top })
            corner(nameBg, 11)
            local nameBox = newText("TextBox", {
                Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -28, 1, 0), PlaceholderText = L("ConfigName"),
                PlaceholderColor3 = P.Sub, TextSize = 13, ClearTextOnFocus = false, Parent = nameBg,
            }, "Medium")
            local add = create("TextButton", {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(36, 36),
                BackgroundColor3 = P.White, Text = "", AutoButtonColor = false, Parent = top,
            })
            corner(add, 11)
            local ag = create("UIGradient", { Rotation = 20, Parent = add })
            table.insert(W._persist, { ag, 0.6 })
            ag.Color = Library:_sequence(0.6)
            local ai = makeIcon("plus", add, 16, P.White)
            ai.Position = UDim2.new(0.5, -8, 0.5, -8)
            local list = create("ScrollingFrame", {
                Position = UDim2.fromOffset(0, 46), Size = UDim2.new(1, 0, 1, -46), BackgroundTransparency = 1,
                BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = P.Dim, CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y, VerticalScrollBarInset = Enum.ScrollBarInset.None, Parent = page,
            })
            listLayout(list, 8)
            padding(list, 0, 0, 12, 10)
            local function refresh()
                for _, c in ipairs(list:GetChildren()) do
                    if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
                end
                local names = Library:ListConfigs()
                if #names == 0 then
                    newText("TextLabel", { Size = UDim2.new(1, 0, 0, 40), Text = L("NoConfigs"), TextColor3 = P.Dim, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Center, Parent = list }, "Medium")
                end
                for i, name in ipairs(names) do
                    local row = create("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = P.Card, BorderSizePixel = 0, LayoutOrder = i, Parent = list })
                    corner(row, 11)
                    stroke(row, P.Stroke, 1, 0.35)
                    newText("TextLabel", { Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -140, 1, 0), Text = name, TextSize = 14, Parent = row }, "SemiBold")
                    local function btn(iconName, x, tip, fn)
                        local b = makeIcon(iconName, row, 18, P.Sub)
                        b.AnchorPoint = Vector2.new(1, 0.5)
                        b.Position = UDim2.new(1, x, 0.5, 0)
                        b.MouseEnter:Connect(function() tintIcon(b, P.White) end)
                        b.MouseLeave:Connect(function() tintIcon(b, P.Sub) end)
                        b.MouseButton1Click:Connect(fn)
                    end
                    btn("load", -88, L("Load"), function()
                        if Library:LoadConfig(name) then Library:Notify({ Title = name, Content = L("Loaded"), Type = "success" }) end
                    end)
                    btn("save", -54, L("Save"), function()
                        Library:SaveConfig(name)
                        Library:Notify({ Title = name, Content = L("Created"), Type = "success" })
                    end)
                    btn("trash", -16, L("Delete"), function()
                        Library:DeleteConfig(name)
                        Library:Notify({ Title = name, Content = L("Deleted"), Type = "danger" })
                        refresh()
                    end)
                end
            end
            add.MouseButton1Click:Connect(function()
                local n = nameBox.Text
                if n and n:gsub("%s", "") ~= "" then
                    if Library:SaveConfig(n) then
                        Library:Notify({ Title = n, Content = L("Created"), Type = "success" })
                        nameBox.Text = ""
                        refresh()
                    end
                end
            end)
            W._refreshConfigs = refresh
            page:GetPropertyChangedSignal("Visible"):Connect(function() if page.Visible then refresh() end end)
            refresh()
        end,
    })
end

-- ───────────────────────────── HUD (уведомления, ArrayList, Watermark, TargetHud) ─────────────────────────────
function Library:_hudGui()
    if self._hud and self._hud.Parent then return self._hud end
    local g = create("ScreenGui", {
        Name = HttpService:GenerateGUID(false), ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true, DisplayOrder = 1000,
    })
    if syn and syn.protect_gui then pcall(syn.protect_gui, g) end
    g.Parent = guiParent()
    self._hud = g
    return g
end

local notifTypes = {
    info = { color = P.White, icon = "info" },
    success = { color = P.Success, icon = "success" },
    error = { color = P.Danger, icon = "error" },
    danger = { color = P.Warn, icon = "danger" },
}

function Library:Notify(o)
    if self._loading then return end
    o = o or {}
    local kind = notifTypes[o.Type or "info"] or notifTypes.info
    local dur = o.Duration or 3
    local hud = self:_hudGui()
    local holder = self._notifHolder
    if not holder or not holder.Parent then
        holder = create("Frame", {
            Name = "Notifications", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -14),
            Size = UDim2.fromOffset(280, 400), BackgroundTransparency = 1, Parent = hud,
        })
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8), Parent = holder,
        })
        self._notifHolder = holder
        self._notifCount = 0
    end
    self._notifCount = self._notifCount + 1
    local wrap = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, LayoutOrder = self._notifCount, Parent = holder,
    })
    local card = create("Frame", {
        Position = UDim2.new(1, 20, 0, 0), Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 18),
        BackgroundTransparency = 0.04, BorderSizePixel = 0, Parent = wrap,
    })
    corner(card, 11)
    stroke(card, P.Stroke, 1, 0.3)
    local icon = makeIcon(kind.icon, card, 22, P.White)
    icon.Position = UDim2.fromOffset(12, 15)
    local glyph = icon:FindFirstChild("Glyph")
    if glyph then glyph.TextColor3 = kind.color end
    newText("TextLabel", {
        Position = UDim2.fromOffset(44, 8), Size = UDim2.new(1, -54, 0, 18), Text = o.Title or "Celestial", TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = card,
    }, "Bold")
    newText("TextLabel", {
        Position = UDim2.fromOffset(44, 26), Size = UDim2.new(1, -54, 0, 16), Text = o.Content or "", TextSize = 11,
        TextColor3 = P.Sub, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card,
    }, "Medium")
    local bar = create("Frame", {
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -5), Size = UDim2.new(1, -24, 0, 2),
        BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = card,
    })
    corner(bar, 1)
    local g = create("UIGradient", { Parent = bar })
    self:BindGradient(g, 0.8, true)
    tween(wrap, 0.18, { Size = UDim2.new(1, 0, 0, 54) })
    tween(card, 0.22, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)
    tween(bar, dur, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
    task.delay(dur, function()
        if not card.Parent then return end
        tween(card, 0.2, { Position = UDim2.new(1, 20, 0, 0) })
        task.wait(0.2)
        if wrap.Parent then
            tween(wrap, 0.15, { Size = UDim2.new(1, 0, 0, 0) })
            task.wait(0.16)
            self:UnbindGradient(g)
            wrap:Destroy()
        end
    end)
end

function Library:SetArrayList(state)
    self._arrayOn = state and true or false
    self:_refreshArrayList()
end

function Library:_refreshArrayList()
    if not self._arrayOn then
        if self._arrayFrame then
            for _, c in ipairs(self._arrayFrame:GetChildren()) do
                if c:IsA("Frame") then
                    for _, d in ipairs(c:GetDescendants()) do if d:IsA("UIGradient") then self:UnbindGradient(d) end end
                    c:Destroy()
                end
            end
            self._arrayFrame.Visible = false
        end
        return
    end
    local hud = self:_hudGui()
    local frame = self._arrayFrame
    if not frame or not frame.Parent then
        frame = create("Frame", {
            Name = "ArrayList", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 8), Size = UDim2.fromOffset(0, 0),
            AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, Parent = hud,
        })
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 2), Parent = frame,
        })
        self._arrayFrame = frame
    end
    frame.Visible = true
    for _, c in ipairs(frame:GetChildren()) do
        if c:IsA("Frame") then
            for _, d in ipairs(c:GetDescendants()) do if d:IsA("UIGradient") then self:UnbindGradient(d) end end
            c:Destroy()
        end
    end
    local list = {}
    for _, m in ipairs(self.Modules) do
        if m.Enabled and m.Category and not self.ArrayListHide[m.Category.Name] then
            local text = self.ArrayListLowercase and m.Name:lower() or m.Name
            local w = #text
            pcall(function() w = TextService:GetTextSize(text, 14, Enum.Font.Montserrat, Vector2.new(1000, 100)).X end)
            list[#list + 1] = { text = text, w = w }
        end
    end
    table.sort(list, function(a, b) return a.w > b.w end)
    for i, e in ipairs(list) do
        local row = create("Frame", {
            Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = Color3.fromRGB(10, 10, 12),
            BackgroundTransparency = 0.35, BorderSizePixel = 0, LayoutOrder = i, Parent = frame,
        })
        padding(row, 6, 2, 9, 2)
        local lbl = newText("TextLabel", {
            Size = UDim2.fromOffset(0, 16), AutomaticSize = Enum.AutomaticSize.X, Text = e.text, TextSize = 14,
            TextColor3 = P.White, Parent = row,
        }, "SemiBold")
        local tg = create("UIGradient", { Parent = lbl })
        self:BindGradient(tg, 0.8, true)
        local bar = create("Frame", {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 9, 0, -2), Size = UDim2.new(0, 2, 1, 4),
            BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = row,
        })
        local bg = create("UIGradient", { Rotation = 90, Parent = bar })
        self:BindGradient(bg, 0.8, true)
    end
end

function Library:SetWatermark(state, text)
    self._wmOn = state and true or false
    if text then self._wmText = text end
    local hud = self:_hudGui()
    if not self._wm or not self._wm.Parent then
        local f = create("Frame", {
            Name = "Watermark", Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(0, 26), AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = Color3.fromRGB(13, 13, 15), BackgroundTransparency = 0.12, BorderSizePixel = 0, Parent = hud,
        })
        corner(f, 8)
        padding(f, 10, 0, 10, 0)
        local st = stroke(f, P.White, 1, 0.2)
        local g = create("UIGradient", { Rotation = 0, Parent = st })
        self:BindGradient(g, 0.8, true)
        self._wmLabel = newText("TextLabel", {
            Size = UDim2.fromOffset(0, 26), AutomaticSize = Enum.AutomaticSize.X, TextSize = 12, Parent = f,
        }, "SemiBold")
        self._wm = f
        self:MakeDraggable(f, f, function() return Library.Visible end)
    end
    self._wm.Visible = self._wmOn
    self:_updateWatermark()
end

function Library:_updateWatermark()
    if not (self._wm and self._wm.Parent and self._wmOn) then return end
    local ping = 0
    pcall(function()
        ping = math.floor(svc("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
    end)
    local txt = self._wmText or ((self.Window and self.Window.Title) or "Celestial")
    self._wmLabel.Text = string.format("%s  |  %s  |  %d fps  |  %d ms", txt, LocalPlayer.Name, self.FPS or 60, ping)
end

function Library:GetTargetHud()
    if self._target and self._target.Frame.Parent then return self._target end
    local hud = self:_hudGui()
    local f = create("Frame", {
        Name = "TargetHud", Position = UDim2.new(0.5, 40, 0.5, 40), Size = UDim2.fromOffset(220, 58),
        BackgroundColor3 = Color3.fromRGB(13, 13, 15), BackgroundTransparency = 0.08, BorderSizePixel = 0, Visible = false,
        Parent = hud,
    })
    corner(f, 12)
    stroke(f, P.Stroke, 1, 0.2)
    local face = create("ImageLabel", {
        Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(38, 38), BackgroundColor3 = P.Panel, BorderSizePixel = 0, Parent = f,
    })
    corner(face, 9)
    local nameL = newText("TextLabel", { Position = UDim2.fromOffset(58, 8), Size = UDim2.new(1, -68, 0, 18), TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f }, "Bold")
    local track = create("Frame", { Position = UDim2.fromOffset(58, 32), Size = UDim2.new(1, -68, 0, 8), BackgroundColor3 = P.Off, BorderSizePixel = 0, Parent = f })
    corner(track, 4)
    local fill = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = track })
    corner(fill, 4)
    local g = create("UIGradient", { Parent = fill })
    self:BindGradient(g, 0.6, true)
    local hp = newText("TextLabel", { Position = UDim2.fromOffset(58, 42), Size = UDim2.new(1, -68, 0, 12), TextSize = 10, TextColor3 = P.Sub, Parent = f }, "Medium")
    local obj = { Frame = f }
    function obj:Update(name, health, maxHealth, userId)
        maxHealth = maxHealth or 100
        health = math.clamp(health or 0, 0, maxHealth)
        nameL.Text = tostring(name or "Target")
        hp.Text = string.format("%d / %d", math.floor(health + 0.5), math.floor(maxHealth + 0.5))
        tween(fill, 0.15, { Size = UDim2.fromScale(maxHealth > 0 and health / maxHealth or 0, 1) })
        if userId then
            pcall(function() face.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150" end)
        end
        f.Visible = true
    end
    function obj:Hide() f.Visible = false end
    self._target = obj
    self:MakeDraggable(f, f, function() return Library.Visible end)
    return obj
end

-- ───────────────────────────── конфиги ─────────────────────────────
Library.MemoryConfigs = {}

local function serializeSetting(s)
    local t = s.Type
    if t == "Button" or t == "Label" then return nil end
    if t == "Color" then
        local c = s.Value
        return { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) }
    elseif t == "Keybind" then
        return s.Value and tostring(s.Value) or ""
    elseif t == "MultiSelect" then
        local r = {}
        for k, v in pairs(s.Value) do r[k] = v end
        return r
    end
    return s.Value
end

local function parseEnum(str)
    if type(str) ~= "string" or str == "" then return nil end
    local kind, name = str:match("^Enum%.(%w+)%.(%w+)$")
    if not kind then return nil end
    local ok, r = pcall(function() return Enum[kind][name] end)
    return ok and r or nil
end

local function applySetting(s, v)
    local t = s.Type
    if t == "Button" or t == "Label" or v == nil then return end
    if t == "Color" and type(v) == "table" then
        s:Set(Color3.fromRGB(v[1] or 255, v[2] or 255, v[3] or 255))
    elseif t == "Keybind" then
        s:Set(parseEnum(v))
    else
        s:Set(v)
    end
end

function Library:GetConfigData()
    local data = { Version = 1, Modules = {}, Gui = {}, Theme = {
        Mode = self.Theme.Mode, Name = (self.Themes[self.Theme.Index] or {}).Name,
    } }
    for _, m in ipairs(self.Modules) do
        local e = { Enabled = m.Enabled, Bind = m.Bind and tostring(m.Bind) or "", Settings = {} }
        for _, s in ipairs(m.Settings) do
            local v = serializeSetting(s)
            if v ~= nil then e.Settings[s._key] = v end
        end
        data.Modules[m._key] = e
    end
    if self.Window and self.Window.GuiSettings then
        for _, s in ipairs(self.Window.GuiSettings.Settings) do
            local v = serializeSetting(s)
            if v ~= nil then data.Gui[s._key] = v end
        end
    end
    return data
end

function Library:ApplyConfigData(data)
    if type(data) ~= "table" then return false end
    self._loading = true
    local ok, err = pcall(function()
        if data.Gui and self.Window and self.Window.GuiSettings then
            for _, s in ipairs(self.Window.GuiSettings.Settings) do applySetting(s, data.Gui[s._key]) end
        end
        if data.Theme and data.Theme.Name and data.Theme.Mode == "client" then self:SetTheme(data.Theme.Name) end
        for _, m in ipairs(self.Modules) do
            local e = data.Modules and data.Modules[m._key]
            if e then
                for _, s in ipairs(m.Settings) do applySetting(s, e.Settings and e.Settings[s._key]) end
                m:SetKeybind(parseEnum(e.Bind))
                m:SetEnabled(e.Enabled == true)
            else
                m:SetEnabled(false)
            end
        end
    end)
    self._loading = false
    if not ok then warn("[Celestial] config error: " .. tostring(err)) end
    self:_refreshArrayList()
    return ok
end

local function cfgName(name)
    name = tostring(name or ""):gsub('[\\/:*?"<>|]', ""):gsub("^%s+", ""):gsub("%s+$", "")
    return name ~= "" and name or nil
end

function Library:SaveConfig(name)
    name = cfgName(name)
    if not name then return false end
    local ok, json = pcall(function() return HttpService:JSONEncode(self:GetConfigData()) end)
    if not ok then return false end
    if writefile then
        ensureFolders()
        local wok = pcall(writefile, self.Folder .. "/configs/" .. name .. ".json", json)
        if wok then return true end
    end
    self.MemoryConfigs[name] = json
    return true
end

function Library:LoadConfig(name)
    name = cfgName(name)
    if not name then return false end
    local json = self.MemoryConfigs[name]
    local path = self.Folder .. "/configs/" .. name .. ".json"
    if readfile and isfile then
        local ok, exists = pcall(isfile, path)
        if ok and exists then
            local rok, content = pcall(readfile, path)
            if rok then json = content end
        end
    end
    if not json then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok then return false end
    return self:ApplyConfigData(data)
end

function Library:DeleteConfig(name)
    name = cfgName(name)
    if not name then return end
    self.MemoryConfigs[name] = nil
    if delfile and isfile then
        pcall(function()
            local path = self.Folder .. "/configs/" .. name .. ".json"
            if isfile(path) then delfile(path) end
        end)
    end
end

function Library:ListConfigs()
    local names, seen = {}, {}
    if listfiles and isfolder then
        pcall(function()
            if isfolder(self.Folder .. "/configs") then
                for _, f in ipairs(listfiles(self.Folder .. "/configs")) do
                    local n = tostring(f):match("([^/\\]+)%.json$")
                    if n and not seen[n] then seen[n] = true names[#names + 1] = n end
                end
            end
        end)
    end
    for n in pairs(self.MemoryConfigs) do
        if not seen[n] then seen[n] = true names[#names + 1] = n end
    end
    table.sort(names)
    return names
end

-- ───────────────────────────── глобальный цикл / ввод ─────────────────────────────
function Library:_start()
    if self._started then return end
    self._started = true
    local acc, fpsAcc, frames = 0, 0, 0
    self:Connect(RunService.Heartbeat, function(dt)
        self._time = self._time + dt
        acc = acc + dt
        if acc >= 1 / 40 then
            acc = 0
            if self.Visible then self:_updateSet(self._grads) end
            if next(self._hudGrads) then self:_updateSet(self._hudGrads) end
        end
        frames = frames + 1
        fpsAcc = fpsAcc + dt
        if fpsAcc >= 0.5 then
            self.FPS = math.floor(frames / fpsAcc + 0.5)
            frames, fpsAcc = 0, 0
            self:_updateWatermark()
        end
    end)
    self:Connect(UIS.InputBegan, function(input, gpe)
        local listening = self._listening
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    listening._listenDone(nil, true)
                elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
                    listening._listenDone(nil, false)
                else
                    listening._listenDone(input.KeyCode, false)
                end
                return
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                listening._listenDone(input.UserInputType, false)
                return
            end
            return
        end
        if UIS:GetFocusedTextBox() then return end
        if input.KeyCode == Enum.KeyCode.Escape then
            for _, w in ipairs(self.Windows) do
                if w._popupModule then w:CloseSettings() return end
            end
        end
        for _, w in ipairs(self.Windows) do
            if w.MenuKey and bindMatches(w.MenuKey.Value, input) then
                w:Toggle()
                return
            end
        end
        if input.UserInputType == Enum.UserInputType.Keyboard or not gpe then
            for _, m in ipairs(self.Modules) do
                if m.Bind and bindMatches(m.Bind, input) then m:Toggle() end
            end
        end
    end)
end

function Library:OnUnload(fn)
    self._unloadFns = self._unloadFns or {}
    table.insert(self._unloadFns, fn)
end

function Library:Unload()
    if self.Unloaded then return end
    self.Unloaded = true
    for _, m in ipairs(self.Modules) do
        if m.Enabled then
            m.Enabled = false
            safeCall(m.Callback, false)
        end
    end
    for _, fn in ipairs(self._unloadFns or {}) do safeCall(fn) end
    self.Visible = false
    for _, c in ipairs(self._conns or {}) do pcall(function() c:Disconnect() end) end
    self._conns = {}
    for _, w in ipairs(self.Windows) do pcall(function() w:Destroy() end) end
    if self._hud then pcall(function() self._hud:Destroy() end) end
    local fx = Lighting:FindFirstChild("CelestialBlur")
    if fx then fx:Destroy() end
    self.Windows, self.Modules, self.Categories = {}, {}, {}
    self._grads, self._hudGrads = {}, {}
    self._started, self._listening = false, nil
    if genv.CelestialLibrary == self then genv.CelestialLibrary = nil end
end

return Library

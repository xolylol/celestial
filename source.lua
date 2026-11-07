local Library = {}
Library.__index = Library
Library.Version = "1.0.0"
Library.Folder = "Celestial"
Library.AssetBase = "https://raw.githubusercontent.com/xolylol/celestial/main/"
Library.IconBase = Library.AssetBase .. "icons/"
Library.GlowColor = Color3.new(0, 0, 0)            -- assets/glow.png is white, it gets tinted with ImageColor3
Library.SoundsEnabled = true
Library.SoundPitch = 1
Library.NotifySound = true
Library.ArrayListGlow = true
Library.ArrayListOffset = 2
Library.StudsPerBlock = 3.571
Library.HudState = { Enabled = false, Watermark = true, ModuleBinds = true, Fps = true, Bps = true, Tps = true, Coords = true }
Library.SoundVolume = 0.6
Library.Sounds = {
    Enable = "sounds/module/module_enable.ogg",
    Disable = "sounds/module/module_disable.ogg",
    Notification = "sounds/notifications/notification.ogg",
}
Library.Icons = {}
Library.Language = "ru"                            -- "ru" | "en"
Library.NotifyOnToggle = true
Library.ArrayListHide = { Render = true }
Library.Visible = false
Library.Modules = {}
Library.Categories = {}
Library.Windows = {}



local genv = _G
if type(getgenv) == "function" then
    local ok, env = pcall(getgenv)
    if ok and type(env) == "table" then genv = env end
end
if type(genv.CelestialLibrary) == "table"
    and type(genv.CelestialLibrary.Unload) == "function" then
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
if not LocalPlayer then
    error("[Celestial] Run this library on the Roblox client (LocalScript or client executor).", 0)
end

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
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then playerGui = LocalPlayer:WaitForChild("PlayerGui", 10) end
    if not playerGui then error("[Celestial] Unable to access PlayerGui.", 0) end
    return playerGui
end


Library.Languages = {
    ru = {
        Search = "Поиск", Logout = "Выйти", Settings = "Настройка", Modules = "Modules",
        OpenMenu = "Открыть меню", Color = "Цвет", ModeClient = "Клиентский", ModeCustom = "Кастомный",
        FirstColor = "Первый цвет", SecondColor = "Второй цвет", ColorSpeed = "Скорость цвета",
        ColorBlend = "Смешивание цветов", Blur = "Размытие", Glow = "Свечение",
        Enabled = "включен", Disabled = "выключен", Selected = "выбрано", NothingSelected = "Не выбрано",
        ConfigName = "Название конфига", Save = "Сохранить", Load = "Загрузить", Delete = "Удалить",
        Created = "Конфиг сохранён", Loaded = "Конфиг загружен", Deleted = "Конфиг удалён",
        NoConfigs = "Конфигов пока нет", Themes = "Темы", Configs = "Конфиги", Press = "Нажмите клавишу...",
    },
    en = {
        Search = "Search", Logout = "Logout", Settings = "Settings", Modules = "Modules",
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


local P = {
    Window = Color3.fromRGB(9, 9, 11),
    Panel = Color3.fromRGB(15, 15, 18),
    Card = Color3.fromRGB(13, 13, 16),
    CardHover = Color3.fromRGB(23, 23, 27),
    Row = Color3.fromRGB(27, 27, 31),
    Group = Color3.fromRGB(18, 18, 21),
    Stroke = Color3.fromRGB(40, 40, 46),
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
    Custom1 = Color3.fromRGB(190, 101, 255),
    Custom2 = Color3.fromRGB(62, 21, 104),
    Speed = 3, Blend = false, Blur = true, Glow = true,
}

Library._time = 0
Library._grads = {}
Library._hudGrads = {}

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


local Glyphs = {
    combat = "⚔", movement = "➤", render = "◉", player = "☻", util = "✱", configs = "☰", themes = "◐",
    autobuy_items = "▦", autobuy_history = "↺", gear = "⚙", attach = "⚲", search = "⌕", folder = "▤",
    close = "✕", logout = "⏻", plus = "+", save = "▣", load = "▼", trash = "✖", play = "▶",
    info = "i", success = "✓", error = "✕", danger = "!",
}
local IconAssets, IconWaiters = {}, {}

local function ensureFolders()
    if not (makefolder and isfolder) then return end
    pcall(function()
        for _, sub in ipairs({ "", "/icons", "/configs", "/assets", "/fonts", "/sounds", "/sounds/module", "/sounds/notifications" }) do
            local path = Library.Folder .. sub
            if not isfolder(path) then makefolder(path) end
        end
    end)
end

-- generic downloader: Library.AssetBase .. rel  ->  Celestial/<rel>  ->  getcustomasset
local Assets, AssetWaiters = {}, {}
local function requestAsset(rel, cb, onFail)
    if Assets[rel] then cb(Assets[rel]) return end
    if not (writefile and isfile and getcustomasset) then
        if onFail then onFail() end
        return
    end
    local w = AssetWaiters[rel]
    if not w then
        w = { busy = false }
        AssetWaiters[rel] = w
    end
    table.insert(w, cb)
    if onFail then
        w.fails = w.fails or {}
        table.insert(w.fails, onFail)
    end
    if w.busy then return end
    w.busy = true
    task.spawn(function()
        local ok, err = pcall(function()
            ensureFolders()
            local path = Library.Folder .. "/" .. rel
            if not isfile(path) then
                local data = game:HttpGet(Library.AssetBase .. rel)
                if type(data) ~= "string" or #data < 16 then error(rel .. " not found") end
                if rel:sub(-4) == ".png" and data:sub(2, 4) ~= "PNG" then error(rel .. " is not a png") end
                writefile(path, data)
            end
            Assets[rel] = getcustomasset(path)
        end)
        w.busy = false
        if ok and Assets[rel] then
            for _, f in ipairs(w) do pcall(f, Assets[rel]) end
        elseif not ok then
            warn("[Celestial] asset '" .. rel .. "': " .. tostring(err))
            for _, f in ipairs(w.fails or {}) do pcall(f) end
        end
        w.fails = nil
        for i = #w, 1, -1 do w[i] = nil end
    end)
end

local function requestIcon(name, cb)
    requestAsset("icons/" .. name .. ".png", cb)
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

-- Glow: assets/glow.png (white) tinted black, sits BEHIND its target (must be a sibling of it)
local function glowShow(img, on, t)
    if not img or not img.Parent then return end
    img:SetAttribute("On", on and true or false)
    local base = img:GetAttribute("Base") or 0.4
    local target = on and base or 1
    local fake = img:FindFirstChild("Fake")
    if fake then
        if (t or 0) <= 0 then fake.GroupTransparency = target else tween(fake, t, { GroupTransparency = target }) end
    elseif img.Image ~= "" then
        if (t or 0) <= 0 then img.ImageTransparency = target else tween(img, t, { ImageTransparency = target }) end
    end
end

-- used when glow.png can't be downloaded (or the executor has no file api): stacked soft rounded layers
local function buildFakeGlow(img, spread, color)
    if img:FindFirstChild("Fake") then return end
    local fake = create("CanvasGroup", {
        Name = "Fake", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, GroupTransparency = 1, Parent = img,
    })
    local N = 8
    for i = 1, N do
        local inset = spread * 2 * (i - 1) / N
        local f = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, -inset, 1, -inset), BackgroundColor3 = color, BackgroundTransparency = 0.9,
            BorderSizePixel = 0, Parent = fake,
        })
        corner(f, 14 + spread * (N - i + 1) / N)
    end
end

local function makeGlow(parent, o)
    o = o or {}
    local spread = o.Spread or 40
    local color = o.Color or Library.GlowColor
    local img = create("ImageLabel", {
        Name = "Glow", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, spread * 2, 1, spread * 2), BackgroundTransparency = 1, BorderSizePixel = 0,
        Image = "", ImageColor3 = color, ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Stretch, ZIndex = 0, Active = false, Parent = parent,
    })
    img:SetAttribute("Base", o.Transparency or 0.4)
    img:SetAttribute("On", true)
    local function fallback()
        if img.Parent == nil then return end
        buildFakeGlow(img, spread, color)
        glowShow(img, img:GetAttribute("On") ~= false, 0.25)
    end
    requestAsset("assets/glow.png", function(asset)
        if img.Parent == nil then return end
        img.Image = asset
        glowShow(img, img:GetAttribute("On") ~= false, 0.25)
    end, fallback)
    return img
end

-- AnimValue (port of core AnimValue): value that eases towards Target every frame
Library._anims = setmetatable({}, { __mode = "k" })
local Anim = {}
Anim.__index = Anim
function Library.NewAnim(value, speed, onUpdate)
    local a = setmetatable({ Value = value or 0, Target = value or 0, Speed = speed or 10, OnUpdate = onUpdate }, Anim)
    Library._anims[a] = true
    return a
end
function Anim:Set(target, instant)
    self.Target = target
    if instant then self.Value = target if self.OnUpdate then self.OnUpdate(self.Value) end end
end
function Anim:Get() return self.Value end
function Library:_stepAnims(dt)
    for a in pairs(self._anims) do
        if a.Value ~= a.Target then
            local nv = a.Value + (a.Target - a.Value) * math.min(1, dt * a.Speed)
            if math.abs(nv - a.Target) < 1e-3 then nv = a.Target end
            a.Value = nv
            if a.OnUpdate then a.OnUpdate(nv) end
        end
    end
end

function Library:PlaySound(name)
    if not self.SoundsEnabled or self._loading then return end
    local rel = self.Sounds[name]
    if not rel then return end
    if name == "Notification" and self.NotifySound == false then return end
    requestAsset(rel, function(asset)
        local snd = Instance.new("Sound")
        snd.SoundId = asset
        snd.Volume = self.SoundVolume
        snd.PlaybackSpeed = (name == "Notification") and self.SoundPitch or 1
        snd.Parent = svc("SoundService")
        snd.Ended:Once(function() snd:Destroy() end)
        snd:Play()
        task.delay(6, function() if snd.Parent then snd:Destroy() end end)
    end)
end

-- custom font from the repo (fonts/<file>.ttf) -> Font object via generated family json
function Library:LoadFont(file, family, cb)
    requestAsset("fonts/" .. file, function(ttf)
        if not (writefile and getcustomasset) then return end
        local ok, font = pcall(function()
            local json = HttpService:JSONEncode({ name = family, faces = { { name = "Regular", weight = 400, style = "normal", assetId = ttf } } })
            local path = Library.Folder .. "/fonts/" .. family .. ".json"
            writefile(path, json)
            return Font.new(getcustomasset(path), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end)
        if ok and cb then cb(font) end
    end)
end

Library._P = P
Library._util = {
    create = create, newText = newText, corner = corner, stroke = stroke, padding = padding,
    listLayout = listLayout, tween = tween, isPress = isPress, isMove = isMove, decimals = decimals,
    fmtNumber = fmtNumber, safeCall = safeCall, makeIcon = makeIcon, tintIcon = tintIcon,
    svc = svc, guiParent = guiParent, ensureFolders = ensureFolders, makeGlow = makeGlow, glowShow = glowShow, requestAsset = requestAsset,
}


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
    if self._keyed then
        for _, fn in pairs(self._keyed) do safeCall(fn, self.Value) end
    end
end

-- like Setting.id_class(String key, BiConsumer) in the Java core: a named listener is replaced, not duplicated
function Setting:OnChanged(fn, key)
    if key then
        self._keyed = self._keyed or {}
        self._keyed[key] = fn
    else
        table.insert(self._listeners, fn)
    end
    return self
end

function Setting:RemoveListener(key)
    if self._keyed then self._keyed[key] = nil end
end

function Setting:Reset(silent)
    if self._default ~= nil and self.Type ~= "MultiSelect" then self:Set(self._default, silent) end
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
        Type = kind, Name = o.Name or kind, Callback = o.Callback, VisibleFn = o.Visible, _default = o.Default,
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
    if self.Category then Library:PlaySound(state and "Enable" or "Disable") end
    if Library.NotifyOnToggle and self.Category then
        Library:Notify({
            Title = L("Modules"), Content = self.Name .. " " .. (state and L("Enabled") or L("Disabled")),
            Type = "info", Duration = 2, Silent = true,
        })
    end
    Library:_refreshArrayList()
end

function Module:SetKeybind(key)
    self.Bind = key
    if self._renderBind then self._renderBind() end
    Library:_refreshKeybinds()
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
    corner(card, 9)
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

    local root = create("Frame", {
        Name = "Root", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(size.X, size.Y), BackgroundTransparency = 1, Visible = false, Parent = gui,
    })
    local glowImg = makeGlow(root, { Spread = 54, Transparency = 0.25 })
    local main = create("CanvasGroup", {
        Name = "Main", Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.Window, BackgroundTransparency = 0,
        BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 1, Parent = root,
    })
    corner(main, 16)
    local glow = stroke(main, P.Stroke, 1, 0.35)
    W.Glow = glow
    W.GlowImage = glowImg
    local baseScale = o.Scale or 1
    pcall(function()
        local vp = workspace.CurrentCamera.ViewportSize
        baseScale = math.min(baseScale, vp.X / (size.X + 40), vp.Y / (size.Y + 40))
    end)
    local uiScale = create("UIScale", { Scale = baseScale, Parent = root })
    W.Main = main
    W.Root = root

    local modal = create("TextButton", { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1, Text = "", Modal = false, Parent = gui })


    local side = create("Frame", { Name = "Sidebar", Size = UDim2.new(0, 176, 1, 0), BackgroundTransparency = 1, Active = true, Parent = main })
    Library:MakeDraggable(side, root)
    create("Frame", {
        Position = UDim2.new(1, -1, 0, 14), Size = UDim2.new(0, 1, 1, -28), BackgroundColor3 = P.Stroke,
        BackgroundTransparency = 0.45, BorderSizePixel = 0, Parent = side,
    })
    local logo = create("Frame", {
        Position = UDim2.fromOffset(14, 14), Size = UDim2.fromOffset(38, 38), BackgroundColor3 = P.White,
        BorderSizePixel = 0, Parent = side,
    })
    corner(logo, 10)
    local logoGrad = create("UIGradient", { Rotation = 45, Parent = logo })
    table.insert(W._persist, { logoGrad, 0.6 })
    logoGrad.Color = Library:_sequence(0.6)
    local atom = makeIcon("atom32", logo, 26, P.White)
    atom.AnchorPoint = Vector2.new(0.5, 0.5)
    atom.Position = UDim2.fromScale(0.5, 0.5)
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

    local logoutGlow = makeGlow(side, { Spread = 30, Transparency = 0.1 })
    logoutGlow.AnchorPoint = Vector2.new(0.5, 1)
    logoutGlow.Position = UDim2.new(0.5, 0, 1, 34)
    logoutGlow.Size = UDim2.new(1, 60, 0, 140)
    logoutGlow.ZIndex = 1
    W.LogoutGlow = logoutGlow

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


    local content = create("Frame", { Name = "Content", Position = UDim2.fromOffset(176, 0), Size = UDim2.new(1, -176, 1, 0), BackgroundTransparency = 1, Parent = main })
    padding(content, 6, 12, 14, 12)
    local bar = create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = content })
    local searchBg = create("Frame", { Size = UDim2.new(1, -84, 1, 0), BackgroundColor3 = P.Panel, BorderSizePixel = 0, Parent = bar })
    corner(searchBg, 11)
    stroke(searchBg, P.Stroke, 1, 0.4)
    local sIcon = makeIcon("search", searchBg, 15, P.Sub)
    sIcon.Position = UDim2.new(0, 11, 0.5, -7)
    local searchBox = newText("TextBox", {
        Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -44, 1, 0), PlaceholderText = L("Search"),
        PlaceholderColor3 = P.Sub, TextSize = 13, ClearTextOnFocus = false, Parent = searchBg,
    }, "Medium")
    local folderBtn = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -40, 0, 0), Size = UDim2.fromOffset(36, 36),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = bar,
    })
    corner(folderBtn, 11)
    local fIcon = makeIcon("folder", folderBtn, 17, P.Sub)
    fIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    local gearBtn = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(36, 36),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = bar,
    })
    corner(gearBtn, 11)
    local gIcon = makeIcon("gear", gearBtn, 17, P.Sub)
    gIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    for _, pair in ipairs({ { folderBtn, fIcon }, { gearBtn, gIcon } }) do
        pair[1].MouseEnter:Connect(function() tintIcon(pair[2], P.White) end)
        pair[1].MouseLeave:Connect(function() tintIcon(pair[2], P.Sub) end)
    end

    local pages = create("Frame", {
        Name = "Pages", Position = UDim2.fromOffset(0, 48), Size = UDim2.new(1, 0, 1, -48), BackgroundTransparency = 1,
        ClipsDescendants = true, Parent = content,
    })
    W.Pages = pages
    W._cardW = math.floor((size.X - 208 - 10) / 2)


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


    local PW, PH = 340, math.floor(size.Y * 0.84)
    local pwin = create("Frame", {
        Name = "SettingsWindow", Size = UDim2.fromOffset(PW, PH), BackgroundTransparency = 1, Visible = false, Parent = gui,
    })
    local pScale = create("UIScale", { Scale = baseScale, Parent = pwin })
    local pGlow = makeGlow(pwin, { Spread = 44, Transparency = 0.25 })
    local box = create("CanvasGroup", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.Window, BorderSizePixel = 0, GroupTransparency = 1,
        ZIndex = 1, Parent = pwin,
    })
    corner(box, 14)
    stroke(box, P.Stroke, 1, 0.35)
    local pHead = create("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Active = true, Parent = box })
    local pTitle = newText("TextLabel", {
        Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -60, 1, 0), TextSize = 15, Parent = pHead,
    }, "Bold")
    local pClose = makeIcon("close", pHead, 13, P.Sub)
    pClose.AnchorPoint = Vector2.new(1, 0.5)
    pClose.Position = UDim2.new(1, -16, 0.5, 0)
    local pBody = create("Frame", { Position = UDim2.fromOffset(0, 42), Size = UDim2.new(1, 0, 1, -42), BackgroundTransparency = 1, ClipsDescendants = true, Parent = box })
    Library:MakeDraggable(pHead, pwin)
    W._popup = { frame = pwin, box = box, scale = pScale, title = pTitle, body = pBody }

    function W:OpenSettings(m)
        if self._popupModule then self:CloseSettings(true) end
        self._popupModule = m
        pTitle.Text = m.Name
        m._panel.Parent = pBody
        m:_activate(true)
        -- place it next to the menu (right side, or left if there is no room)
        local vp = gui.AbsoluteSize
        local ap, asz = root.AbsolutePosition, root.AbsoluteSize
        local pw, ph = PW * baseScale, PH * baseScale
        local x = ap.X + asz.X + 12
        if x + pw > vp.X - 8 then x = ap.X - pw - 12 end
        x = math.clamp(x, 8, math.max(8, vp.X - pw - 8))
        local y = math.clamp(ap.Y + (asz.Y - ph) / 2, 8, math.max(8, vp.Y - ph - 8))
        pwin.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
        pwin.Visible = true
        pScale.Scale = baseScale * 0.94
        tween(box, 0.18, { GroupTransparency = 0 })
        tween(pScale, 0.2, { Scale = baseScale }, Enum.EasingStyle.Back)
        glowShow(pGlow, Library.Theme.Glow, 0.2)
    end
    function W:CloseSettings(instant)
        local m = self._popupModule
        if not m then return end
        self._popupModule = nil
        m._panel.Parent = nil
        m:_activate(false)
        if instant then
            pwin.Visible = false
            box.GroupTransparency = 1
            pScale.Scale = baseScale * 0.94
            glowShow(pGlow, false, 0)
            return
        end
        tween(box, 0.15, { GroupTransparency = 1 })
        tween(pScale, 0.15, { Scale = baseScale * 0.94 })
        glowShow(pGlow, false, 0.15)
        task.delay(0.17, function()
            if not self._popupModule then pwin.Visible = false end
        end)
    end
    pClose.MouseButton1Click:Connect(function() W:CloseSettings() end)

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
            if self.Current ~= cat and not cat.Locked then tween(fill, 0.12, { BackgroundTransparency = 0.9 }) end
        end)
        btn.MouseLeave:Connect(function()
            if self.Current ~= cat then tween(fill, 0.12, { BackgroundTransparency = 1 }) end
        end)
        cat.Locked = c.Locked == true
        if cat.Locked then
            tintIcon(icon, P.Dim)
            lbl.TextColor3 = P.Dim
        end
        btn.MouseButton1Click:Connect(function() if not cat.Locked then self:Select(cat) end end)

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
        glowShow(glowImg, v and W.Open, 0.2)
    end })
    W.MenuKey = gs:AddKeybind({ Name = L("OpenMenu"), Default = o.Keybind or Enum.KeyCode.RightShift })
    gearBtn.MouseButton1Click:Connect(function() W:OpenSettings(gs) end)

    function W:_onThemeChanged()
        local t = Library.Theme
        local wantMode = (t.Mode == "custom") and L("ModeCustom") or L("ModeClient")
        if modeSetting:Get() ~= wantMode then modeSetting:Set(wantMode, true) end
        if self._refreshThemes then self._refreshThemes() end
    end


    function W:Toggle(state)
        if state == nil then state = not self.Open end
        if state == self.Open then return end
        self.Open = state
        Library.Visible = state
        if state then
            root.Visible = true
            for _, e in ipairs(self._persist) do Library:BindGradient(e[1], e[2]) end
            modal.Modal = true
            uiScale.Scale = baseScale * 0.94
            tween(main, 0.2, { GroupTransparency = 0 })
            glowShow(glowImg, Library.Theme.Glow, 0.25)
            tween(uiScale, 0.2, { Scale = baseScale }, Enum.EasingStyle.Back)
        else
            self:CloseSettings(true)
            tween(main, 0.16, { GroupTransparency = 1 })
            glowShow(glowImg, false, 0.16)
            tween(uiScale, 0.16, { Scale = baseScale * 0.96 })
            task.delay(0.18, function()
                if not self.Open then
                    root.Visible = false
                    modal.Modal = false
                    for _, e in ipairs(self._persist) do Library:UnbindGradient(e[1]) end
                end
            end)
        end
        Library:_blur(state)
        Library:_hudPreview(state)
    end

    function W:Destroy()
        gui:Destroy()
    end

    table.insert(Library.Windows, W)
    Library.Window = W
    Library:_start()
    return W
end


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
    info = { icon = "info", color = P.White },
    success = { icon = "success", color = P.Success },
    error = { icon = "error", color = P.Danger },
    danger = { icon = "danger", color = P.Warn },
}

function Library:Notify(o)
    if self._loading then return end
    o = o or {}
    local kind = notifTypes[o.Type or "info"] or notifTypes.info
    local dur = o.Duration or 3
    if not o.Silent then self:PlaySound("Notification") end
    local hud = self:_hudGui()
    local holder = self._notifHolder
    if not holder or not holder.Parent then
        holder = create("Frame", {
            Name = "Notifications", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -14),
            Size = UDim2.fromOffset(340, 400), BackgroundTransparency = 1, Parent = hud,
        })
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8), Parent = holder,
        })
        self._notifHolder = holder
        self._notifCount = 0
    end
    self._notifCount = self._notifCount + 1
    local wrap = create("Frame", { Size = UDim2.fromOffset(340, 0), BackgroundTransparency = 1, LayoutOrder = self._notifCount, Parent = holder })
    local slide = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(0, 46),
        AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = wrap,
    })
    local sScale = create("UIScale", { Scale = 0.85, Parent = slide })
    local glowImg = makeGlow(slide, { Spread = 22, Transparency = 0.3 })
    local card = create("CanvasGroup", {
        Size = UDim2.fromOffset(0, 46), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = Color3.fromRGB(14, 13, 22),
        BackgroundTransparency = 0.05, BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 1, Parent = slide,
    })
    corner(card, 12)
    local cs = stroke(card, P.White, 1.5, 0.25)
    local sg = create("UIGradient", { Rotation = 20, Parent = cs })
    self:BindGradient(sg, 0.8, true)
    local tint = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 1, Parent = card })
    local tg = create("UIGradient", { Rotation = 20, Parent = tint })
    self:BindGradient(tg, 0.8, true)
    local row = create("Frame", { Size = UDim2.fromOffset(0, 46), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ZIndex = 2, Parent = card })
    padding(row, 14, 0, 18, 0)
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = row,
    })
    local icon = makeIcon(kind.icon, row, 22, kind.color)
    icon.LayoutOrder = 1
    icon.ZIndex = 2
    local texts = create("Frame", { Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 2, Parent = row })
    listLayout(texts, 0)
    newText("TextLabel", {
        Size = UDim2.fromOffset(0, 19), AutomaticSize = Enum.AutomaticSize.X, Text = o.Title or "Celestial", TextSize = 15,
        ZIndex = 2, LayoutOrder = 1, Parent = texts,
    }, "Bold")
    newText("TextLabel", {
        Size = UDim2.fromOffset(0, 16), AutomaticSize = Enum.AutomaticSize.X, Text = o.Content or "", TextSize = 13,
        TextColor3 = Color3.fromRGB(230, 230, 238), ZIndex = 2, LayoutOrder = 2, Parent = texts,
    }, "SemiBold")
    tween(wrap, 0.18, { Size = UDim2.fromOffset(340, 46) })
    tween(card, 0.2, { GroupTransparency = 0 })
    tween(sScale, 0.26, { Scale = 1 }, Enum.EasingStyle.Back)
    task.delay(dur, function()
        if not card.Parent then return end
        tween(card, 0.2, { GroupTransparency = 1 })
        tween(sScale, 0.2, { Scale = 0.85 })
        glowShow(glowImg, false, 0.2)
        task.wait(0.2)
        if wrap.Parent then
            tween(wrap, 0.15, { Size = UDim2.fromOffset(340, 0) })
            task.wait(0.16)
            self:UnbindGradient(sg)
            self:UnbindGradient(tg)
            wrap:Destroy()
        end
    end)
end

-- ───────────────────────────── ArrayList (port of ArrayListHud) ─────────────────────────────
local ROWH = 17

function Library:SetArrayList(state)
    self._arrayOn = state and true or false
    self:_refreshArrayList()
end

function Library:_arrayContainer()
    local frame = self._arrayFrame
    if frame and frame.Parent then return frame end
    frame = create("Frame", {
        Name = "ArrayList", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -4, 0, 4),
        Size = UDim2.new(0, 280, 1, -8), BackgroundTransparency = 1, Parent = self:_hudGui(),
    })
    self._arrayFrame = frame
    self._arrayRows = {}
    return frame
end

function Library:_newArrayRow(frame, m, text)
    local row = create("Frame", {
        Name = m.Name, AnchorPoint = Vector2.new(1, 0), Size = UDim2.fromOffset(0, ROWH),
        AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = frame,
    })
    local glowImg = makeGlow(row, { Spread = 9, Transparency = 0.3 })
    create("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(8, 8, 10), BackgroundTransparency = 0.22,
        BorderSizePixel = 0, ZIndex = 1, Parent = row,
    })
    local label = newText("TextLabel", {
        Size = UDim2.fromOffset(0, ROWH), AutomaticSize = Enum.AutomaticSize.X, Text = text, TextSize = 14,
        ZIndex = 2, Parent = row,
    }, "SemiBold")
    padding(label, 5, 0, 8, 0)
    local bar = create("Frame", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 2, 1, 0),
        BackgroundColor3 = P.White, BorderSizePixel = 0, ZIndex = 3, Parent = row,
    })
    return { frame = row, label = label, bar = bar, glow = glowImg, index = 0 }
end

function Library:_refreshArrayList()
    local frame = self:_arrayContainer()
    local rows = self._arrayRows
    frame.Visible = self._arrayOn == true
    local want, order = {}, {}
    if self._arrayOn then
        for _, m in ipairs(self.Modules) do
            if m.Enabled and m.Category
                and (not self.ArrayListHide[m.Category.Name] or m.Name == "HUD" or m.Name == "2D ESP") then
                local text = self.ArrayListLowercase and m.Name:lower() or m.Name
                local w = #text * 7
                pcall(function() w = TextService:GetTextSize(text, 14, Enum.Font.Montserrat, Vector2.new(1000, 100)).X end)
                want[m] = true
                order[#order + 1] = { m = m, text = text, w = w }
            end
        end
    end
    for m, r in pairs(rows) do
        if not want[m] then
            rows[m] = nil
            if self._arrayOn then
                tween(r.frame, 0.18, { Position = UDim2.new(1, 170, 0, r.frame.Position.Y.Offset) })
                task.delay(0.2, function() r.frame:Destroy() end)
            else
                r.frame:Destroy()
            end
        end
    end
    table.sort(order, function(a, b)
        if a.w ~= b.w then return a.w > b.w end
        return a.m.Name < b.m.Name
    end)
    local off = self.ArrayListOffset or 2
    for i, e in ipairs(order) do
        local r = rows[e.m]
        local y = off + (i - 1) * ROWH
        if not r then
            r = self:_newArrayRow(frame, e.m, e.text)
            rows[e.m] = r
            r.frame.Position = UDim2.new(1, 170, 0, y)
        end
        r.index = i
        if r.label.Text ~= e.text then r.label.Text = e.text end
        glowShow(r.glow, self.ArrayListGlow ~= false, 0.15)
        tween(r.frame, 0.2, { Position = UDim2.new(1, -off, 0, y) })
    end
    self:_refreshKeybinds()
end

-- text/bar colours run down the list (like ColorHelper.getColor(-y) in the original)
function Library:_tickArray()
    local rows = self._arrayRows
    if not rows then return end
    for _, r in pairs(rows) do
        local c = self:ColorAt(r.index * 0.07)
        r.label.TextColor3 = c
        r.bar.BackgroundColor3 = c
    end
end

-- ───────────────────────────── Watermark ─────────────────────────────
function Library:SetWatermark(state, text)
    self._wmOn = state and true or false
    if text then self._wmText = text end
    local hud = self:_hudGui()
    if not self._wm or not self._wm.Parent then
        local root = create("Frame", {
            Name = "Watermark", Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(0, 28),
            AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = hud,
        })
        makeGlow(root, { Spread = 16, Transparency = 0.3 })
        local card = create("Frame", {
            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = Color3.fromRGB(9, 9, 12),
            BackgroundTransparency = 0.08, BorderSizePixel = 0, ZIndex = 1, Parent = root,
        })
        corner(card, 8)
        local st = stroke(card, P.White, 1, 0.45)
        local sg = create("UIGradient", { Parent = st })
        self:BindGradient(sg, 0.8, true)
        local tint = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BackgroundTransparency = 0.88, BorderSizePixel = 0, ZIndex = 1, Parent = card })
        corner(tint, 8)
        local tg = create("UIGradient", { Parent = tint })
        self:BindGradient(tg, 0.8, true)
        self._wmLabel = newText("TextLabel", {
            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, TextSize = 13, RichText = true,
            ZIndex = 2, Parent = card,
        }, "SemiBold")
        padding(self._wmLabel, 10, 0, 10, 0)
        self._wm = root
        self:_registerWidget("Watermark", root, card)
    end
    self._wm.Visible = self._wmOn
    self:_updateWatermark()
end

function Library:_updateWatermark()
    if not (self._wm and self._wm.Parent and self._wmOn) then return end
    local title = tostring(self._wmText or ((self.Window and self.Window.Title) or "Celestial")):upper()
    local sep = ' <font color="#8d8d99">»</font> '
    local parts = {
        string.format('<font color="#%s">%s</font>', self:ColorAt(0):ToHex(), title),
        LocalPlayer and LocalPlayer.Name or "Player",
        "UID: " .. tostring(LocalPlayer and LocalPlayer.UserId or 0),
        os.date("%I:%M %p"),
    }
    self._wmLabel.Text = table.concat(parts, sep)
end

-- ───────────────────────────── Keybinds widget (HUD → "Бинды модулей") ─────────────────────────────
function Library:_keybindsWidget()
    if self._kbw and self._kbw.Frame.Parent then return self._kbw end
    self._kbw = self:CreateHudWidget({ Name = "Keybinds", Title = "Keybinds", Width = 150, Style = "pill", Position = UDim2.fromOffset(24, 260) })
    return self._kbw
end

function Library:_refreshKeybinds()
    local S = self.HudState
    if not (S.Enabled and S.ModuleBinds) then
        if self._kbw and self._kbw.Frame.Parent then self._kbw:SetShown(false) end
        return
    end
    local list = {}
    for _, m in ipairs(self.Modules) do
        if m.Enabled and m.Bind and m.Category then
            list[#list + 1] = { Text = m.Name, Right = "[" .. keyName(m.Bind) .. "]", Color = P.Text, RightColor = P.Text }
        end
    end
    local w = self:_keybindsWidget()
    w:SetEntries(list)
    w:SetShown(#list > 0 or self.Visible == true)
end

-- ───────────────────────────── Info (Coords / BPS / FPS / TPS, bottom-left) ─────────────────────────────
function Library:_infoWidget()
    if self._info and self._info.Parent then return self._info end
    local root = create("Frame", {
        Name = "Info", AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 6, 1, -6),
        Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, Parent = self:_hudGui(),
    })
    self._infoLabel = newText("TextLabel", {
        Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, TextSize = 14, RichText = true,
        TextYAlignment = Enum.TextYAlignment.Bottom, TextStrokeTransparency = 0.55, TextStrokeColor3 = Color3.new(0, 0, 0),
        Parent = root,
    }, "SemiBold")
    self._info = root
    self:_registerWidget("Info", root, root)
    return root
end

function Library:_tickInfo()
    local S = self.HudState
    local on = S.Enabled and (S.Coords or S.Fps or S.Bps or S.Tps)
    if not on then
        if self._info and self._info.Parent then self._info.Visible = false end
        return
    end
    local root = self:_infoWidget()
    root.Visible = true
    local now = os.clock()
    if now - (self._infoT or 0) < 0.12 then return end
    self._infoT = now
    local lines = {}
    local function add(i, label, value)
        lines[#lines + 1] = string.format('<font color="#%s">%s</font> <font color="#a8a8b3">%s</font>',
            self:ColorAt(i * 0.07):ToHex(), label, value)
    end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    -- original draws Coords at the bottom and goes upwards: top→bottom is TPS, FPS, BPS, Coords
    if S.Tps then
        local tps = 20
        pcall(function() tps = math.clamp(workspace:GetRealPhysicsFPS() / 60 * 20, 0, 20) end)
        add(3, "TPS:", string.format("%.1f", tps))
    end
    if S.Fps then add(2, "FPS:", tostring(self.FPS or 60)) end
    if S.Bps then
        local v = hrp and hrp.AssemblyLinearVelocity or Vector3.zero
        add(1, "BPS:", string.format("%.2f", Vector3.new(v.X, 0, v.Z).Magnitude / self.StudsPerBlock))
    end
    if S.Coords then
        local p = hrp and hrp.Position or Vector3.zero
        add(0, "Coords:", string.format("%d %d %d", p.X, p.Y, p.Z))
    end
    self._infoLabel.Text = table.concat(lines, "\n")
end

function Library:_applyHud()
    local S = self.HudState
    self:SetWatermark(S.Enabled and S.Watermark)
    self:_refreshKeybinds()
    self:_tickInfo()
end

-- ───────────────────────────── linking modules to the HUD ─────────────────────────────
local function findSettingIn(m, name, group)
    for _, st in ipairs(m.Settings) do
        if st.Name == name and (not group or (st.Parent and st.Parent.Name == group)) then return st end
    end
end

-- link the "HUD" module (groups Ватермарк / Бинды модулей / Информация ...) to the real HUD
function Library:LinkHud(m)
    local S = self.HudState
    local function bind(group, name, key)
        local st = findSettingIn(m, name, group)
        if not st then return end
        S[key] = st:Get()
        st:OnChanged(function(v) S[key] = v self:_applyHud() end, "hud_" .. key)
    end
    bind("Ватермарк", "Включено", "Watermark")
    bind("Бинды модулей", "Включено", "ModuleBinds")
    bind("Информация", "Координаты", "Coords")
    bind("Информация", "Фпс", "Fps")
    bind("Информация", "Бпс", "Bps")
    bind("Информация", "Тпс", "Tps")
    S.Enabled = m.Enabled
    m:OnToggle(function(on) S.Enabled = on self:_applyHud() end)
    self:_applyHud()
end

function Library:LinkArrayList(m)
    local cats = findSettingIn(m, "Категории")
    local function syncCats()
        local hide = {}
        for _, n in ipairs(cats.Options) do if not cats.Value[n] then hide[n] = true end end
        self.ArrayListHide = hide
        self:_refreshArrayList()
    end
    if cats then cats:OnChanged(syncCats, "arr") syncCats() end
    local low = findSettingIn(m, "Маленькие буквы")
    if low then
        self.ArrayListLowercase = low:Get()
        low:OnChanged(function(v) self.ArrayListLowercase = v self:_refreshArrayList() end, "arr")
    end
    local gl = findSettingIn(m, "Свечение")
    if gl then
        self.ArrayListGlow = gl:Get()
        gl:OnChanged(function(v) self.ArrayListGlow = v self:_refreshArrayList() end, "arr")
    end
    local off = findSettingIn(m, "Смещение")
    if off then
        self.ArrayListOffset = off:Get()
        off:OnChanged(function(v) self.ArrayListOffset = v self:_refreshArrayList() end, "arr")
    end
    m:OnToggle(function(on) self:SetArrayList(on) end)
    self:SetArrayList(m.Enabled)
end

function Library:LinkNotifications(m)
    local toggle = findSettingIn(m, "Включено", "Переключение модулей")
    local function recompute() self.NotifyOnToggle = m.Enabled and (not toggle or toggle:Get()) end
    if toggle then toggle:OnChanged(recompute, "ntf") end
    m:OnToggle(recompute)
    recompute()
    local snd = findSettingIn(m, "Воспроизводить звук")
    if snd then
        self.NotifySound = snd:Get()
        snd:OnChanged(function(v) self.NotifySound = v end, "ntf")
    end
    local pitch = findSettingIn(m, "Питч звука")
    if pitch then
        self.SoundPitch = pitch:Get()
        pitch:OnChanged(function(v) self.SoundPitch = v end, "ntf")
    end
end

-- show/hide a HUD widget together with a module (e.g. Staff Viewer)
function Library:LinkWidget(m, widget)
    m:OnToggle(function(on) widget:SetShown(on) end)
    widget:SetShown(m.Enabled)
end

function Library:_registerWidget(name, root, handle)
    self._widgets = self._widgets or {}
    self._widgets[name] = root
    root.Destroying:Connect(function()
        if self._widgets and self._widgets[name] == root then self._widgets[name] = nil end
    end)
    self:MakeDraggable(handle or root, root, function() return Library.Visible end)
end

-- HudWidget (port of core HudWidget): draggable (while the menu is open) panel with title + rows
function Library:CreateHudWidget(o)
    o = o or {}
    local name = o.Name or "Widget"
    local hud = self:_hudGui()
    local root = create("Frame", {
        Name = name, Position = o.Position or UDim2.fromOffset(20, 220), Size = UDim2.fromOffset(o.Width or 170, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = hud,
    })
    local glowImg = makeGlow(root, { Spread = 26, Transparency = 0.4 })
    local card = create("CanvasGroup", {
        Name = "Card", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(11, 11, 14), BackgroundTransparency = 0.05, BorderSizePixel = 0,
        ZIndex = 1, Parent = root,
    })
    corner(card, 10)
    stroke(card, P.Stroke, 1, 0.45)
    listLayout(card, 0)
    local titleLabel
    local head
    if o.Style == "pill" then
        head = create("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 0, Parent = card })
        padding(head, 4, 4, 4, 0)
        local fillH = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = head })
        corner(fillH, 8)
        local hg = create("UIGradient", { Rotation = 0, Parent = fillH })
        self:BindGradient(hg, 0.8, true)
        titleLabel = newText("TextLabel", {
            Size = UDim2.fromScale(1, 1), Text = o.Title or name, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Center,
            Parent = fillH,
        }, "Bold")
    else
        head = create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = 0, Parent = card })
        titleLabel = newText("TextLabel", {
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0), Text = o.Title or name, TextSize = 12,
            Parent = head,
        }, "Bold")
        local line = create("Frame", {
            AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, 0), Size = UDim2.new(1, -16, 0, 2),
            BackgroundColor3 = P.White, BorderSizePixel = 0, Parent = head,
        })
        corner(line, 1)
        local lg = create("UIGradient", { Parent = line })
        self:BindGradient(lg, 0.8, true)
    end
    local body = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, Parent = card,
    })
    listLayout(body, 2)
    padding(body, 10, 6, 10, 8)

    local w = { Frame = root, Card = card, Body = body, Name = name, Shown = true }
    function w:SetEntries(list)
        for _, c in ipairs(body:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        if #list == 0 and o.EmptyText then list = { { Text = o.EmptyText, Color = P.Dim } } end
        for i, e in ipairs(list) do
            local row = create("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = i, Parent = body })
            newText("TextLabel", {
                Size = UDim2.new(1, e.Right and -66 or 0, 1, 0), Text = tostring(e.Text), TextSize = 12,
                TextColor3 = e.Color or P.Text, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
            }, "Medium")
            if e.Right then
                newText("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 64, 1, 0),
                    Text = tostring(e.Right), TextSize = 11, TextColor3 = e.RightColor or P.Sub,
                    TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
                }, "SemiBold")
            end
        end
    end
    function w:SetTitle(t) titleLabel.Text = t end
    function w:SetShown(state)
        self.Shown = state and true or false
        tween(card, 0.18, { GroupTransparency = state and 0 or 1 })
        glowShow(glowImg, state, 0.18)
        if state then root.Visible = true else task.delay(0.2, function() if not self.Shown then root.Visible = false end end) end
    end
    function w:Destroy() self:SetShown(false) root:Destroy() end
    self:_registerWidget(name, root, card)
    return w
end

local function lerpColor(a, b, t) return a:Lerp(b, t) end

function Library:GetTargetHud()
    if self._target and self._target.Frame.Parent then return self._target end
    local hud = self:_hudGui()
    local root = create("Frame", {
        Name = "TargetHud", Position = UDim2.new(0.5, 40, 0.5, 40), Size = UDim2.fromOffset(236, 66),
        BackgroundTransparency = 1, Visible = false, Parent = hud,
    })
    local scale = create("UIScale", { Scale = 0.92, Parent = root })
    local glowImg = makeGlow(root, { Spread = 28, Transparency = 0.35 })
    local card = create("CanvasGroup", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(11, 11, 14), BackgroundTransparency = 0.04,
        BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 1, Parent = root,
    })
    corner(card, 12)
    stroke(card, P.Stroke, 1, 0.4)
    local face = create("ImageLabel", {
        Position = UDim2.fromOffset(10, 11), Size = UDim2.fromOffset(44, 44), BackgroundColor3 = P.Panel,
        BorderSizePixel = 0, Parent = card,
    })
    corner(face, 10)
    local nameL = newText("TextLabel", {
        Position = UDim2.fromOffset(64, 8), Size = UDim2.new(1, -118, 0, 18), TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = card,
    }, "Bold")
    local hpR = newText("TextLabel", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 8), Size = UDim2.fromOffset(46, 18),
        TextSize = 12, TextColor3 = P.Sub, TextXAlignment = Enum.TextXAlignment.Right, Parent = card,
    }, "SemiBold")
    local track = create("Frame", {
        Position = UDim2.fromOffset(64, 33), Size = UDim2.new(1, -74, 0, 8), BackgroundColor3 = P.Off,
        BorderSizePixel = 0, Parent = card,
    })
    corner(track, 4)
    local trail = create("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BackgroundTransparency = 0.55, BorderSizePixel = 0, Parent = track,
    })
    corner(trail, 4)
    local fill = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = P.White, BorderSizePixel = 0, ZIndex = 2, Parent = track })
    corner(fill, 4)
    local g = create("UIGradient", { Parent = fill })
    self:BindGradient(g, 0.6, true)
    local sub = newText("TextLabel", {
        Position = UDim2.fromOffset(64, 44), Size = UDim2.new(1, -74, 0, 14), TextSize = 10, TextColor3 = P.Dim, Parent = card,
    }, "Medium")

    local obj = { Frame = root, HideAfter = 3, _last = 0, _shown = false, _uid = nil }
    local hpAnim = Library.NewAnim(1, 14, function(v) fill.Size = UDim2.fromScale(v, 1) end)
    local trailAnim = Library.NewAnim(1, 3.2, function(v) trail.Size = UDim2.fromScale(v, 1) end)
    obj._anims = { hpAnim, trailAnim }

    function obj:Update(name, health, maxHealth, userId, preview)
        maxHealth = maxHealth or 20
        health = math.clamp(health or 0, 0, maxHealth)
        local frac = maxHealth > 0 and health / maxHealth or 0
        nameL.Text = tostring(name or "Target")
        hpR.Text = string.format("%.1f", health)
        sub.Text = string.format("HP %d / %d", math.floor(health + 0.5), math.floor(maxHealth + 0.5))
        hpAnim:Set(frac)
        if frac > trailAnim.Value then trailAnim:Set(frac, true) else trailAnim:Set(frac) end
        if userId and userId ~= self._uid then
            self._uid = userId
            pcall(function() face.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150" end)
        end
        self._last = os.clock()
        self._preview = preview == true
        if not self._shown then
            self._shown = true
            root.Visible = true
            tween(card, 0.18, { GroupTransparency = 0 })
            tween(scale, 0.22, { Scale = 1 }, Enum.EasingStyle.Back)
            glowShow(glowImg, true, 0.2)
        end
    end
    function obj:Hide()
        if not self._shown then return end
        self._shown = false
        self._preview = false
        tween(card, 0.16, { GroupTransparency = 1 })
        tween(scale, 0.16, { Scale = 0.92 })
        glowShow(glowImg, false, 0.16)
        task.delay(0.18, function() if not self._shown then root.Visible = false end end)
    end
    obj._tick = function()
        if obj._shown and not Library.Visible and os.clock() - obj._last > obj.HideAfter then obj:Hide() end
    end
    self._target = obj
    self:_registerWidget("TargetHud", root, card)
    return obj
end

-- shows a preview of the target hud while the menu is open so it can be dragged
function Library:_hudPreview(state)
    self:_refreshKeybinds()
    local t = self._target
    if not (t and t.Frame.Parent) then return end
    if state then
        if not t._shown then t:Update(LocalPlayer.Name, 20, 20, LocalPlayer.UserId, true) end
    elseif t._preview then
        t:Hide()
    end
end


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
    data.Hud = {}
    for name, root in pairs(self._widgets or {}) do
        local p = root.Position
        data.Hud[name] = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
    end
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
        for name, p in pairs(data.Hud or {}) do
            local root = self._widgets and self._widgets[name]
            if root and type(p) == "table" then root.Position = UDim2.new(p[1] or 0, p[2] or 0, p[3] or 0, p[4] or 0) end
        end
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


function Library:_start()
    if self._started then return end
    self._started = true
    local acc, fpsAcc, frames = 0, 0, 0
    self:Connect(RunService.Heartbeat, function(dt)
        self._time = self._time + dt
        self:_stepAnims(dt)
        if self._target and self._target._tick then self._target._tick() end
        acc = acc + dt
        if acc >= 1 / 40 then
            acc = 0
            if self.Visible then self:_updateSet(self._grads) end
            if next(self._hudGrads) then self:_updateSet(self._hudGrads) end
            self:_tickArray()
            self:_tickInfo()
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
    self._widgets, self._target = {}, nil
    self._started, self._listening = false, nil
    if genv.CelestialLibrary == self then genv.CelestialLibrary = nil end
end

return Library

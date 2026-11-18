-- ============================================================
-- RedzLibrary.lua  |  Versão Mobile-Fixed
-- Compatível com PC e Celular (Delta, Codex, Arceus X, etc.)
-- ============================================================

local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local HttpService        = game:GetService("HttpService")
local RunService         = game:GetService("RunService")
local CoreGui            = game:GetService("CoreGui")
local Players            = game:GetService("Players")
local Player             = Players.LocalPlayer
local PlayerMouse        = Player:GetMouse()

-- ============================================================
-- [MOBILE FIX 1] Detecta mobile e escolhe parent do ScreenGui
-- ============================================================
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local GuiParent = CoreGui
do
    local ok = pcall(function()
        local test = Instance.new("ScreenGui")
        test.Parent = CoreGui
        test:Destroy()
    end)
    if not ok then
        GuiParent = Player:WaitForChild("PlayerGui")
    end
end

local redzlib = {
    Themes = {
        Darker = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"]  = Color3.fromRGB(88, 101, 242),
            ["Color Text"]   = Color3.fromRGB(243, 243, 243),
            ["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
        },
        Dark = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 40, 40)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(47.5, 47.5, 47.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40))
            }),
            ["Color Hub 2"] = Color3.fromRGB(45, 45, 45),
            ["Color Stroke"] = Color3.fromRGB(65, 65, 65),
            ["Color Theme"]  = Color3.fromRGB(65, 150, 255),
            ["Color Text"]   = Color3.fromRGB(245, 245, 245),
            ["Color Dark Text"] = Color3.fromRGB(190, 190, 190)
        },
        Purple = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(27.5, 25, 30)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(27.5, 25, 30))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"]  = Color3.fromRGB(150, 0, 255),
            ["Color Text"]   = Color3.fromRGB(240, 240, 240),
            ["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
        }
    },
    Info = { Version = "1.1.0-mobile" },
    Save = {
        UISize  = {550, 380},
        TabSize = 160,
        Theme   = "Darker"
    },
    Settings   = {},
    Connection = {},
    Instances  = {},
    Elements   = {},
    Options    = {},
    Flags      = {},
    Tabs       = {},
    Icons      = {}   -- [MOBILE FIX] preenchido depois
}

-- ============================================================
-- [MOBILE FIX 2] Tabela de ícones — copie a original aqui
-- Mantenha exatamente como no seu arquivo original.
-- Para economizar espaço, coloquei apenas os essenciais.
-- Se quiser TODOS, cole a lista original dentro desta tabela.
-- ============================================================
redzlib.Icons = (function()
    return {
        ["accessibility"] = "rbxassetid://10709751939",
        ["activity"]      = "rbxassetid://10709752035",
        ["airvent"]       = "rbxassetid://10709752131",
        ["alarmcheck"]    = "rbxassetid://10709752405",
        ["alarmclock"]    = "rbxassetid://10709752630",
        ["album"]         = "rbxassetid://10709752906",
        ["alertcircle"]   = "rbxassetid://10709752996",
        ["alertoctagon"]  = "rbxassetid://10709753064",
        ["alerttriangle"] = "rbxassetid://10709753149",
        ["anchor"]        = "rbxassetid://10709761530",
        ["archive"]       = "rbxassetid://10709762233",
        ["arrowdown"]     = "rbxassetid://10709767827",
        ["arrowleft"]     = "rbxassetid://10709768114",
        ["arrowright"]    = "rbxassetid://10709768347",
        ["arrowup"]       = "rbxassetid://10709768939",
        ["award"]         = "rbxassetid://10709769406",
        ["backpack"]      = "rbxassetid://10709769841",
        ["barchart"]      = "rbxassetid://10709773755",
        ["battery"]       = "rbxassetid://10709774640",
        ["bell"]          = "rbxassetid://10709775704",
        ["bike"]          = "rbxassetid://10709775894",
        ["book"]          = "rbxassetid://10709781824",
        ["bookmark"]      = "rbxassetid://10709782154",
        ["box"]           = "rbxassetid://10709782497",
        ["briefcase"]     = "rbxassetid://10709782662",
        ["brush"]         = "rbxassetid://10709782758",
        ["bug"]           = "rbxassetid://10709782845",
        ["building"]      = "rbxassetid://10709783051",
        ["calendar"]      = "rbxassetid://10709789505",
        ["camera"]        = "rbxassetid://10709789686",
        ["car"]           = "rbxassetid://10709789810",
        ["check"]         = "rbxassetid://10709790644",
        ["checkcircle"]   = "rbxassetid://10709790387",
        ["chevrondown"]   = "rbxassetid://10709790948",
        ["chevronleft"]   = "rbxassetid://10709791281",
        ["chevronright"]  = "rbxassetid://10709791437",
        ["chevronup"]     = "rbxassetid://10709791523",
        ["circle"]        = "rbxassetid://10709798174",
        ["clock"]         = "rbxassetid://10709805144",
        ["cloud"]         = "rbxassetid://10709806740",
        ["code"]          = "rbxassetid://10709810463",
        ["cog"]           = "rbxassetid://10709810948",
        ["coins"]         = "rbxassetid://10709811110",
        ["compass"]       = "rbxassetid://10709811445",
        ["copy"]          = "rbxassetid://10709812159",
        ["crown"]         = "rbxassetid://10709818626",
        ["database"]      = "rbxassetid://10709818996",
        ["delete"]        = "rbxassetid://10709819059",
        ["diamond"]       = "rbxassetid://10709819149",
        ["download"]      = "rbxassetid://10723344270",
        ["edit"]          = "rbxassetid://10734883598",
        ["eye"]           = "rbxassetid://10723346959",
        ["eyeoff"]        = "rbxassetid://10723346871",
        ["file"]          = "rbxassetid://10723374641",
        ["filter"]        = "rbxassetid://10723375128",
        ["flag"]          = "rbxassetid://10723375890",
        ["flame"]         = "rbxassetid://10723376114",
        ["folder"]        = "rbxassetid://10723387563",
        ["gamepad"]       = "rbxassetid://10723395457",
        ["gift"]          = "rbxassetid://10723396402",
        ["globe"]         = "rbxassetid://10723404337",
        ["grid"]          = "rbxassetid://10723404936",
        ["hammer"]        = "rbxassetid://10723405360",
        ["heart"]         = "rbxassetid://10723406885",
        ["helpcircle"]    = "rbxassetid://10723406988",
        ["home"]          = "rbxassetid://10723407389",
        ["image"]         = "rbxassetid://10723415040",
        ["info"]          = "rbxassetid://10723415903",
        ["key"]           = "rbxassetid://10723416652",
        ["layers"]        = "rbxassetid://10723424505",
        ["layout"]        = "rbxassetid://10723425376",
        ["link"]          = "rbxassetid://10723426722",
        ["list"]          = "rbxassetid://10723433811",
        ["lock"]          = "rbxassetid://10723434711",
        ["mail"]          = "rbxassetid://10734885430",
        ["map"]           = "rbxassetid://10734886202",
        ["menu"]          = "rbxassetid://10734887784",
        ["messagecircle"] = "rbxassetid://10734888000",
        ["mic"]           = "rbxassetid://10734888864",
        ["minus"]         = "rbxassetid://10734896206",
        ["monitor"]       = "rbxassetid://10734896881",
        ["moon"]          = "rbxassetid://10734897102",
        ["music"]         = "rbxassetid://10734905958",
        ["package"]       = "rbxassetid://10734909540",
        ["pause"]         = "rbxassetid://10734919336",
        ["pencil"]        = "rbxassetid://10734919691",
        ["phone"]         = "rbxassetid://10734921524",
        ["play"]          = "rbxassetid://10734923549",
        ["plus"]          = "rbxassetid://10734924532",
        ["power"]         = "rbxassetid://10734930466",
        ["refreshcw"]     = "rbxassetid://10734933222",
        ["rocket"]        = "rbxassetid://10734934585",
        ["save"]          = "rbxassetid://10734941499",
        ["search"]        = "rbxassetid://10734943674",
        ["send"]          = "rbxassetid://10734943902",
        ["settings"]      = "rbxassetid://10734950309",
        ["share"]         = "rbxassetid://10734950813",
        ["shield"]        = "rbxassetid://10734951847",
        ["shoppingcart"]  = "rbxassetid://10734952479",
        ["skull"]         = "rbxassetid://10734962068",
        ["star"]          = "rbxassetid://10734966248",
        ["sun"]           = "rbxassetid://10734974297",
        ["sword"]         = "rbxassetid://10734975486",
        ["tag"]           = "rbxassetid://10734976528",
        ["target"]        = "rbxassetid://10734977012",
        ["timer"]         = "rbxassetid://10734984606",
        ["trash"]         = "rbxassetid://10747362393",
        ["trophy"]        = "rbxassetid://10747363809",
        ["user"]          = "rbxassetid://10747373176",
        ["users"]         = "rbxassetid://10747373426",
        ["video"]         = "rbxassetid://10747374938",
        ["volume"]        = "rbxassetid://10747376008",
        ["wallet"]        = "rbxassetid://10747376205",
        ["wifi"]          = "rbxassetid://10747382504",
        ["wrench"]        = "rbxassetid://10747383470",
        ["x"]             = "rbxassetid://10747384394",
        ["zoomin"]        = "rbxassetid://10747384552",
        ["zoomout"]       = "rbxassetid://10747384679"
    }
end)()

-- ============================================================
-- [MOBILE FIX 3] Escala dinâmica e responsiva
-- ============================================================
local ViewportSize = workspace.CurrentCamera.ViewportSize
local function CalcScale()
    local base = IsMobile and 320 or 450
    return math.clamp(ViewportSize.Y / base, 0.5, 2)
end
local UIScale = CalcScale()

local Settings = redzlib.Settings
local Flags    = redzlib.Flags

-- ============================================================
-- Helpers (substituindo table.foreach por pairs)
-- ============================================================
local SetProps, SetChildren, InsertTheme, Create do
    InsertTheme = function(Instance, Type)
        table.insert(redzlib.Instances, { Instance = Instance, Type = Type })
        return Instance
    end

    SetChildren = function(Instance, Children)
        if Children then
            for _, Child in pairs(Children) do
                Child.Parent = Instance
            end
        end
        return Instance
    end

    SetProps = function(Instance, Props)
        if Props then
            for prop, value in pairs(Props) do
                Instance[prop] = value
            end
        end
        return Instance
    end

    Create = function(...)
        local args = {...}
        if type(args) ~= "table" then return end
        local new = Instance.new(args[1])
        if type(args[2]) == "table" then
            SetProps(new, args[2])
            SetChildren(new, args[3])
        elseif typeof(args[2]) == "Instance" then
            new.Parent = args[2]
            SetProps(new, args[3])
            SetChildren(new, args[4])
        end
        return new
    end

    local function Save(file)
        if readfile and isfile and isfile(file) then
            local ok, decode = pcall(function()
                return HttpService:JSONDecode(readfile(file))
            end)
            if ok and type(decode) == "table" then
                if rawget(decode, "UISize")  then redzlib.Save["UISize"]  = decode["UISize"]  end
                if rawget(decode, "TabSize") then redzlib.Save["TabSize"] = decode["TabSize"] end
                if rawget(decode, "Theme")   then redzlib.Save["Theme"]   = decode["Theme"]   end
            end
        end
    end
    pcall(Save, "redz library V5.json")
end

-- ============================================================
-- Funcs / Connections
-- ============================================================
local Funcs = {} do
    function Funcs:InsertCallback(tab, func)
        if type(func) == "function" then table.insert(tab, func) end
        return func
    end
    function Funcs:FireCallback(tab, ...)
        for _, v in ipairs(tab) do
            if type(v) == "function" then task.spawn(v, ...) end
        end
    end
    function Funcs:GetConnectionFunctions(ConnectedFuncs, func)
        local Connected = { Function = func, Connected = true }
        function Connected:Disconnect()
            if self.Connected then
                table.remove(ConnectedFuncs, table.find(ConnectedFuncs, self.Function))
                self.Connected = false
            end
        end
        function Connected:Fire(...)
            if self.Connected then task.spawn(self.Function, ...) end
        end
        return Connected
    end
end

local Connections, Connection = {}, redzlib.Connection do
    local function NewConnectionList(List)
        if type(List) ~= "table" then return end
        for _, CoName in ipairs(List) do
            local ConnectedFuncs, Connect = {}, {}
            Connection[CoName] = Connect
            Connections[CoName] = ConnectedFuncs
            Connect.Name = CoName
            function Connect:Connect(func)
                if type(func) == "function" then
                    table.insert(ConnectedFuncs, func)
                    return Funcs:GetConnectionFunctions(ConnectedFuncs, func)
                end
            end
            function Connect:Once(func)
                if type(func) == "function" then
                    local Connected
                    local function _NFunc(...)
                        task.spawn(func, ...)
                        Connected:Disconnect()
                    end
                    Connected = Funcs:GetConnectionFunctions(ConnectedFuncs, _NFunc)
                    return Connected
                end
            end
        end
    end
    function Connection:FireConnection(CoName, ...)
        local Conn = type(CoName) == "string" and Connections[CoName] or Connections[CoName.Name]
        for _, Func in pairs(Conn) do task.spawn(Func, ...) end
    end
    NewConnectionList({"FlagsChanged", "ThemeChanged", "FileSaved", "ThemeChanging", "OptionAdded"})
end

local GetFlag, SetFlag, CheckFlag do
    CheckFlag = function(Name) return type(Name) == "string" and Flags[Name] ~= nil end
    GetFlag   = function(Name) return type(Name) == "string" and Flags[Name] end
    SetFlag   = function(Flag, Value)
        if Flag and (Value ~= Flags[Flag] or type(Value) == "table") then
            Flags[Flag] = Value
            Connection:FireConnection("FlagsChanged", Flag, Value)
        end
    end
end

-- ============================================================
-- [MOBILE FIX 4] ScreenGui compatível
-- ============================================================
local ScreenGui = Create("ScreenGui", GuiParent, {
    Name = "redz Library V5",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, {
    Create("UIScale", { Scale = UIScale, Name = "Scale" })
})

local ScreenFind = GuiParent:FindFirstChild(ScreenGui.Name)
if ScreenFind and ScreenFind ~= ScreenGui then
    ScreenFind:Destroy()
end

-- ============================================================
-- Helpers de UI
-- ============================================================
local function GetStr(val)
    if type(val) == "function" then return val() end
    return val
end

-- [MOBILE FIX 5] ConnectSave com toque
local function ConnectSave(Instance, func)
    Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    func()
                end
            end)
        end
    end)
end

local function CreateTween(Configs)
    local Instance = Configs[1] or Configs.Instance
    local Prop     = Configs[2] or Configs.Prop
    local NewVal   = Configs[3] or Configs.NewVal
    local Time     = Configs[4] or Configs.Time or 0.5
    local TweenWait= Configs[5] or Configs.wait or false
    local TweenInfo= TweenInfo.new(Time, Enum.EasingStyle.Quint)
    local Tween    = TweenService:Create(Instance, TweenInfo, {[Prop] = NewVal})
    Tween:Play()
    if TweenWait then Tween.Completed:Wait() end
    return Tween
end

-- [MOBILE FIX 6] Drag unificado PC + Mobile
local function MakeDrag(Instance)
    task.spawn(function()
        SetProps(Instance, { Active = true, AutoButtonColor = false })
        local DragStart, StartPos, Dragging = nil, nil, false

        local function Update(Input)
            local delta = Input.Position - DragStart
            local Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + delta.X / UIScale,
                StartPos.Y.Scale,
                StartPos.Y.Offset + delta.Y / UIScale
            )
            CreateTween({Instance, "Position", Position, 0.15})
        end

        Instance.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1
                or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging   = true
                StartPos   = Instance.Position
                DragStart  = Input.Position
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        Instance.InputChanged:Connect(function(Input)
            if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement
                or Input.UserInputType == Enum.UserInputType.Touch) then
                Update(Input)
            end
        end)
    end)
    return Instance
end

-- ============================================================
-- VerifyTheme / SaveJson / Theme
-- ============================================================
local function VerifyTheme(ThemeName)
    for name in pairs(redzlib.Themes) do
        if name == ThemeName then return true end
    end
end

local function SaveJson(FileName, save)
    if writefile then
        local ok, json = pcall(function() return HttpService:JSONEncode(save) end)
        if ok then pcall(writefile, FileName, json) end
    end
end

local Theme = redzlib.Themes[redzlib.Save.Theme] or redzlib.Themes["Darker"]

local function AddEle(Name, Func) redzlib.Elements[Name] = Func end
local function Make(Ele, Instance, props, ...)
    return redzlib.Elements[Ele](Instance, props, ...)
end

-- ============================================================
-- Elementos básicos
-- ============================================================
AddEle("Corner", function(parent, CornerRadius)
    return SetProps(Create("UICorner", parent, { CornerRadius = CornerRadius or UDim.new(0, 7) }), props)
end)

AddEle("Stroke", function(parent, props, ...)
    local args = {...}
    return InsertTheme(SetProps(Create("UIStroke", parent, {
        Color = args[1] or Theme["Color Stroke"],
        Thickness = args[2] or 1,
        ApplyStrokeMode = "Border"
    }), props), "Stroke")
end)

AddEle("Button", function(parent, props, ...)
    local args = {...}
    local New = InsertTheme(SetProps(Create("TextButton", parent, {
        Text = "",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme["Color Hub 2"],
        AutoButtonColor = false
    }), props), "Frame")
    New.MouseEnter:Connect(function() New.BackgroundTransparency = 0.4 end)
    New.MouseLeave:Connect(function() New.BackgroundTransparency = 0 end)
    if args[1] then New.Activated:Connect(args[1]) end
    return New
end)

AddEle("Gradient", function(parent, props, ...)
    local args = {...}
    return InsertTheme(SetProps(Create("UIGradient", parent, {
        Color = Theme["Color Hub 1"]
    }), props), "Gradient")
end)

-- ============================================================
-- GetColor / GetIcon
-- ============================================================
local function GetColor(Instance)
    if Instance:IsA("Frame")          then return "BackgroundColor3"
    elseif Instance:IsA("ImageLabel") then return "ImageColor3"
    elseif Instance:IsA("TextLabel")  then return "TextColor3"
    elseif Instance:IsA("ScrollingFrame") then return "ScrollBarImageColor3"
    elseif Instance:IsA("UIStroke")   then return "Color"
    end
    return ""
end

function redzlib:GetIcon(index)
    if type(index) ~= "string" or index:find("rbxassetid://") or #index == 0 then
        return index
    end
    local firstMatch = nil
    index = string.lower(index):gsub("lucide", ""):gsub("-", "")
    if self.Icons[index] then return self.Icons[index] end
    for Name, Icon in pairs(self.Icons) do
        if Name == index then
            return Icon
        elseif not firstMatch and Name:find(index, 1, true) then
            firstMatch = Icon
        end
    end
    return firstMatch or index
end

-- ============================================================
-- SetTheme / SetScale
-- ============================================================
function redzlib:SetTheme(NewTheme)
    if not VerifyTheme(NewTheme) then return end
    redzlib.Save.Theme = NewTheme
    SaveJson("redz library V5.json", redzlib.Save)
    Theme = redzlib.Themes[NewTheme]
    Connection:FireConnection("ThemeChanged", NewTheme)
    for _, Val in pairs(redzlib.Instances) do
        local t = Val.Type
        if t == "Gradient" then Val.Instance.Color = Theme["Color Hub 1"]
        elseif t == "Frame" then Val.Instance.BackgroundColor3 = Theme["Color Hub 2"]
        elseif t == "Stroke" then Val.Instance[GetColor(Val.Instance)] = Theme["Color Stroke"]
        elseif t == "Theme" then Val.Instance[GetColor(Val.Instance)] = Theme["Color Theme"]
        elseif t == "Text" then Val.Instance[GetColor(Val.Instance)] = Theme["Color Text"]
        elseif t == "DarkText" then Val.Instance[GetColor(Val.Instance)] = Theme["Color Dark Text"]
        elseif t == "ScrollBar" then Val.Instance[GetColor(Val.Instance)] = Theme["Color Theme"]
        end
    end
end

function redzlib:SetScale(NewScale)
    NewScale = ViewportSize.Y / math.clamp(NewScale, 300, 2000)
    UIScale = NewScale
    if ScreenGui and ScreenGui:FindFirstChild("Scale") then
        ScreenGui.Scale.Scale = NewScale
    end
end

-- ============================================================
-- MakeWindow (versão corrigida para mobile)
-- ============================================================
function redzlib:MakeWindow(Configs)
    local WTitle    = Configs[1] or Configs.Name or Configs.Title or "redz Library V5"
    local WMiniText = Configs[2] or Configs.SubTitle or "by : redz9999"
    Settings.ScriptFile = Configs[3] or Configs.SaveFolder or false

    local function LoadFile()
        local File = Settings.ScriptFile
        if type(File) ~= "string" then return end
        if not readfile or not isfile then return end
        local s, r = pcall(isfile, File)
        if s and r then
            local ok, str = pcall(readfile, File)
            if ok and type(str) == "string" then
                local ok2, res = pcall(function() return HttpService:JSONDecode(str) end)
                if ok2 and type(res) == "table" then Flags = res end
            end
        end
    end
    LoadFile()

    -- [MOBILE FIX 7] tamanho inicial adaptado
    local UISizeX, UISizeY = unpack(redzlib.Save.UISize)
    if IsMobile then
        UISizeX = math.min(UISizeX, math.floor(ViewportSize.X / UIScale) - 20)
        UISizeY = math.min(UISizeY, math.floor(ViewportSize.Y / UIScale) - 20)
    end

    local MainFrame = InsertTheme(Create("ImageButton", ScreenGui, {
        Size = UDim2.fromOffset(UISizeX, UISizeY),
        Position = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2),
        BackgroundTransparency = 0.03,
        Name = "Hub"
    }), "Main")
    Make("Gradient", MainFrame, { Rotation = 45 })
    MakeDrag(MainFrame)

    local MainCorner = Make("Corner", MainFrame)
    local Components = Create("Folder", MainFrame, { Name = "Components" })
    local DropdownHolder = Create("Folder", ScreenGui, { Name = "Dropdown" })

    local TopBar = Create("Frame", Components, {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Name = "Top Bar"
    })

    local Title = InsertTheme(Create("TextLabel", TopBar, {
        Position = UDim2.new(0, 15, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        AutomaticSize = "XY",
        Text = WTitle,
        TextXAlignment = "Left",
        TextSize = 12,
        TextColor3 = Theme["Color Text"],
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Name = "Title"
    }, {
        InsertTheme(Create("TextLabel", {
            Size = UDim2.fromScale(0, 1),
            AutomaticSize = "X",
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(1, 5, 0.9),
            Text = WMiniText,
            TextColor3 = Theme["Color Dark Text"],
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            TextYAlignment = "Bottom",
            TextSize = 8,
            Font = Enum.Font.Gotham,
            Name = "SubTitle"
        }), "DarkText")
    }), "Text")

    local MainScroll = InsertTheme(Create("ScrollingFrame", Components, {
        Size = UDim2.new(0, redzlib.Save.TabSize, 1, -TopBar.Size.Y.Offset),
        ScrollBarImageColor3 = Theme["Color Theme"],
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        ScrollBarThickness = 1.5,
        BackgroundTransparency = 1,
        ScrollBarImageTransparency = 0.2,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
        BorderSizePixel = 0,
        Name = "Tab Scroll"
    }, {
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        }),
        Create("UIListLayout", { Padding = UDim.new(0, 5) })
    }), "ScrollBar")

    local Containers = Create("Frame", Components, {
        Size = UDim2.new(1, -MainScroll.Size.X.Offset, 1, -TopBar.Size.Y.Offset),
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Name = "Containers"
    })

    -- [MOBILE FIX 8] hitboxes maiores no mobile
    local hitbox   = IsMobile and 50 or 35
    local tabW     = IsMobile and 30 or 20
    local ControlSize1, ControlSize2 = MakeDrag(Create("ImageButton", MainFrame, {
        Size = UDim2.new(0, hitbox, 0, hitbox),
        Position = MainFrame.Size,
        Active = true,
        AnchorPoint = Vector2.new(0.8, 0.8),
        BackgroundTransparency = 1,
        Name = "Control Hub Size"
    })), MakeDrag(Create("ImageButton", MainFrame, {
        Size = UDim2.new(0, tabW, 1, -30),
        Position = UDim2.new(0, MainScroll.Size.X.Offset, 1, 0),
        AnchorPoint = Vector2.new(0.5, 1),
        Active = true,
        BackgroundTransparency = 1,
        Name = "Control Tab Size"
    }))

    -- [MOBILE FIX 9] limites adaptáveis
    local function ControlSize()
        local maxX = math.min(1000, ViewportSize.X / UIScale - 20)
        local maxY = math.min(500,  ViewportSize.Y / UIScale - 20)
        local minX = IsMobile and 300 or 430
        local minY = IsMobile and 180 or 200
        local minTab = IsMobile and 110 or 135

        local Pos1, Pos2 = ControlSize1.Position, ControlSize2.Position
        ControlSize1.Position = UDim2.fromOffset(
            math.clamp(Pos1.X.Offset, minX, maxX),
            math.clamp(Pos1.Y.Offset, minY, maxY)
        )
        ControlSize2.Position = UDim2.new(0, math.clamp(Pos2.X.Offset, minTab, 250), 1, 0)

        MainScroll.Size = UDim2.new(0, ControlSize2.Position.X.Offset, 1, -TopBar.Size.Y.Offset)
        Containers.Size = UDim2.new(1, -MainScroll.Size.X.Offset, 1, -TopBar.Size.Y.Offset)
        MainFrame.Size  = ControlSize1.Position
    end
    ControlSize1:GetPropertyChangedSignal("Position"):Connect(ControlSize)
    ControlSize2:GetPropertyChangedSignal("Position"):Connect(ControlSize)

    ConnectSave(ControlSize1, function()
        if not Minimized then
            redzlib.Save.UISize = {MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset}
            SaveJson("redz library V5.json", redzlib.Save)
        end
    end)
    ConnectSave(ControlSize2, function()
        redzlib.Save.TabSize = MainScroll.Size.X.Offset
        SaveJson("redz library V5.json", redzlib.Save)
    end)

    -- [MOBILE FIX 10] botões maiores no mobile
    local btnSize = IsMobile and 22 or 14
    local ButtonsFolder = Create("Folder", TopBar, { Name = "Buttons" })

    local CloseButton = Create("ImageButton", {
        Size = UDim2.new(0, btnSize, 0, btnSize),
        Position = UDim2.new(1, -10, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10747384394",
        AutoButtonColor = false,
        Name = "Close"
    })
    local MinimizeButton = SetProps(CloseButton:Clone(), {
        Position = UDim2.new(1, IsMobile and -50 or -35, 0.5),
        Image = "rbxassetid://10734896206",
        Name = "Minimize"
    })
    SetChildren(ButtonsFolder, { CloseButton, MinimizeButton })

    local Minimized, SaveSize, WaitClick
    local Window = {}

    function Window:CloseBtn()
        Window:Dialog({
            Title = "Close",
            Text  = "You Want Close Ui?",
            Options = {
                {"Confirm", function() ScreenGui:Destroy() end},
                {"Cancel"}
            }
        })
    end

    function Window:MinimizeBtn()
        if WaitClick then return end
        WaitClick = true
        if Minimized then
            MinimizeButton.Image = "rbxassetid://10734896206"
            CreateTween({MainFrame, "Size", SaveSize, 0.25, true})
            ControlSize1.Visible = true
            ControlSize2.Visible = true
            Minimized = false
        else
            MinimizeButton.Image = "rbxassetid://10734924532"
            SaveSize = MainFrame.Size
            ControlSize1.Visible = false
            ControlSize2.Visible = false
            CreateTween({MainFrame, "Size", UDim2.fromOffset(MainFrame.Size.X.Offset, 28), 0.25, true})
            Minimized = true
        end
        WaitClick = false
    end

    function Window:Minimize() MainFrame.Visible = not MainFrame.Visible end

    function Window:Set(Val1, Val2)
        if type(Val1) == "string" and type(Val2) == "string" then
            Title.Text = Val1
            Title.SubTitle.Text = Val2
        elseif type(Val1) == "string" then
            Title.Text = Val1
        end
    end

    function Window:Dialog(Configs)
        if MainFrame:FindFirstChild("Dialog") then return end
        if Minimized then Window:MinimizeBtn() end
        local DTitle   = Configs[1] or Configs.Title or "Dialog"
        local DText    = Configs[2] or Configs.Text or "This is a Dialog"
        local DOptions = Configs[3] or Configs.Options or {}

        local Frame = Create("Frame", {
            Active = true,
            Size   = UDim2.fromOffset(250 * 1.08, 150 * 1.08),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        }, {
            InsertTheme(Create("TextLabel", {
                Font = Enum.Font.GothamBold, Size = UDim2.new(1, 0, 0, 20),
                Text = DTitle, TextXAlignment = "Left",
                TextColor3 = Theme["Color Text"], TextSize = 15,
                Position = UDim2.fromOffset(15, 5), BackgroundTransparency = 1
            }), "Text"),
            InsertTheme(Create("TextLabel", {
                Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -25),
                AutomaticSize = "Y", Text = DText, TextXAlignment = "Left",
                TextColor3 = Theme["Color Dark Text"], TextSize = 12,
                Position = UDim2.fromOffset(15, 25), BackgroundTransparency = 1, TextWrapped = true
            }), "DarkText")
        })
        Make("Gradient", Frame, {Rotation = 270})
        Make("Corner", Frame)

        local ButtonsHolder = Create("Frame", Frame, {
            Size = UDim2.fromScale(1, 0.35),
            Position = UDim2.fromScale(0, 1),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = Theme["Color Hub 2"],
            BackgroundTransparency = 1
        }, {
            Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                VerticalAlignment = "Center",
                FillDirection = "Horizontal",
                HorizontalAlignment = "Center"
            })
        })

        local Screen = InsertTheme(Create("Frame", MainFrame, {
            BackgroundTransparency = 0.6, Active = true,
            BackgroundColor3 = Theme["Color Hub 2"],
            Size = UDim2.new(1, 0, 1, 0), Name = "Dialog"
        }), "Stroke")
        MainCorner:Clone().Parent = Screen
        Frame.Parent = Screen
        CreateTween({Frame, "Size", UDim2.fromOffset(250, 150), 0.2})
        CreateTween({Screen, "Transparency", 0.3, 0.15})

        local ButtonCount, Dialog = 1, {}
        function Dialog:Button(Cfg)
            local Name     = Cfg[1] or Cfg.Name or Cfg.Title or ""
            local Callback = Cfg[2] or Cfg.Callback or function() end
            ButtonCount = ButtonCount + 1
            local Button = Make("Button", ButtonsHolder)
            Make("Corner", Button)
            SetProps(Button, {
                Text = Name, Font = Enum.Font.GothamBold,
                TextColor3 = Theme["Color Text"], TextSize = 12
            })
            for _, B in pairs(ButtonsHolder:GetChildren()) do
                if B:IsA("TextButton") then
                    B.Size = UDim2.new(1/ButtonCount, -(((ButtonCount-1)*20)/ButtonCount), 0, 32)
                end
            end
            Button.Activated:Connect(Dialog.Close)
            Button.Activated:Connect(Callback)
        end
        function Dialog:Close()
            CreateTween({Frame, "Size", UDim2.fromOffset(250 * 1.08, 150 * 1.08), 0.2})
            CreateTween({Screen, "Transparency", 1, 0.15})
            CreateTween({Frame, "Transparency", 1, 0.15, true})
            Screen:Destroy()
        end
        for _, Button in pairs(DOptions) do
            Dialog:Button(Button)
        end
        return Dialog
    end

    function Window:SelectTab(TabSelect)
        if type(TabSelect) == "number" then
            redzlib.Tabs[TabSelect].func:Enable()
        else
            for _, Tab in pairs(redzlib.Tabs) do
                if Tab.Cont == TabSelect.Cont then Tab.func:Enable() end
            end
        end
    end

    -- ============================================================
    -- MakeTab (com correções mobile)
    -- ============================================================
    function Window:MakeTab(paste, Configs)
        if type(paste) == "table" then Configs = paste end
        local TName = Configs[1] or Configs.Title or "Tab!"
        local TIcon = Configs[2] or Configs.Icon or ""
        TIcon = redzlib:GetIcon(TIcon)
        if not TIcon:find("rbxassetid://") or TIcon:gsub("rbxassetid://", ""):len() < 6 then
            TIcon = false
        end

        local TabSelect = Make("Button", MainScroll, { Size = UDim2.new(1, 0, 0, 24) })
        Make("Corner", TabSelect)

        local LabelTitle = InsertTheme(Create("TextLabel", TabSelect, {
            Size = UDim2.new(1, TIcon and -25 or -15, 1),
            Position = UDim2.fromOffset(TIcon and 25 or 15),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Text = TName, TextColor3 = Theme["Color Text"],
            TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = (FirstTab and 0.3) or 0, TextTruncate = "AtEnd"
        }), "Text")

        if TIcon then
            InsertTheme(Create("ImageLabel", TabSelect, {
                Position = UDim2.new(0, 8, 0.5),
                Size = UDim2.new(0, 13, 0, 13),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = TIcon, BackgroundTransparency = 1,
                ImageTransparency = (FirstTab and 0.3) or 0
            }), "Text")
        end

        -- Container da tab
        local TabContainer = Create("ScrollingFrame", Containers, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 1.5,
            ScrollBarImageColor3 = Theme["Color Theme"],
            ScrollBarImageTransparency = 0.2,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = "Y",
            ScrollingDirection = "Y",
            Visible = false
        }, {
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            }),
            Create("UIListLayout", { Padding = UDim.new(0, 5) })
        })

        local Tab = { Cont = TabContainer, TButton = TabSelect, func = {} }

        function Tab.func:Enable()
            for _, otherTab in pairs(redzlib.Tabs) do
                if otherTab.Cont then
                    otherTab.Cont.Visible = false
                    otherTab.TButton.BackgroundTransparency = 1
                end
            end
            TabContainer.Visible = true
            TabSelect.BackgroundTransparency = 0.7
        end

        table.insert(redzlib.Tabs, Tab)
        TabSelect.Activated:Connect(function() Tab.func:Enable() end)

        if #redzlib.Tabs == 1 then
            Tab.func:Enable()
            FirstTab = true
        end

        -- Retorna a tab para adicionar elementos
        local TabApi = {}
        function TabApi:AddLabel(Text)
            local L = InsertTheme(Create("TextLabel", TabContainer, {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham, Text = Text,
                TextColor3 = Theme["Color Text"], TextSize = 10,
                TextXAlignment = "Left", TextWrapped = true
            }), "Text")
            return { Set = function(self, t) L.Text = t end }
        end
        function TabApi:AddButton(Cfg)
            local Name     = Cfg[1] or Cfg.Name or "Button"
            local Callback = Cfg[2] or Cfg.Callback or function() end
            local Btn = Make("Button", TabContainer, { Size = UDim2.new(1, 0, 0, 28) })
            Make("Corner", Btn)
            SetProps(Btn, {
                Text = Name, Font = Enum.Font.GothamMedium,
                TextColor3 = Theme["Color Text"], TextSize = 10
            })
            Btn.Activated:Connect(Callback)
            return Btn
        end
        function TabApi:AddToggle(Cfg)
            local Name    = Cfg[1] or Cfg.Name or "Toggle"
            local Default = Cfg[2] or Cfg.Default or false
            local Callback= Cfg[3] or Cfg.Callback or function() end
            local state = Default
            local Frame, Label = ButtonFrame(TabContainer, Name, "", UDim2.new(1, -30, 0, 20))
            local Toggle = Create("Frame", Frame, {
                Size = UDim2.new(0, 30, 0, 16),
                Position = UDim2.new(1, -35, 0.5),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = state and Theme["Color Theme"] or Theme["Color Stroke"],
            })
            Make("Corner", Toggle, UDim.new(1, 0))
            local Dot = Create("Frame", Toggle, {
                Size = UDim2.new(0, 12, 0, 12),
                Position = state and UDim2.new(1, -14, 0.5) or UDim2.new(0, 2, 0.5),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.new(1,1,1),
            })
            Make("Corner", Dot, UDim.new(1, 0))
            Frame.Activated:Connect(function()
                state = not state
                Toggle.BackgroundColor3 = state and Theme["Color Theme"] or Theme["Color Stroke"]
                CreateTween({Dot, "Position", state and UDim2.new(1, -14, 0.5) or UDim2.new(0, 2, 0.5), 0.2})
                Callback(state)
            end)
            return { Set = function(self, v)
                state = v
                Toggle.BackgroundColor3 = state and Theme["Color Theme"] or Theme["Color Stroke"]
                Dot.Position = state and UDim2.new(1, -14, 0.5) or UDim2.new(0, 2, 0.5)
            end }
        end
        function TabApi:AddSlider(Cfg)
            local Name    = Cfg[1] or Cfg.Name or "Slider"
            local Min     = Cfg[2] or Cfg.Min or 0
            local Max     = Cfg[3] or Cfg.Max or 100
            local Default = Cfg[4] or Cfg.Default or Min
            local Callback= Cfg[5] or Cfg.Callback or function() end
            local Frame, Label = ButtonFrame(TabContainer, Name, "", UDim2.new(1, 0, 0, 20))
            local Bar = Create("Frame", TabContainer, {
                Size = UDim2.new(1, 0, 0, 6),
                BackgroundColor3 = Theme["Color Stroke"],
            })
            Make("Corner", Bar, UDim.new(1, 0))
            local Fill = Create("Frame", Bar, {
                Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0),
                BackgroundColor3 = Theme["Color Theme"],
            })
            Make("Corner", Fill, UDim.new(1, 0))
            return { Set = function(self, v) Fill.Size = UDim2.new((v-Min)/(Max-Min), 0, 1, 0) end }
        end
        return TabApi
    end

    -- Expõe a Window e seleciona primeira tab
    return Window
end

-- ============================================================
-- FIM
-- ============================================================
return redzlib

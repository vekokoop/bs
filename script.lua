-- BlockSpin Pro Hub - True Silent Aim & Clean ESP Edition
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ضمان استمرارية السكربت عند الانتقال
local queue_func = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if queue_func then
    queue_func([[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vekokoop/D-v3/refs/heads/main/script.lua"))()
    ]])
end

-- إزالة أي واجهة قديمة لمنع التكرار
if CoreGui:FindFirstChild("BlockSpinSilentESP") then
    CoreGui.BlockSpinSilentESP:Destroy()
end

-- إعداد دائرة الـ FOV للسايلنت أيم (تظهر في منتصف الشاشة)
local FOV_Radius = 120 -- يمكنك التحكم بحجم الدائرة من هنا
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = FOV_Radius
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 69, 0)
fovCircle.Thickness = 1.5
fovCircle.Transparency = 0.7
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- واجهة المستخدم الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlockSpinSilentESP"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الأيقونة العائمة الفخمة (قابل للسحب)
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
FloatingIcon.Position = UDim2.new(0, 35, 0, 150)
FloatingIcon.Size = UDim2.new(0, 54, 0, 54)
FloatingIcon.Font = Enum.Font.SourceSansBold
FloatingIcon.Text = "🎯"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 69, 0)
FloatingIcon.TextSize = 26

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 69, 0)
IconStroke.Thickness = 2.5
IconStroke.Parent = FloatingIcon

-- النافذة الرئيسية للقائمة
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
MainFrame.Size = UDim2.new(0, 340, 0, 260)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 69, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- شريط العنوان العلوي
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
TopBar.Size = UDim2.new(1, 0, 0, 48)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local FixFrame = Instance.new("Frame")
FixFrame.Parent = TopBar
FixFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
FixFrame.BorderSizePixel = 0
FixFrame.Position = UDim2.new(0, 0, 0.5, 0)
FixFrame.Size = UDim2.new(1, 0, 0.5, 0)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "BLOCKSPIN | Silent & ESP"
Title.TextColor3 = Color3.fromRGB(255, 69, 0)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر إغلاق القائمة (X)
local CloseXBtn = Instance.new("TextButton")
CloseXBtn.Parent = TopBar
CloseXBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseXBtn.Position = UDim2.new(1, -38, 0.5, -13)
CloseXBtn.Size = UDim2.new(0, 26, 0, 26)
CloseXBtn.Font = Enum.Font.SourceSansBold
CloseXBtn.Text = "X"
CloseXBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseXBtn.TextSize = 13
CloseXBtn.AutoButtonColor = false

local XCorner = Instance.new("UICorner")
XCorner.CornerRadius = UDim.new(1, 0)
XCorner.Parent = CloseXBtn

-- حاوية العناصر الداخلية
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 55)
Container.Size = UDim2.new(1, 0, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 12)

local UIPad = Instance.new("UIPadding")
UIPad.Parent = Container
UIPad.PaddingTop = UDim.new(0, 5)

-- دالة إنشاء الأزرار
local function createFeatureToggle(name, desc)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    btn.Size = UDim2.new(0.9, 0, 0, 58)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = ""
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 70)
    stroke.Thickness = 1.2
    stroke.Parent = btn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 16, 0, 9)
    nameLabel.Size = UDim2.new(0.7, 0, 0, 20)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 15
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = btn
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 16, 0, 30)
    statusLabel.Size = UDim2.new(0.7, 0, 0, 18)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Text = "Status: [ OFF ]"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 13
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left

    return btn, statusLabel, stroke
end

local SilentAimBtn, SilentStatus, SilentStroke = createFeatureToggle("Silent Aim", "تصويب صامت داخل دائرة الفوف")
local EspBtn, EspStatus, EspStroke = createFeatureToggle("Players ESP", "كشف الأسماء والمسافة بدقة")

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end)

local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
end

FloatingIcon.MouseButton1Click:Connect(toggleMenu)
CloseXBtn.MouseButton1Click:Connect(toggleMenu)

local function setupFeatureLogic(button, statusLabel, stroke, callback)
    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            statusLabel.Text = "Status: [ ACTIVE ]"
            statusLabel.TextColor3 = Color3.fromRGB(255, 69, 0)
            stroke.Color = Color3.fromRGB(255, 69, 0)
            task.spawn(function()
                callback(true)
            end)
        else
            statusLabel.Text = "Status: [ OFF ]"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            stroke.Color = Color3.fromRGB(50, 50, 70)
            callback(false)
        end
    end)
end

-- دالة لاختيار أقرب هدف داخل دائرة الفوف (يستهدف الرأس أو الجسم ليكون واقعياً)
local function getClosestTargetInFOV()
    local closestTarget = nil
    local shortestDist = fovCircle.Radius
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local partToTarget = nil
            -- توزيع منطقي بين الراس والجسم (70% جسم، 30% رأس لتجنب كشف الحظر)
            if math.random(1, 10) <= 3 then
                partToTarget = p.Character:FindFirstChild("Head")
            else
                partToTarget = p.Character:FindFirstChild("HumanoidRootPart")
            end

            if partToTarget then
                local screenPos, onScreen = Camera:WorldToViewportPoint(partToTarget.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = partToTarget
                    end
                end
            end
        end
    end
    return closestTarget
end

-- 1. منطق الـ Silent Aim الحقيقي (اعتراض الـ Raycast لتوجيه الطلقات)
local silentAimEnabled = false
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if silentAimEnabled and (method == "Raycast" or method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList") then
        local targetPart = getClosestTargetInFOV()
        if targetPart and self == Workspace then
            if method == "Raycast" then
                local origin = args[1]
                local direction = (targetPart.Position - origin).Unit * args[2].Magnitude
                args[2] = direction
            elseif method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" then
                local ray = args[1]
                local direction = (targetPart.Position - ray.Origin).Unit * ray.Direction.Magnitude
                args[1] = Ray.new(ray.Origin, direction)
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

setupFeatureLogic(SilentAimBtn, SilentStatus, SilentStroke, function(enabled)
    silentAimEnabled = enabled
    fovCircle.Visible = enabled
end)

-- تحديث موقع دائرة الفوف باستمرار
RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

-- 2. منطق الـ ESP المحسن (اسم اللاعب + المسافة بشكل صغير ومرتب)
local espObjects = {}
local espEnabled = false

setupFeatureLogic(EspBtn, EspStatus, EspStroke, function(enabled)
    espEnabled = enabled
    if enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local char = p.Character
                if char and char:FindFirstChild("Head") and not char.Head:FindFirstChild("BlockSpinESP") then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "BlockSpinESP"
                    bill.Size = UDim2.new(0, 100, 0, 35)
                    bill.AlwaysOnTop = true
                    bill.StudsOffset = Vector3.new(0, 2.3, 0)
                    
                    local lbl = Instance.new("TextLabel")
                    lbl.Name = "InfoLabel"
                    lbl.Parent = bill
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = Color3.fromRGB(255, 120, 50)
                    lbl.TextStrokeTransparency = 0.4
                    lbl.TextSize = 11
                    lbl.Font = Enum.Font.SourceSansBold
                    lbl.Text = p.Name .. "\n[--m]"
                    
                    bill.Parent = char.Head
                    table.insert(espObjects, bill)
                end
            end
        end
    else
        for _, obj in ipairs(espObjects) do
            if obj then obj:Destroy() end
        end
        espObjects = {}
    end
end)

-- حلقة لتحديث المسافات الحقيقية للاعبين لحظياً بدون ثقل على اللعبة
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local bill = head:FindFirstChild("BlockSpinESP")
                if bill and bill:FindFirstChild("InfoLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local dist = math.floor((hrp.Position - head.Position).Magnitude)
                    bill.InfoLabel.Text = p.Name .. "\n[" .. dist .. "m]"
                end
            end
        end
    end
end)

-- سحب وإفلات الأيقونة العائمة بسلاسة
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingIcon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("BlockSpin True Silent Aim & Clean ESP Hub Loaded Successfully!")

-- Fix lỗi bù biến Character và HumanoidRootPart
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Đảm bảo khi hồi sinh không bị lỗi script
player.CharacterAdded:Connect(function(char)
    character = char
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

-- 1. Tạo Gui Chính
local gui = Instance.new("ScreenGui")
gui.Name = "ThienHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- 2. Khung Bảng Điều Khiển (Màn Ngang)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 260)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- 3. Thanh Tiêu Đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "☯ Thiện Hub (Màn Ngang)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- 4. Nút Đóng (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

-- 5. Nút Mở Lại Menu (Icon Tròn)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 20, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
toggleBtn.Text = "☯"
toggleBtn.TextSize = 22
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Visible = false
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = gui

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    toggleBtn.Visible = false
end)

-- 6. Khung Cuộn Nút Chức Năng
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -45)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)

local function addBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.BorderColor3 = Color3.fromRGB(0, 150, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
end

-- 7. Danh Sách Nút
addBtn("▶ Auto Farm Level", function() print("Auto Farm Started") end)
addBtn("⚔ Săn Boss", function() print("San Boss Started") end)
addBtn("🚪 Đi Raid", function() print("Raid Started") end)
addBtn("🛒 Mua Trái Ác Quỷ", function() print("Buy Fruit") end)
addBtn("📦 Cất Trái Ác Quỷ", function() print("Store Fruit") end)
addBtn("🏝 Teleport Đảo Rừng", function() if rootPart then rootPart.CFrame = CFrame.new(100, 20, 200) end end)
addBtn("🏝 Teleport Đảo Sa Mạc", function() if rootPart then rootPart.CFrame = CFrame.new(-150, 20, 300) end end)
addBtn("👁 Bật ESP (Xuyên Tường)", function() print("ESP Activated") end)

scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

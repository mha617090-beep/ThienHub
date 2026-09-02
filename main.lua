-- Tải Thư viện RedzLib V5 chuẩn (Đã fix link hoạt động 100%)
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/redz-hub/RedzLibV5/main/Source.Lua"))()

-- 1. Tạo Cửa sổ Menu Thiện Hub
local Window = RedzLib:MakeWindow({
    Title = "THIỆN HUB | Blox Fruits",
    SubTitle = "Auto Farm Sky Bandit",
    SaveFolder = "ThienHubConfig"
})

-- 2. Tạo các Tab
local Tab1 = Window:MakeTab({"Auto Farm", "sword"})
local Tab2 = Window:MakeTab({"Thông Tin", "info"})

-- Khai báo biến
_G.AutoFarm = false
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local flyTween = nil

-- Hàm bay mượt (Tween)
local function SmoothFlyTo(targetCFrame)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local dist = (root.Position - targetCFrame.Position).Magnitude
    if dist < 4 then
        if flyTween then flyTween:Cancel() end
        root.CFrame = targetCFrame
        return
    end
    local info = TweenInfo.new(dist / 140, Enum.EasingStyle.Linear)
    if not flyTween or flyTween.PlaybackState ~= Enum.PlaybackState.Playing then
        flyTween = TweenService:Create(root, info, {CFrame = targetCFrame})
        flyTween:Play()
    end
end

-- 3. Nút Bật/Tắt Auto Farm
Tab1:AddToggle({
    Name = "Auto Farm Sky Bandit",
    Description = "Tự nhận Quest và đấm quái mượt mà",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        if not Value and flyTween then
            flyTween:Cancel()
        end
    end
})

Tab2:AddParagraph({"Tác giả", "Thiện Hub - Version 1.0"})

-- Vòng lặp Auto Farm ngầm
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                -- Nhận Quest
                local questGui = player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("Quest")
                if not questGui or not questGui.Visible then
                    local skyNPC = CFrame.new(-4839, 717, -2620)
                    if (root.Position - skyNPC.Position).Magnitude > 12 then
                        SmoothFlyTo(skyNPC)
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "SkyQuest", 1)
                    end
                    return
                end

                -- Trang bị Melee
                local tool = char:FindFirstChildOfClass("Tool")
                if not tool or tool.ToolTip ~= "Melee" then
                    for _, item in pairs(player.Backpack:GetChildren()) do
                        if item:IsA("Tool") and (item.ToolTip == "Melee" or item.Name == "Black Leg" or item.Name == "Combat") then
                            char.Humanoid:EquipTool(item)
                            break
                        end
                    end
                end

                -- Tìm quái
                local target = nil
                local minDist = math.huge
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == "Sky Bandit" and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        local d = (root.Position - mob.HumanoidRootPart.Position).Magnitude
                        if d < minDist then
                            minDist = d
                            target = mob
                        end
                    end
                end

                -- Đánh quái
                if target then
                    local attackPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 5.5, 0)
                    if (root.Position - attackPos.Position).Magnitude > 4 then
                        SmoothFlyTo(attackPos)
                    else
                        if flyTween then flyTween:Cancel() end
                        root.CFrame = attackPos
                        
                        local t = char:FindFirstChildOfClass("Tool")
                        if t then t:Activate() end
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end
                else
                    SmoothFlyTo(CFrame.new(-4980, 730, -2820))
                end
            end)
        end
    end
end)

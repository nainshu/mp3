local function getGitSoundId(GithubSoundPath, AssetName)
    local Url = GithubSoundPath
    if not isfile(AssetName..".mp3") then 
        writefile(AssetName..".mp3", game:HttpGet(Url)) 
    end
    local Sound = Instance.new("Sound")
    Sound.SoundId = (getcustomasset or getsynasset)(AssetName..".mp3")
    Sound.Name = AssetName
    return Sound 
end

-- 三首音乐
local Sound1 = getGitSoundId("https://github.com/LX318/LX/blob/main/MaoFandian.mp3?raw=true", "猫饭店")
local Sound2 = getGitSoundId("https://github.com/nainshu/mp3/blob/main/42azd-wvi5k.mp3?raw=true", "福星小子")
local Sound3 = getGitSoundId("https://github.com/nainshu/mp3/blob/main/1464844757-1-192.mp3?raw=true", "乱马旧版主题曲")

-- 全部放进SoundService
Sound1.Parent = game:GetService("SoundService")
Sound2.Parent = game:GetService("SoundService")
Sound3.Parent = game:GetService("SoundService")

-- 当前播放索引
local currentSoundIndex = 0 -- 初始为0，第一次点击播第一首
local soundList = {Sound1, Sound2, Sound3}
local soundNames = {"猫饭店", "福星小子", "乱马旧版主题曲"}

-- 播放指定索引的音乐
local function playSound(index)
    -- 停止所有音乐
    for _, sound in pairs(soundList) do
        sound:Stop()
    end
    
    -- 更新索引并播放
    currentSoundIndex = index
    local currentSound = soundList[currentSoundIndex]
    currentSound:Play()
    
    -- 更新按钮文字
    Button.Text = "当前播放:\n" .. soundNames[currentSoundIndex]
    
    -- 播完后自动下一首（如果想保持手动切换，可以删除这段）
    currentSound.Ended:Connect(function()
        playSound((currentSoundIndex % #soundList) + 1)
    end)
end

-- 切换到下一首
local function playNextSound()
    local nextIndex = (currentSoundIndex % #soundList) + 1
    playSound(nextIndex)
end

-- 创建界面
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Name = "音乐切换按钮"
Button.Size = UDim2.new(0, 120, 0, 60) -- 加宽以显示歌曲名
Button.Position = UDim2.new(1, -130, 0, 10) -- 右上角
Button.AnchorPoint = Vector2.new(1, 0)
Button.BackgroundColor3 = Color3.new(0, 0, 0) -- 纯黑背景
Button.TextColor3 = Color3.fromRGB(170, 0, 255) -- 紫色文字
Button.Text = "点击切换音乐"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14
Button.TextWrapped = true -- 允许文字换行

-- 圆角
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Button

-- 紫色边框
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(102, 0, 204)
UIStroke.Thickness = 2
UIStroke.Parent = Button

-- 点击切换到下一首
Button.MouseButton1Click:Connect(function()
    playNextSound()
    
    -- 点击动画
    Button.Size = UDim2.new(0, 115, 0, 55)
    task.wait(0.1)
    Button.Size = UDim2.new(0, 120, 0, 60)
end)

-- 悬停效果
Button.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(
        Button,
        TweenInfo.new(0.2),
        {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}
    ):Play()
end)

Button.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(
        Button,
        TweenInfo.new(0.2),
        {BackgroundColor3 = Color3.new(0, 0, 0)}
    ):Play()
end)

Button.Parent = ScreenGui

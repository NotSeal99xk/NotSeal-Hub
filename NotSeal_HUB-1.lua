--// NotSeal HUB
--// Made by NotSeal
--// Organized + Toggle System

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("NotSealHUB") then
	PlayerGui.NotSealHUB:Destroy()
end

local Colors = {
	Background = Color3.fromRGB(255, 255, 255),
	SoftBlue   = Color3.fromRGB(186, 225, 255),
	LightBlue  = Color3.fromRGB(210, 235, 255),
	Accent     = Color3.fromRGB(140, 200, 255),
	Text       = Color3.fromRGB(70, 100, 140),
	SoftPink   = Color3.fromRGB(255, 210, 230),
	Sidebar    = Color3.fromRGB(225, 240, 255),
	TabActive  = Color3.fromRGB(160, 210, 255),
	TabIdle    = Color3.fromRGB(245, 250, 255),
	On         = Color3.fromRGB(100, 210, 140),
	Off        = Color3.fromRGB(210, 235, 255),
}

local CORRECT_KEY = "mmvnotseals0"
local unlocked = false
local ToggleState = {}
local CleanupFns = {}
local Connections = {}

local function addConn(name, conn)
	if not Connections[name] then Connections[name] = {} end
	table.insert(Connections[name], conn)
end

local function clearConns(name)
	if Connections[name] then
		for _, c in ipairs(Connections[name]) do
			pcall(function() c:Disconnect() end)
		end
		Connections[name] = {}
	end
end

local function destroyByName(names)
	for _, gui in ipairs(PlayerGui:GetChildren()) do
		for _, n in ipairs(names) do
			if gui.Name == n or string.find(string.lower(gui.Name), string.lower(n)) then
				pcall(function() gui:Destroy() end)
			end
		end
	end
	pcall(function()
		if gethui then
			for _, gui in ipairs(gethui():GetChildren()) do
				for _, n in ipairs(names) do
					if gui.Name == n or string.find(string.lower(gui.Name), string.lower(n)) then
						pcall(function() gui:Destroy() end)
					end
				end
			end
		end
	end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NotSealHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- KEY SYSTEM
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 280, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
KeyFrame.BackgroundColor3 = Colors.Background
KeyFrame.Parent = ScreenGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)
local ks = Instance.new("UIStroke", KeyFrame)
ks.Color = Colors.SoftBlue
ks.Thickness = 2.2

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundColor3 = Colors.SoftBlue
KeyTitle.Text = "☁️ NotSeal HUB - Key"
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 15
KeyTitle.TextColor3 = Colors.Text
KeyTitle.Parent = KeyFrame
Instance.new("UICorner", KeyTitle).CornerRadius = UDim.new(0, 16)

local KeyTitleFix = Instance.new("Frame")
KeyTitleFix.Size = UDim2.new(1, 0, 0, 12)
KeyTitleFix.Position = UDim2.new(0, 0, 1, -12)
KeyTitleFix.BackgroundColor3 = Colors.SoftBlue
KeyTitleFix.BorderSizePixel = 0
KeyTitleFix.Parent = KeyTitle

local KeyInfo = Instance.new("TextLabel")
KeyInfo.Size = UDim2.new(1, -30, 0, 20)
KeyInfo.Position = UDim2.new(0, 15, 0, 50)
KeyInfo.BackgroundTransparency = 1
KeyInfo.Text = "Enter the key to unlock"
KeyInfo.Font = Enum.Font.Gotham
KeyInfo.TextSize = 12
KeyInfo.TextColor3 = Color3.fromRGB(120, 150, 180)
KeyInfo.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -30, 0, 36)
KeyBox.Position = UDim2.new(0, 15, 0, 80)
KeyBox.BackgroundColor3 = Colors.LightBlue
KeyBox.PlaceholderText = "Key..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(140, 170, 200)
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextColor3 = Colors.Text
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(1, -30, 0, 36)
KeyBtn.Position = UDim2.new(0, 15, 0, 128)
KeyBtn.BackgroundColor3 = Colors.SoftBlue
KeyBtn.Text = "Unlock"
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 14
KeyBtn.TextColor3 = Colors.Text
KeyBtn.AutoButtonColor = false
KeyBtn.Parent = KeyFrame
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 8)

local KeyError = Instance.new("TextLabel")
KeyError.Size = UDim2.new(1, -30, 0, 20)
KeyError.Position = UDim2.new(0, 15, 0, 170)
KeyError.BackgroundTransparency = 1
KeyError.Text = ""
KeyError.Font = Enum.Font.Gotham
KeyError.TextSize = 12
KeyError.TextColor3 = Color3.fromRGB(255, 80, 80)
KeyError.Parent = KeyFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 52, 0, 52)
OpenBtn.Position = UDim2.new(0, 18, 0.5, -26)
OpenBtn.BackgroundColor3 = Colors.SoftBlue
OpenBtn.Text = "☁️"
OpenBtn.TextSize = 22
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextColor3 = Colors.Text
OpenBtn.AutoButtonColor = false
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local os2 = Instance.new("UIStroke", OpenBtn)
os2.Color = Colors.Accent
os2.Thickness = 2

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 360)
Main.Position = UDim2.new(0.5, -210, 0.5, -180)
Main.BackgroundColor3 = Colors.Background
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
local ms = Instance.new("UIStroke", Main)
ms.Color = Colors.SoftBlue
ms.Thickness = 2.2

-- Background image
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "Background"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = "rbxthumb://type=Asset&id=74569081626811&w=420&h=420"
BgImage.ImageTransparency = 0.15
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 0
BgImage.Parent = Main
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 16)

local function tryUnlock()
	if KeyBox.Text == CORRECT_KEY then
		unlocked = true
		KeyError.Text = ""
		KeyFrame.Visible = false
		OpenBtn.Visible = true
		print("✅ NotSeal HUB unlocked!")
	else
		KeyError.Text = "Wrong key!"
		KeyBox.Text = ""
	end
end
KeyBtn.MouseButton1Click:Connect(tryUnlock)
KeyBox.FocusLost:Connect(function(enter) if enter then tryUnlock() end end)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Colors.SoftBlue
Header.BackgroundTransparency = 0.1
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 14)
HeaderFix.Position = UDim2.new(0, 0, 1, -14)
HeaderFix.BackgroundColor3 = Colors.SoftBlue
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -48, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hub by @n0t_s3al.sc on tt"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Colors.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Colors.SoftPink
CloseBtn.Text = "✕"
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Colors.Text
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -54)
Sidebar.Position = UDim2.new(0, 8, 0, 50)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BackgroundTransparency = 0.25
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.Parent = Sidebar
local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop = UDim.new(0, 8)
SidePad.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -140, 1, -54)
Content.Position = UDim2.new(0, 134, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(248, 252, 255)
Content.BackgroundTransparency = 0.2
Content.BorderSizePixel = 0
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

local Pages, TabButtons = {}, {}

local function CreatePage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, -10, 1, -10)
	page.Position = UDim2.new(0, 5, 0, 5)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 4
	page.ScrollBarImageColor3 = Colors.Accent
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.Parent = Content
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = page
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 8)
	pad.Parent = page
	Pages[name] = page
	return page
end

local function SwitchTab(name)
	for n, page in pairs(Pages) do page.Visible = (n == name) end
	for n, btn in pairs(TabButtons) do
		if n == name then
			btn.BackgroundColor3 = Colors.TabActive
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundColor3 = Colors.TabIdle
			btn.TextColor3 = Colors.Text
		end
	end
end

local function CreateTab(name, icon)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 106, 0, 30)
	btn.BackgroundColor3 = Colors.TabIdle
	btn.Text = icon .. "  " .. name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.TextColor3 = Colors.Text
	btn.AutoButtonColor = false
	btn.Parent = Sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	TabButtons[name] = btn
	CreatePage(name)
	btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
end

local function CreateToggle(pageName, text, onEnable, onDisable)
	local page = Pages[pageName]
	if not page then return end
	ToggleState[text] = false

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 0, 32)
	Btn.BackgroundColor3 = Colors.Off
	Btn.Text = text .. "  [OFF]"
	Btn.Font = Enum.Font.GothamMedium
	Btn.TextSize = 12
	Btn.TextColor3 = Colors.Text
	Btn.AutoButtonColor = false
	Btn.Parent = page
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
	local st = Instance.new("UIStroke", Btn)
	st.Color = Colors.SoftBlue
	st.Thickness = 1

	Btn.MouseButton1Click:Connect(function()
		ToggleState[text] = not ToggleState[text]
		if ToggleState[text] then
			Btn.BackgroundColor3 = Colors.On
			Btn.Text = text .. "  [ON]"
			Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			pcall(onEnable)
		else
			Btn.BackgroundColor3 = Colors.Off
			Btn.Text = text .. "  [OFF]"
			Btn.TextColor3 = Colors.Text
			pcall(onDisable)
		end
	end)
end

CreateTab("Hubs", "🏠")
CreateTab("CNP", "📋")
CreateTab("Visual", "🎨")
CreateTab("Quality", "✨")
CreateTab("Character", "👤")
CreateTab("Combat", "⚔️")
CreateTab("Camera", "📷")

-- HUBS
CreateToggle("Hubs", "Kuromi Hub", function()
	loadstring(game:HttpGet("https://pastefy.app/Yz2ltiHF/raw"))()
end, function()
	destroyByName({"Kuromi", "kuromi"})
end)

CreateToggle("Hubs", "N4THUB", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/yonatansmsmmsms-crypto/N4T-HUB-Gears-/refs/heads/main/N4T_HUB_with_gears.lua"))()
end, function()
	destroyByName({"N4T", "N4THUB", "n4t"})
end)

CreateToggle("Hubs", "VanguardHub", function()
	loadstring(game:HttpGet("https://tinyurl.com/BombGoldLoader"))()
end, function()
	destroyByName({"Vanguard", "BombGold", "vanguard"})
end)

CreateToggle("Hubs", "Devy Blue Menu", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/antonioffxslegend-collab/Devy-Blue-Menu/main/script.lua"))()
end, function()
	destroyByName({"DevyCoquetteBlue", "Devy", "devy"})
end)

CreateToggle("Hubs", "Devy Menu #2", function()
	loadstring(game:HttpGet("https://gist.githubusercontent.com/ScriptHub927/cbd3db50c0d1234441bab0f7c89cc822/raw/painel_cnp_dev.lua"))()
end, function()
	destroyByName({"Devy", "painel_cnp", "dev"})
end)

CreateToggle("Hubs", "Gears", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/antonioffxslegend-collab/Gears/main/script.lua"))()
end, function()
	destroyByName({"GearsMmvPanel", "Gears"})
end)

-- CNP
CreateToggle("CNP", "Cnp Panel #1", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/antonioffxslegend-collab/Cnp-mmv-Petrova/main/script.lua"))()
end, function()
	destroyByName({"Cnp", "Petrova", "painel", "Panel"})
end)

CreateToggle("CNP", "Cnp Panel #2", function()
	loadstring(game:HttpGet("https://gist.githubusercontent.com/kaywxzstumblr/334ff80c087bf16b05e9485a13c8ce96/raw/d02ea328497c72dc896d56b4a90036cf1822be06/gistfile1.txt", true))()
end, function()
	destroyByName({"ControlPanelGui", "LoginGui", "kaywxzs", "Painel"})
end)

CreateToggle("CNP", "Cnp Panel #3", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/kDXy1n6X"))()
end, function()
	destroyByName({"Cnp", "Painel", "Panel"})
end)

CreateToggle("CNP", "Cnp Painel #4", function()
	loadstring(game:HttpGet("https://gist.githubusercontent.com/jloneri557-a11y/e58333eca9cd803346d0a6d8af2ab1e4/raw/a0f7601432b82a43546c1efd173cf34fc3d5335a/gistfile1.txt"))()
end, function()
	destroyByName({"Cnp", "Painel", "Panel"})
end)

CreateToggle("CNP", "Cnp Painel #5", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/yonatansmsmmsms-crypto/painel/refs/heads/main/message.txt"))()
end, function()
	destroyByName({"Cnp", "Painel", "Panel"})
end)

CreateToggle("CNP", "Cnp Painel #6", function()
	loadstring(game:HttpGet("https://gist.githubusercontent.com/ScriptHub927/18e5743c563d645b09b709571c6e1620/raw/painel_cnp_from_KojuAn.lua"))()
end, function()
	destroyByName({"Cnp", "Painel", "KojuAn", "Panel"})
end)

CreateToggle("CNP", "Cnp Painel #7", function()
	loadstring(game:HttpGet("https://pastefy.app/ZU6youRe/raw"))()
end, function()
	destroyByName({"Cnp", "Painel", "Panel"})
end)

CreateToggle("CNP", "Cnp Panel #8", function()
	loadstring(game:HttpGet("https://gist.githubusercontent.com/kaywxzstumblr/334ff80c087bf16b05e9485a13c8ce96/raw/015f987ffee1be42b2a2b405ed587064f7b87c08/gistfile1.txt", true))()
end, function()
	destroyByName({"ControlPanelGui", "LoginGui", "kaywxzs", "Cnp", "Painel", "Panel"})
end)

-- VISUAL
CreateToggle("Visual", "MatrixScope Recolor", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/antonioffxslegend-collab/Mmv-Scope-Recolor/main/script.lua"))()
end, function()
	destroyByName({"Scope", "Matrix", "Recolor"})
end)

CreateToggle("Visual", "MicahFX Recolor Scope", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/gpdQuYvr"))()
end, function()
	destroyByName({"Micah", "Scope", "Recolor"})
end)

CreateToggle("Visual", "Scope Recolor #3", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/99xcr/vs/refs/heads/main/VoidscopeRecolor-1.lua"))()
end, function()
	destroyByName({"Voidscope", "Scope", "Recolor"})
end)

CreateToggle("Visual", "Skyboxes", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/FsDLPBtZ"))()
end, function()
	destroyByName({"Skybox", "Sky"})
end)

CreateToggle("Visual", "Equalizador", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/fw4dLV6t"))()
end, function()
	destroyByName({"Equalizador", "Equalizer"})
end)

-- QUALITY
local qualityBackup = {}
CreateToggle("Quality", "2020 Quality", function()
	qualityBackup["2020"] = {
		Technology = Lighting.Technology,
		Brightness = Lighting.Brightness,
		Ambient = Lighting.Ambient,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		FogStart = Lighting.FogStart,
		FogEnd = Lighting.FogEnd,
	}
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect")
		or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
			v:Destroy()
		end
	end
	pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)
	Lighting.GlobalShadows = true
	Lighting.Brightness = 2.12
	Lighting.ClockTime = 14
	Lighting.Ambient = Color3.fromRGB(148, 148, 148)
	Lighting.OutdoorAmbient = Color3.fromRGB(148, 148, 148)
	Lighting.FogStart = 100000
	Lighting.FogEnd = 100000
end, function()
	local b = qualityBackup["2020"]
	if b then
		pcall(function() Lighting.Technology = b.Technology end)
		Lighting.Brightness = b.Brightness
		Lighting.Ambient = b.Ambient
		Lighting.OutdoorAmbient = b.OutdoorAmbient
		Lighting.FogStart = b.FogStart
		Lighting.FogEnd = b.FogEnd
	end
end)

CreateToggle("Quality", "2023 Quality", function()
	qualityBackup["2023"] = {}
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
			qualityBackup["2023"][v] = v.Brightness
			v.Brightness = v.Brightness * 0.5
		end
	end
end, function()
	for light, orig in pairs(qualityBackup["2023"] or {}) do
		if light and light.Parent then light.Brightness = orig end
	end
	qualityBackup["2023"] = {}
end)

CreateToggle("Quality", "Qualidade Antiga", function()
	qualityBackup["antiga"] = {
		Technology = Lighting.Technology,
		Brightness = Lighting.Brightness,
		Ambient = Lighting.Ambient,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		FogStart = Lighting.FogStart,
		FogEnd = Lighting.FogEnd,
		FogColor = Lighting.FogColor,
	}
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect")
		or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("ColorCorrectionEffect") then
			v:Destroy()
		end
	end
	pcall(function() Lighting.Technology = Enum.Technology.ShadowMap end)
	Lighting.Brightness = 2
	Lighting.GlobalShadows = true
	Lighting.ClockTime = 14
	Lighting.Ambient = Color3.fromRGB(70, 70, 70)
	Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 130)
	Lighting.FogColor = Color3.fromRGB(190, 200, 210)
	Lighting.FogStart = 500
	Lighting.FogEnd = 5000
end, function()
	local b = qualityBackup["antiga"]
	if b then
		pcall(function() Lighting.Technology = b.Technology end)
		Lighting.Brightness = b.Brightness
		Lighting.Ambient = b.Ambient
		Lighting.OutdoorAmbient = b.OutdoorAmbient
		Lighting.FogStart = b.FogStart
		Lighting.FogEnd = b.FogEnd
		Lighting.FogColor = b.FogColor
	end
end)

-- CHARACTER
CreateToggle("Character", "Headless", function()
	local function makeHeadless(char)
		local head = char:FindFirstChild("Head")
		if head then
			head.Transparency = 1
			for _, v in pairs(head:GetChildren()) do
				if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
			end
		end
	end
	if LocalPlayer.Character then makeHeadless(LocalPlayer.Character) end
	clearConns("Headless")
	addConn("Headless", LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(0.6)
		if ToggleState["Headless"] then makeHeadless(char) end
	end))
end, function()
	clearConns("Headless")
	local char = LocalPlayer.Character
	if char then
		local head = char:FindFirstChild("Head")
		if head then
			head.Transparency = 0
			for _, v in pairs(head:GetChildren()) do
				if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end
			end
		end
	end
end)

CreateToggle("Character", "Korblox Biel", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/DEer3vJ7"))()
end, function()
	destroyByName({"Korblox", "Biel"})
end)

CreateToggle("Character", "Old Avatar Animations", function()
	pcall(function() workspace.Retargeting = Enum.AnimatorRetargetingMode.Disabled end)
	clearConns("OldAnim")
	addConn("OldAnim", LocalPlayer.CharacterAdded:Connect(function()
		task.wait(1)
		if ToggleState["Old Avatar Animations"] then
			pcall(function() workspace.Retargeting = Enum.AnimatorRetargetingMode.Disabled end)
		end
	end))
end, function()
	clearConns("OldAnim")
	pcall(function() workspace.Retargeting = Enum.AnimatorRetargetingMode.Default end)
end)

CreateToggle("Character", "Free Animations", function()
	loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-Ugc-Animations-242778"))()
end, function()
	destroyByName({"Animation", "UGC", "Fe"})
end)

CreateToggle("Character", "Roblox user fits", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/NotSeal99xk/Usernames-fits/refs/heads/main/users"))()
end, function()
	destroyByName({"Usernames", "fits", "users", "Fit"})
end)

-- COMBAT
CreateToggle("Combat", "NotSeal Gun Menu", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/bXbLcXiA"))()
end, function()
	destroyByName({"NotSealCinnamorollHub", "GunSystem", "GunMenu", "NotSeal"})
end)

CreateToggle("Combat", "Bomb #2", function()
	loadstring(game:HttpGet("https://pastefy.app/aebFxrFW/raw"))()
end, function()
	destroyByName({"Bomb", "aebFxrFW"})
end)

CreateToggle("Combat", "no gun anim (at)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/MWPrBwtf"))()
end, function()
	destroyByName({"Gun", "anim", "Animation"})
end)

CreateToggle("Combat", "NotSeal ESP", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/j3kFRZiZ"))()
end, function()
	destroyByName({"CinnamorollESP", "ESP"})
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			local h = plr.Character:FindFirstChild("PlayerESP")
			if h then h:Destroy() end
		end
	end
end)

CreateToggle("Combat", "Bomb", function()
	local Player = LocalPlayer
	local Mouse = Player:GetMouse()
	local Config = { Cooldown = 2, CanUse = true }
	local CurrentDroppedBomb = nil
	local function BuildC4()
		local p = Instance.new("Part")
		p.Name = "Handle"
		p.Size = Vector3.new(1.8, 0.7, 1.2)
		p.Color = Color3.fromRGB(0, 0, 0)
		p.Material = Enum.Material.Metal
		p.CanCollide = true
		return p
	end
	local function ClearBombs()
		for _, t in pairs(Player.Backpack:GetChildren()) do
			if t:IsA("Tool") and t.Name == "Bomb" then t:Destroy() end
		end
		if Player.Character then
			for _, t in pairs(Player.Character:GetChildren()) do
				if t:IsA("Tool") and t.Name == "Bomb" then t:Destroy() end
			end
		end
		if CurrentDroppedBomb then CurrentDroppedBomb:Destroy() CurrentDroppedBomb = nil end
	end
	local function GiveTool()
		if not ToggleState["Bomb"] then return end
		ClearBombs()
		local Tool = Instance.new("Tool")
		Tool.Name = "Bomb"
		Tool.RequiresHandle = true
		Tool.CanBeDropped = false
		Tool.Grip = CFrame.new(0, 0.8, 0.2) * CFrame.Angles(0, math.rad(180), 0)
		BuildC4().Parent = Tool
		Tool.Activated:Connect(function()
			if not Config.CanUse or not ToggleState["Bomb"] then return end
			local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			Config.CanUse = false
			if CurrentDroppedBomb then CurrentDroppedBomb:Destroy() end
			local d = BuildC4()
			d.CFrame = hrp.CFrame * CFrame.new(0, -3.2, 0)
			d.Parent = workspace
			CurrentDroppedBomb = d
			d.AssemblyLinearVelocity = (Mouse.Hit.Position - hrp.Position).Unit * 25 + Vector3.new(0, 10, 0)
			local parts = {}
			for _, p in pairs(Tool:GetChildren()) do
				if p:IsA("BasePart") then parts[p] = p.Transparency p.Transparency = 1 end
			end
			task.wait(Config.Cooldown)
			if CurrentDroppedBomb then CurrentDroppedBomb:Destroy() CurrentDroppedBomb = nil end
			for p, t in pairs(parts) do if p and p.Parent then p.Transparency = t end end
			Config.CanUse = true
		end)
		Tool.Parent = Player.Backpack
	end
	clearConns("Bomb")
	addConn("Bomb", Player.CharacterAdded:Connect(function()
		ClearBombs()
		task.wait(1)
		if ToggleState["Bomb"] then GiveTool() end
	end))
	GiveTool()
	CleanupFns["Bomb"] = ClearBombs
end, function()
	clearConns("Bomb")
	if CleanupFns["Bomb"] then CleanupFns["Bomb"]() end
end)

CreateToggle("Combat", "Gold Bomb Jump", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/eYGyBLRa"))()
end, function()
	destroyByName({"Gold", "BombJump"})
end)

CreateToggle("Combat", "Mil Base Fling", function()
	local holdingS, holdingAorD = false, false
	clearConns("Fling")
	addConn("Fling", UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.S then holdingS = true end
		if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then holdingAorD = true end
	end))
	addConn("Fling", UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.S then holdingS = false end
		if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then holdingAorD = false end
	end))
	local function setup(character)
		local humanoid = character:WaitForChild("Humanoid")
		local root = character:WaitForChild("HumanoidRootPart")
		addConn("Fling", humanoid.Jumping:Connect(function()
			if not ToggleState["Mil Base Fling"] then return end
			if root.CFrame.UpVector.Y < 0.7 and holdingS and holdingAorD then
				root.AssemblyLinearVelocity = Vector3.new(0, 170, 0)
			end
		end))
	end
	if LocalPlayer.Character then setup(LocalPlayer.Character) end
	addConn("Fling", LocalPlayer.CharacterAdded:Connect(function(c)
		if ToggleState["Mil Base Fling"] then setup(c) end
	end))
end, function()
	clearConns("Fling")
end)

-- CAMERA
local camBlurEffect = nil
local camBlurConn = nil
CreateToggle("Camera", "Cam Blur", function()
	local camera = workspace.CurrentCamera
	local blurAmount, blurAmplifier, minThreshold = 7, 2.5, 0.015
	local lastVector = camera.CFrame.LookVector
	camBlurEffect = Instance.new("BlurEffect")
	camBlurEffect.Parent = camera
	camBlurConn = RunService.Heartbeat:Connect(function()
		if not camBlurEffect or not camBlurEffect.Parent then
			camBlurEffect = Instance.new("BlurEffect")
			camBlurEffect.Parent = workspace.CurrentCamera
		end
		local currentVector = workspace.CurrentCamera.CFrame.LookVector
		local difference = (currentVector - lastVector).Magnitude
		camBlurEffect.Size = difference > minThreshold and (difference * blurAmount * blurAmplifier) or 0
		lastVector = currentVector
	end)
end, function()
	if camBlurConn then camBlurConn:Disconnect() camBlurConn = nil end
	if camBlurEffect then camBlurEffect:Destroy() camBlurEffect = nil end
end)

CreateToggle("Camera", "Fog Menu", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/iTeP2MYv"))()
end, function()
	destroyByName({"Fog"})
end)

CreateToggle("Camera", "Old Shiftlock 2024", function()
	local OLD_OFFSET = Vector3.new(0.9, 1.1, 0)
	local Humanoid, PreviousOffset, WasLocked = nil, Vector3.zero, false
	local function Update(Character)
		Humanoid = Character:WaitForChild("Humanoid", 5)
		PreviousOffset = Humanoid and Humanoid.CameraOffset or Vector3.zero
		WasLocked = false
	end
	if LocalPlayer.Character then Update(LocalPlayer.Character) end
	clearConns("Shift2024")
	addConn("Shift2024", LocalPlayer.CharacterAdded:Connect(Update))
	RunService:BindToRenderStep("OldShiftLockLite", Enum.RenderPriority.Camera.Value + 1, function()
		if not ToggleState["Old Shiftlock 2024"] then return end
		if not Humanoid or not Humanoid.Parent then return end
		local Locked = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
		if Locked and not WasLocked then
			PreviousOffset = Humanoid.CameraOffset
			Humanoid.CameraOffset = OLD_OFFSET
		elseif not Locked and WasLocked then
			Humanoid.CameraOffset = PreviousOffset
		end
		WasLocked = Locked
	end)
end, function()
	clearConns("Shift2024")
	pcall(function() RunService:UnbindFromRenderStep("OldShiftLockLite") end)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.CameraOffset = Vector3.zero end
end)

CreateToggle("Camera", "Shiftlock 2023", function()
	local function apply(hum)
		if hum:IsA("Humanoid") then hum.AutomaticScalingEnabled = false end
	end
	local function scan(character)
		if not character then return end
		for _, obj in pairs(character:GetDescendants()) do apply(obj) end
		addConn("Shift2023", character.DescendantAdded:Connect(apply))
	end
	clearConns("Shift2023")
	if LocalPlayer.Character then scan(LocalPlayer.Character) end
	addConn("Shift2023", LocalPlayer.CharacterAdded:Connect(function(c)
		task.wait(0.3)
		if ToggleState["Shiftlock 2023"] then scan(c) end
	end))
end, function()
	clearConns("Shift2023")
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.AutomaticScalingEnabled = true end
end)

CreateToggle("Camera", "MM2 Timer", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/drrLscZP"))()
end, function()
	destroyByName({"Timer", "MM2"})
end)

SwitchTab("Hubs")

OpenBtn.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)
CloseBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

print("☁️ NotSeal HUB with Toggles | Made by NotSeal")

local function mergeConfig(base, override)
	local result = {}
	for key, value in pairs(base or {}) do
		result[key] = value
	end
	for key, value in pairs(override or {}) do
		if type(value) == 'table' and type(result[key]) == 'table' then
			result[key] = mergeConfig(result[key], value)
		else
			result[key] = value
		end
	end
	return result
end

local function createGui(config)
	local Players = game:GetService('Players')
	local player = Players.LocalPlayer
	local playerGui = player and player:WaitForChild('PlayerGui', 5)
	if not playerGui then
		return nil
	end

	local screenGui = Instance.new('ScreenGui')
	screenGui.Name = 'VapeV4Gui'
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local main = Instance.new('Frame')
	main.Size = UDim2.fromOffset(380, 300)
	main.Position = UDim2.new(0.02, 0, 0.02, 0)
	main.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
	main.BorderSizePixel = 0
	main.Parent = screenGui

	local corner = Instance.new('UICorner')
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = main

	local header = Instance.new('Frame')
	header.Size = UDim2.new(1, 0, 0, 64)
	header.BackgroundColor3 = Color3.fromRGB(18, 21, 29)
	header.BorderSizePixel = 0
	header.Parent = main

	local hcorner = Instance.new('UICorner')
	hcorner.CornerRadius = UDim.new(0, 16)
	hcorner.Parent = header

	local glow = Instance.new('Frame')
	glow.Size = UDim2.new(1, 0, 0, 2)
	glow.Position = UDim2.new(0, 0, 1, -2)
	glow.BackgroundColor3 = Color3.fromRGB(88, 145, 255)
	glow.BorderSizePixel = 0
	glow.Parent = header

	local title = Instance.new('TextLabel')
	title.Size = UDim2.new(1, -20, 0, 24)
	title.Position = UDim2.new(0, 10, 0, 8)
	title.BackgroundTransparency = 1
	title.Text = config.gui.title or 'VAPE V4'
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local subtitle = Instance.new('TextLabel')
	subtitle.Size = UDim2.new(1, -20, 0, 18)
	subtitle.Position = UDim2.new(0, 10, 0, 34)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = ('Creator: %s | %s'):format(config.creator, config.creatorLabel)
	subtitle.TextColor3 = Color3.fromRGB(160, 170, 186)
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextSize = 12
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.Parent = header

	local container = Instance.new('ScrollingFrame')
	container.Size = UDim2.new(1, -16, 1, -80)
	container.Position = UDim2.new(0, 8, 0, 72)
	container.BackgroundTransparency = 1
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.ScrollBarThickness = 2
	container.Parent = main

	local layout = Instance.new('UIListLayout')
	layout.Padding = UDim.new(0, 7)
	layout.Parent = container

	for _, featureName in ipairs(config.gui.featureOrder) do
		local enabled = config.features[featureName] ~= false
		local row = Instance.new('Frame')
		row.Size = UDim2.new(1, -4, 0, 34)
		row.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
		row.BorderSizePixel = 0
		row.Parent = container

		local rowCorner = Instance.new('UICorner')
		rowCorner.CornerRadius = UDim.new(0, 9)
		rowCorner.Parent = row

		local label = Instance.new('TextLabel')
		label.Size = UDim2.new(1, -86, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = featureName
		label.TextColor3 = Color3.fromRGB(242, 242, 242)
		label.Font = Enum.Font.Gotham
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row

		local toggle = Instance.new('TextButton')
		toggle.Size = UDim2.new(0, 56, 0, 22)
		toggle.Position = UDim2.new(1, -62, 0.5, -11)
		toggle.BackgroundColor3 = enabled and Color3.fromRGB(74, 182, 107) or Color3.fromRGB(154, 74, 74)
		toggle.BorderSizePixel = 0
		toggle.Text = enabled and 'ON' or 'OFF'
		toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggle.Font = Enum.Font.GothamBold
		toggle.TextSize = 11
		toggle.Parent = row

		local toggleCorner = Instance.new('UICorner')
		toggleCorner.CornerRadius = UDim.new(0, 6)
		toggleCorner.Parent = toggle

		toggle.MouseButton1Click:Connect(function()
			config.features[featureName] = not config.features[featureName]
			toggle.Text = config.features[featureName] and 'ON' or 'OFF'
			toggle.BackgroundColor3 = config.features[featureName] and Color3.fromRGB(74, 182, 107) or Color3.fromRGB(154, 74, 74)
		end)
	end

	return screenGui
end

local function loadModuleFromRemote(moduleName, config)
	local remoteBase = 'https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/main/'
	local candidates = {
		moduleName,
		(moduleName:lower()),
		('modules/%s'):format(moduleName),
		('modules/%s'):format(moduleName:lower()),
		('features/%s'):format(moduleName),
		('features/%s'):format(moduleName:lower()),
	}
	for _, candidate in ipairs(candidates) do
		local ok, module = pcall(function()
			return loadstring(game:HttpGet(remoteBase..candidate..'.lua', true), candidate)
		end)
		if ok and type(module) == 'function' then
			return module
		end
	end
	return nil
end

local function resolveExecutor()
	local env = getgenv and getgenv() or _G
	if env and env.Solara then
		return 'Solara'
	end
	if env and env.Potassium then
		return 'Potassium'
	end
	return 'Default'
end

local function applyExecutorCompat(config)
	local executorName = config.executor and config.executor.name or resolveExecutor()
	config.executor = config.executor or {}
	config.executor.name = executorName
	config.executor.isSolara = executorName == 'Solara'
	config.executor.isPotassium = executorName == 'Potassium'
	config.executor.safeMode = executorName == 'Solara' or executorName == 'Potassium'
	config.executor.delay = executorName == 'Solara' or executorName == 'Potassium' and 0.08 or 0.04
	return config
end

local defaultConfig = {
	name = 'VAPE V4',
	creator = '381112395017410',
	creatorLabel = 'Killaura Legit',
	game = 'BedWars',
	initUrl = 'https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/main/loader.lua',
	description = 'BedWars loader with creator display, polished UI, and external feature modules.',
	autoRun = true,
	features = {
		AutoCoal = true,
		CrystalDisabler = true,
		InstantKill = true,
		KillAuraHitSync = true,
		CheatDetectorReachCheck = true,
		ClientLagger = true,
		ForceKit = true,
		Disabler = true,
		TPAura = true,
		AutoWin = true,
	},
	gui = {
		title = 'VAPE V4',
		subtitle = 'VAPE V4',
		showCreator = true,
		showFeatures = true,
		featureOrder = {
			'ClientLagger',
			'ForceKit',
			'Disabler',
			'TPAura',
			'AutoWin',
			'AutoCoal',
			'CrystalDisabler',
			'InstantKill',
			'KillAuraHitSync',
			'CheatDetectorReachCheck',
		},
	},
	executor = {
		name = resolveExecutor(),
	},
}

local config = mergeConfig(defaultConfig, shared.WhaleV4Config or {})
config = applyExecutorCompat(config)

-- Disable the local bootstrap UI so the original Vape V4 GUI from VapeCompiled loads cleanly.
if config.gui then
	config.gui.showFeatures = false
end

local initUrl = config.initUrl or 'https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/main/loader.lua'
local success, err = pcall(loadstring(game:HttpGet(initUrl, true), 'loader.lua'), config)
if not success then
	warn(('VAPE V4 failed to initialize: %s'):format(tostring(err)))
end

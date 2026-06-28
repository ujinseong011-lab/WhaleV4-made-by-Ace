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
	screenGui.Name = 'WhaleV4Gui'
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local main = Instance.new('Frame')
	main.Size = UDim2.fromOffset(420, 320)
	main.Position = UDim2.new(0.02, 0, 0.02, 0)
	main.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
	main.BorderSizePixel = 0
	main.Parent = screenGui

	local mainCorner = Instance.new('UICorner')
	mainCorner.CornerRadius = UDim.new(0, 18)
	mainCorner.Parent = main

	local accent = Instance.new('Frame')
	accent.Size = UDim2.new(1, 0, 0, 6)
	accent.BackgroundColor3 = Color3.fromRGB(102, 111, 255)
	accent.BorderSizePixel = 0
	accent.Parent = main

	local leftPane = Instance.new('Frame')
	leftPane.Size = UDim2.new(0, 130, 1, -12)
	leftPane.Position = UDim2.new(0, 10, 0, 10)
	leftPane.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
	leftPane.BorderSizePixel = 0
	leftPane.Parent = main

	local leftCorner = Instance.new('UICorner')
	leftCorner.CornerRadius = UDim.new(0, 14)
	leftCorner.Parent = leftPane

	local logo = Instance.new('TextLabel')
	logo.Size = UDim2.new(1, -20, 0, 32)
	logo.Position = UDim2.new(0, 10, 0, 12)
	logo.BackgroundTransparency = 1
	logo.Text = 'RAVEN+'
	logo.TextColor3 = Color3.fromRGB(240, 240, 255)
	logo.Font = Enum.Font.GothamBold
	logo.TextSize = 18
	logo.TextXAlignment = Enum.TextXAlignment.Left
	logo.Parent = leftPane

	local labelDesc = Instance.new('TextLabel')
	labelDesc.Size = UDim2.new(1, -20, 0, 36)
	labelDesc.Position = UDim2.new(0, 10, 0, 40)
	labelDesc.BackgroundTransparency = 1
	labelDesc.Text = 'BedWars toolkit'
	labelDesc.TextColor3 = Color3.fromRGB(170, 170, 210)
	labelDesc.Font = Enum.Font.Gotham
	labelDesc.TextSize = 12
	labelDesc.TextXAlignment = Enum.TextXAlignment.Left
	labelDesc.TextYAlignment = Enum.TextYAlignment.Top
	labelDesc.Parent = leftPane

	local tabContainer = Instance.new('Frame')
	tabContainer.Size = UDim2.new(1, -20, 1, -96)
	tabContainer.Position = UDim2.new(0, 10, 0, 82)
	tabContainer.BackgroundTransparency = 1
	tabContainer.Parent = leftPane

	local tabLayout = Instance.new('UIListLayout')
	tabLayout.Padding = UDim.new(0, 8)
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	tabLayout.Parent = tabContainer

	local sidebarTabs = {
		Features = 'Features',
		Info = 'Info',
	}

	local selectedTab = 'Features'
	local content = Instance.new('Frame')
	content.Size = UDim2.new(1, -158, 1, -20)
	content.Position = UDim2.new(0, 148, 0, 10)
	content.BackgroundColor3 = Color3.fromRGB(22, 25, 33)
	content.BorderSizePixel = 0
	content.Parent = main

	local contentCorner = Instance.new('UICorner')
	contentCorner.CornerRadius = UDim.new(0, 14)
	contentCorner.Parent = content

	local contentHeader = Instance.new('TextLabel')
	contentHeader.Size = UDim2.new(1, -24, 0, 28)
	contentHeader.Position = UDim2.new(0, 12, 0, 12)
	contentHeader.BackgroundTransparency = 1
	contentHeader.Text = 'Features'
	contentHeader.TextColor3 = Color3.fromRGB(240, 240, 240)
	contentHeader.Font = Enum.Font.GothamBold
	contentHeader.TextSize = 16
	contentHeader.TextXAlignment = Enum.TextXAlignment.Left
	contentHeader.Parent = content

	local contentSub = Instance.new('TextLabel')
	contentSub.Size = UDim2.new(1, -24, 0, 18)
	contentSub.Position = UDim2.new(0, 12, 0, 36)
	contentSub.BackgroundTransparency = 1
	contentSub.Text = 'Toggle modules and launch settings.'
	contentSub.TextColor3 = Color3.fromRGB(160, 170, 190)
	contentSub.Font = Enum.Font.Gotham
	contentSub.TextSize = 12
	contentSub.TextXAlignment = Enum.TextXAlignment.Left
	contentSub.Parent = content

	local contentArea = Instance.new('Frame')
	contentArea.Size = UDim2.new(1, -24, 1, -70)
	contentArea.Position = UDim2.new(0, 12, 0, 58)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = content

	local function clearChildren(frame)
		for _, child in ipairs(frame:GetChildren()) do
			if not child:IsA('UIListLayout') then
				child:Destroy()
			end
		end
	end

	local function buildFeatureList()
		clearChildren(contentArea)
		local list = Instance.new('ScrollingFrame')
		list.Size = UDim2.new(1, 0, 1, 0)
		list.BackgroundTransparency = 1
		list.ScrollBarThickness = 2
		list.AutomaticCanvasSize = Enum.AutomaticSize.Y
		list.Parent = contentArea

		local layout = Instance.new('UIListLayout')
		layout.Padding = UDim.new(0, 8)
		layout.Parent = list

		for _, featureName in ipairs(config.gui.featureOrder) do
			local enabled = config.features[featureName] ~= false
			local row = Instance.new('Frame')
			row.Size = UDim2.new(1, 0, 0, 36)
			row.BackgroundColor3 = Color3.fromRGB(26, 30, 40)
			row.BorderSizePixel = 0
			row.Parent = list

			local corner = Instance.new('UICorner')
			corner.CornerRadius = UDim.new(0, 10)
			corner.Parent = row

			local label = Instance.new('TextLabel')
			label.Size = UDim2.new(1, -92, 1, 0)
			label.Position = UDim2.new(0, 14, 0, 0)
			label.BackgroundTransparency = 1
			label.Text = featureName
			label.TextColor3 = Color3.fromRGB(242, 242, 242)
			label.Font = Enum.Font.Gotham
			label.TextSize = 13
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = row

			local toggle = Instance.new('TextButton')
			toggle.Size = UDim2.new(0, 70, 0, 24)
			toggle.Position = UDim2.new(1, -84, 0.5, -12)
			toggle.BackgroundColor3 = enabled and Color3.fromRGB(92, 195, 123) or Color3.fromRGB(168, 82, 82)
			toggle.BorderSizePixel = 0
			toggle.Text = enabled and 'ENABLED' or 'DISABLED'
			toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			toggle.Font = Enum.Font.GothamBold
			toggle.TextSize = 11
			toggle.Parent = row

			local tcorner = Instance.new('UICorner')
			tcorner.CornerRadius = UDim.new(0, 9)
			tcorner.Parent = toggle

			toggle.MouseButton1Click:Connect(function()
				config.features[featureName] = not config.features[featureName]
				toggle.Text = config.features[featureName] and 'ENABLED' or 'DISABLED'
				toggle.BackgroundColor3 = config.features[featureName] and Color3.fromRGB(92, 195, 123) or Color3.fromRGB(168, 82, 82)
			end)
		end
	end

	local function buildInfo()
		clearChildren(contentArea)
		local infoFrame = Instance.new('Frame')
		infoFrame.Size = UDim2.new(1, 0, 1, 0)
		infoFrame.BackgroundTransparency = 1
		infoFrame.Parent = contentArea

		local infoLabels = {
			('Version: %s'):format(config.name),
			('Environment: %s'):format(config.executor.name),
			('Game: %s'):format(config.game),
			('Creator ID: %s'):format(config.creator),
			('Loaded modules: %d'):format(#config.gui.featureOrder),
		}

		for index, text in ipairs(infoLabels) do
			local label = Instance.new('TextLabel')
			label.Size = UDim2.new(1, -20, 0, 26)
			label.Position = UDim2.new(0, 10, 0, (index - 1) * 32)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = Color3.fromRGB(220, 220, 255)
			label.Font = Enum.Font.Gotham
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = infoFrame
		end
	end

	local function selectTab(tabName)
		selectedTab = tabName
		for _, child in ipairs(tabContainer:GetChildren()) do
			if child:IsA('TextButton') then
				child.BackgroundColor3 = child.Name == tabName and Color3.fromRGB(88, 145, 255) or Color3.fromRGB(28, 32, 42)
				child.TextColor3 = child.Name == tabName and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
			end
		end
		contentHeader.Text = tabName
		contentSub.Text = tabName == 'Features' and 'Toggle modules and launch settings.' or 'Runtime information and executor status.'
		if tabName == 'Features' then
			buildFeatureList()
		else
			buildInfo()
		end
	end

	for tabName, display in pairs(sidebarTabs) do
		local tabButton = Instance.new('TextButton')
		tabButton.Name = tabName
		tabButton.Size = UDim2.new(1, 0, 0, 34)
		tabButton.BackgroundColor3 = tabName == selectedTab and Color3.fromRGB(88, 145, 255) or Color3.fromRGB(28, 32, 42)
		tabButton.BorderSizePixel = 0
		tabButton.Text = display
		tabButton.TextColor3 = tabName == selectedTab and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(190, 190, 210)
		tabButton.Font = Enum.Font.GothamBold
		tabButton.TextSize = 12
		tabButton.Parent = tabContainer

		local tabCorner = Instance.new('UICorner')
		tabCorner.CornerRadius = UDim.new(0, 10)
		tabCorner.Parent = tabButton

		tabButton.MouseButton1Click:Connect(function()
			selectTab(tabName)
		end)
	end

	selectTab(selectedTab)

	return screenGui
end

local function loadModuleFromRemote(moduleName, config)
	local remoteBase = 'https://raw.githubusercontent.com/ujinseong011-lab/WhaleV4-made-by-Ace/main/'
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
	name = 'Whale V4',
	creator = '381112395017410',
	creatorLabel = 'Killaura Legit',
	game = 'BedWars',
	initUrl = 'https://raw.githubusercontent.com/ujinseong011-lab/WhaleV4-made-by-Ace/main/init.lua',
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
		title = 'Whale V4',
		subtitle = 'WHALE V4',
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

if config.gui and config.gui.showFeatures ~= false then
	pcall(createGui, config)
end

local initUrl = config.initUrl or 'https://raw.githubusercontent.com/ujinseong011-lab/WhaleV4-made-by-Ace/main/init.lua'
local success, err = pcall(loadstring(game:HttpGet(initUrl, true), 'init.lua'), config)
if not success then
	warn(('Whale V4 failed to initialize: %s'):format(tostring(err)))
end

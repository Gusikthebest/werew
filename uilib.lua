local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UIComponents = {}

-- === Кнопка с анимацией нажатия ===
function UIComponents.CreateButton(text, size, position, parent)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0, 140, 0, 40)
    btn.Position = position or UDim2.new(0, 0, 0, 0)
    btn.Text = text or "Button"
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.fromRGB(120, 60, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 12)

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 180, 255)}):Play()
        local oldText = btn.Text
        btn.Text = "Clicked!"
        task.wait(0.3)
        btn.Text = oldText
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)

    return btn
end

-- === Дропдаун с опциями ===
function UIComponents.CreateDropdown(options, size, position, parent)
    local dropdown = Instance.new("TextButton")
    dropdown.Size = size or UDim2.new(0, 140, 0, 40)
    dropdown.Position = position or UDim2.new(0, 0, 0, 0)
    dropdown.Text = (options[1] or "Select") .. " ▼"
    dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dropdown.TextColor3 = Color3.fromRGB(120, 60, 200)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 18
    dropdown.BorderSizePixel = 0
    dropdown.AutoButtonColor = false
    dropdown.Parent = parent

    local corner = Instance.new("UICorner", dropdown)
    corner.CornerRadius = UDim.new(0, 12)

    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0, dropdown.Size.X.Offset, 0, #options * 36)
    dropdownList.Position = UDim2.new(0, 0, 1, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(240, 220, 255)
    dropdownList.Visible = false
    dropdownList.BorderSizePixel = 0
    dropdownList.ZIndex = dropdown.ZIndex + 1
    dropdownList.Parent = dropdown

    local listCorner = Instance.new("UICorner", dropdownList)
    listCorner.CornerRadius = UDim.new(0, 12)

    local buttons = {}
    for i, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.Position = UDim2.new(0, 0, 0, (i-1)*36)
        btn.Text = option
        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        btn.TextColor3 = Color3.fromRGB(120, 60, 200)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 18
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = dropdownList
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 10)

        btn.MouseButton1Click:Connect(function()
            dropdown.Text = btn.Text .. " ▼"
            dropdownList.Visible = false
            if dropdown._onSelectionChanged then
                dropdown._onSelectionChanged(btn.Text)
            end
        end)
        table.insert(buttons, btn)
    end

    dropdown.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)

    -- Получить выбранный элемент
    function dropdown:GetSelection()
        return self.Text:gsub(" ▼$", "")
    end

    -- Подключить обработчик изменения выбора
    function dropdown:ConnectSelectionChanged(callback)
        self._onSelectionChanged = callback
    end

    return dropdown
end

-- === Табы с переключением ===
function UIComponents.CreateTabs(names, size, position, parent)
    local container = Instance.new("Frame")
    container.Size = size or UDim2.new(0, 300, 0, 40)
    container.Position = position or UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local tabs = {}
    container._activeIndex = 1 -- теперь это поле контейнера

    local tabWidth = (container.Size.X.Offset - (#names - 1) * 10) / #names

    local function setActive(index)
        container._activeIndex = index -- обновляем поле контейнера
        for i, tab in ipairs(tabs) do
            tab.BackgroundColor3 = (i == index) and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,140,255)
            tab.TextColor3 = (i == index) and Color3.fromRGB(120,60,200) or Color3.fromRGB(255,255,255)
        end
        if container._onTabChanged then
            container._onTabChanged(container._activeIndex)
        end
    end

    for i, name in ipairs(names) do
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(0, tabWidth, 1, 0)
        tab.Position = UDim2.new(0, (tabWidth + 10) * (i - 1), 0, 0)
        tab.Text = name
        tab.BackgroundColor3 = (i == container._activeIndex) and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,140,255)
        tab.TextColor3 = (i == container._activeIndex) and Color3.fromRGB(120,60,200) or Color3.fromRGB(255,255,255)
        tab.Font = Enum.Font.GothamBold
        tab.TextSize = 22
        tab.BorderSizePixel = 0
        tab.AutoButtonColor = false
        tab.Parent = container

        local corner = Instance.new("UICorner", tab)
        corner.CornerRadius = UDim.new(0, 16)

        tab.MouseEnter:Connect(function()
            if container._activeIndex ~= i then
                TweenService:Create(tab, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220,180,255)}):Play()
            end
        end)
        tab.MouseLeave:Connect(function()
            if container._activeIndex ~= i then
                TweenService:Create(tab, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180,140,255)}):Play()
            end
        end)

        tab.MouseButton1Click:Connect(function()
            setActive(i)
        end)

        table.insert(tabs, tab)
    end

    function container:GetActiveTab()
        return container._activeIndex -- теперь это поле контейнера
    end

    function container:ConnectTabChanged(callback)
        self._onTabChanged = callback
    end

    return container, tabs
end

-- === Слайдер простой (горизонтальный) ===
function UIComponents.CreateSlider(size, position, parent)
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = size or UDim2.new(0, 140, 0, 10)
    sliderBar.Position = position or UDim2.new(0, 0, 0, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = parent

    local sliderBarCorner = Instance.new("UICorner", sliderBar)
    sliderBarCorner.CornerRadius = UDim.new(0, 5)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar

    local sliderFillCorner = Instance.new("UICorner", sliderFill)
    sliderFillCorner.CornerRadius = UDim.new(0, 5)

    local dragging = false
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            TweenService:Create(sliderFill, TweenInfo.new(0.08), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
            if sliderBar._onValueChanged then
                sliderBar._onValueChanged(rel)
            end
        end
    end)

    function sliderBar:GetValue()
        return sliderFill.Size.X.Scale
    end

    function sliderBar:SetValue(value)
        value = math.clamp(value, 0, 1)
        sliderFill.Size = UDim2.new(value, 0, 1, 0)
    end

    function sliderBar:ConnectValueChanged(callback)
        sliderBar._onValueChanged = callback
    end

    return sliderBar
end

-- В дальнейшем можно добавить сюда другие элементы (input box, bind button и т.п.)

return UIComponents

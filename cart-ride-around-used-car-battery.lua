local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local ws = 16
local jp = 50

getgenv().infjump = false
getgenv().collectcoins = false

getgenv().goforward = false
getgenv().gobackwards = false
getgenv().stopCarts = false
getgenv().spamspawn = false
getgenv().bombtoo = false
getgenv().lightCarts = false
getgenv().god = false

local sgui = game:GetService("StarterGui")
local function notify(title, text, dur, cb)
    sgui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = dur,
        Callback = (cb or function() end)
    })
end

local function checkChar()
    if player.Character and player.Character.Parent ~= nil and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health >= 0 then
        return true
    else
        return false
    end
end

local function getChar()
    if not checkChar() then
        repeat
            wait()
        until checkChar()
    end
    return player.Character
end

player.CharacterAdded:Connect(function(chr)
    repeat wait() until checkChar()
    chr.Humanoid.WalkSpeed = ws
    chr.Humanoid.JumpHeight = jp
end)

local teleports = {
    ["end"] = CFrame.new(-609.7262573242188, 161.86300659179688, 672.3294677734375),
    ["spawn"] = CFrame.new(-14.102514266967773, 4.224838733673096, 16.123300552368164),
    ["pitstop"] = CFrame.new(-51.36717224121094, 75.53684997558594, 933.265625),
    ["shop"] = CFrame.new(194.48008728027344, 3.2248406410217285, -69.8447036743164)
}

local function tp(where)
    task.spawn(function()
        getChar().HumanoidRootPart.CFrame = teleports[where]
    end)
end

local function tpToSpawn()
    tp("spawn")
end

local function tpToEnd()
    tp("end")
end

local function tpToPitStop()
    tp("pitstop")
end

local function tpToShop()
    tp("shop")
end

local function infiniteJump()
    task.spawn(function()
        local a = uis.InputBegan:Connect(function(inp)
            if inp.KeyCode == Enum.KeyCode.Space then
                getChar().Humanoid:ChangeState(3)
            end 
        end)
        repeat wait() until not getgenv().infjump
        a:Disconnect()
    end)
end

local function collectCoins()
    task.spawn(function()
        while getgenv().collectcoins do
            for i,v in pairs(workspace.coinspawner:GetDescendants()) do
                if v.Name == "TouchInterest" and v.Parent and v.Parent.Parent and v.Parent.Parent:IsA("Tool") then
                    firetouchinterest(getChar().Head, v.Parent, 0)
                end
                wait()
            end
            wait(.3)
            local currtool = getChar():FindFirstChildOfClass("Tool")
            if currtool and string.lower(currtool.Name):find("coin") then
                currtool:Activate()
            end
            wait(.5)
            for i,v in pairs(player.Backpack:GetChildren()) do
                if v.Parent ~= nil and v:IsA("Tool") and string.lower(v.Name):find("coin") then
                    getChar().Humanoid:EquipTool(v)
                    wait(.3)
                    v:Activate()
                end
                wait(.3)
            end
            wait(3)
        end 
    end)
end

local function getTools()
    task.spawn(function()
        local hrp = getChar().HumanoidRootPart
        local pos = hrp.CFrame
        local giver = workspace:FindFirstChild("Giver")
        firetouchinterest(hrp, giver, 0)
        wait()
        firetouchinterest(hrp, giver, 1)
        repeat wait() until (hrp.Position - Vector3.new(-494.5295715332031, 181.86376953125, 589.2139282226562)).Magnitude < 3
        hrp.CFrame = pos
    end)
end

local function goForward()
    task.spawn(function()
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name:lower():find("cart") and v:FindFirstChild("forward") and v.forward:FindFirstChild("ClickDetector") then
                fireclickdetector(v.forward.ClickDetector)
            end
        end
    end)
end

local function goBackwards()
    task.spawn(function()
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name:lower():find("cart") and v:FindFirstChild("backward") and v.backward:FindFirstChild("ClickDetector") then
                fireclickdetector(v.backward.ClickDetector)
            end
        end
    end)
end

local function stopCarts()
    task.spawn(function()
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name:lower():find("cart") and v:FindFirstChild("stop") and v.stop:FindFirstChild("ClickDetector") then
                fireclickdetector(v.stop.ClickDetector)
            end
        end
    end)
end

local function lightCarts()
    task.spawn(function()
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name:lower():find("cart") and v:FindFirstChild("lightbutton") and v.lightbutton:FindFirstChild("ClickDetector") then
                fireclickdetector(v.lightbutton.ClickDetector)
            end
        end
    end)
end
local function god()
    task.spawn(function()
        local s
        notify("God toggled", "God has been toggled. For some reason looping through everything requires about 30 seconds to complete.", 3)
        while getgenv().god do
            for _,v in pairs(workspace:GetChildren()) do
                if v.Name == "ElectrifiedRail" or v.Name == "garrote wire" or v.Name == "railspawner" or v.Name == "spring gun" or v.Name == "Pendulum" then
                    repeat s = v:FindFirstChild("TouchInterest", true); if s then s:Destroy() end until not v:FindFirstChild("TouchInterest", true)
                end
                wait()
            end
            wait(2.5)
        end
    end)
end

local function spawnCarts()
    task.spawn(function()
        for _,v in pairs(workspace:GetChildren()) do
            if v.Name == "respawner" or v.Name == "rustyrespawner" or (getgenv().bombtoo and v.Name == "bombrespawnerply") then
                firetouchinterest(getChar().HumanoidRootPart, v.respawn, 0)
                wait(0.05)
                firetouchinterest(getChar().HumanoidRootPart, v.respawn, 1)
            end
        end
    end)
end

task.spawn(function()
    wait()
    local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
    local venyx = lib.new("cart ride")
    local mainPage = venyx:addPage("Main")

    local guiSection = mainPage:addSection("UI")
    local playerSection = mainPage:addSection("Player")
    local teleportSection = mainPage:addSection("Teleports")

    teleportSection:addButton("Teleport to End", tpToEnd)
    teleportSection:addButton("Teleport to Shop", tpToShop)
    teleportSection:addButton("Teleport to Spawn", tpToSpawn)
    teleportSection:addButton("Teleport to Pit stop", tpToPitStop)

    guiSection:addKeybind("Toggle menu", Enum.KeyCode.G, function()
        venyx:toggle()
    end)

    playerSection:addSlider("Walkspeed", 16, 0, 250, function(val, update)
        ws = val
        getChar().Humanoid.WalkSpeed = val
    end)
    playerSection:addSlider("Jumpheight", 7.2, 0, 250, function(val, update)
        jp = val
        getChar().Humanoid.JumpHeight = val
    end)

    playerSection:addToggle("Infinite jumps", false, function(val, update)
        getgenv().infjump = val
        if val then
            infiniteJump()
        end
    end)
    playerSection:addToggle("God mode", false, function(val, update)
        getgenv().god = val
        if val then
            god()
        end
    end)


    local miscPage = venyx:addPage("Misc")
    local farmSection = miscPage:addSection("Farm")
    local usefulSection = miscPage:addSection("Useful")

    farmSection:addToggle("Collect coins", false, function(val, update)
        getgenv().collectcoins = val
        if val then
            collectCoins()
        end
    end)

    usefulSection:addButton("Get tools", function()
        getTools()
    end)

    local trollPage = venyx:addPage("Troll")
    local cartSection = trollPage:addSection("Cart")

    cartSection:addButton("Carts go forward", function()
        goForward()
    end)
    cartSection:addToggle("Spam carts go forward", false, function(val, update)
        getgenv().goforward = val
        if val then
            task.spawn(function()
                while getgenv().goforward do
                    goForward()
                    wait(.001)
                end
            end)
        end
    end)
    cartSection:addButton("Carts go backwards", function()
        goBackwards()
    end)
    cartSection:addToggle("Spam carts go backwards", false, function(val, update)
        getgenv().gobackwards = val
        if val then
            task.spawn(function()
                while getgenv().gobackwards do
                    goBackwards()
                    wait(.001)
                end
            end)
        end
    end)
    cartSection:addButton("Stop carts", function()
        stopCarts()
    end)
    cartSection:addToggle("Spam stop carts", false, function(val, update)
        getgenv().stopCarts = val
        if val then
            task.spawn(function()
                while getgenv().stopCarts do
                    stopCarts()
                    wait(.001)
                end
            end)
        end
    end)

    cartSection:addButton("Lights", function()
        lightCarts()
    end)
    cartSection:addToggle("Spam lights", false, function(val, update)
        getgenv().lightCarts = val
        if val then
            task.spawn(function()
                while getgenv().lightCarts do
                    lightCarts()
                    wait(.001)
                end
            end)
        end
    end)

    cartSection:addToggle("Spawn bomb carts too?", false, function(val, update)
        getgenv().bombtoo = val
    end)
    cartSection:addButton("Spawn carts", function()
        spawnCarts()
    end)
    cartSection:addToggle("Spam spawn carts", false, function(val, update)
        getgenv().spamspawn = val
        if val then
            task.spawn(function()
                while getgenv().spamspawn do
                    spawnCarts()
                    wait(.001)
                end
            end)
        end
    end)

    venyx:setTheme("DarkContrast", Color3.fromRGB(14, 14, 14))
    venyx:SelectPage(venyx.pages[1], true)
end)
if not fireclickdetector or not firetouchinterest or not getgenv then
    notify("Not supported", "Your exploit is not supported.", 5)
end

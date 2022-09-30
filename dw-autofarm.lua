-------------------------LOCAL VARs----------------------
--[[ Headers courtesy of Aidez from v3r]]
if game.GameId == 0 then
    game:GetPropertyChangedSignal("GameId"):Wait()
end
if game.GameId ~= 1775919872 then
    return
end
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local Players = game:GetService("Players")
Player = Players.LocalPlayer
if Player == nil then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    Player = Players.LocalPlayer
end
local Packer = Player:WaitForChild("Packer")
local Client = require(Packer:WaitForChild("Client"))
local Database = Packer:WaitForChild("Database")
local DoodleInfo = require(Database:WaitForChild("DoodleInfo"))
local Skins = require(Database:WaitForChild("Skins")).Sprites
--local Tints = require(Database:WaitForChild("MiscDB")).Tints
--local Equipment = getupvalues(require(Database:WaitForChild("Equipment")).LookUp)[1]
--local id = Player.Name
--[[ End of Headers ]] 




---------------------------ENVIRONMENT VARs----------------------
local function reset_all()
    getgenv().in_battle = false
    getgenv().run_button_free = true
    getgenv().doodle_healed = false
    getgenv().encounter_requested = false 
    getgenv().autoFarm = false
    getgenv().socialFarm = false
    getgenv().initial_request = true
    getgenv().pause_on_tint = false
    getgenv().pause_on_shiny = false
    getgenv().pause_on_skin = false
    getgenv().pause_on_anyskin = false
    getgenv().pause_on_targetskin = false 
    getgenv().pause_on_stars = false
    getgenv().pause_on_trait = false
    getgenv().pause_on_anytrait = false
    getgenv().pause_ht = false
    getgenv().pause_on_smht = false 
    getgenv().pause_on_sm = false
    getgenv().build_chain = false
    getgenv().chain_booster = false
    getgenv().targetdoodle = ""
    getgenv().encounter_type = ""
    getgenv().desired_stars = 0 
    getgenv().doodle_shiny = false
    getgenv().doodle_tint = false
    getgenv().doodle_ht = false 
    getgenv().doodle_smht = false
    getgenv().doodle_sm = false
    getgenv().targetskin = ""
    getgenv().doodle_has_skin = false
    getgenv().doodle_has_targetskin = false
    getgenv().doodle_stars = false
    getgenv().doodle_kill = true 
    getgenv().Trainer = "Riley"
end
--[[ Miscellaneous Functions ]] --


reset_all()






-------------------------Fast Forward (Aidez) -------------
 
Client.Utilities.Halt = function(ToWait)
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainGui") and 
       game.Players.LocalPlayer.PlayerGui.MainGui:FindFirstChild("MainBattle") and 
       game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.Visible == true then
            task.wait()
        return
    else
        if ToWait == nil then
           ToWait = 0.03
        end
        task.wait(ToWait)
        return
    end
end
-------------------------Blank Diagonal---------------------------
local Enabled=true
local RebattlerFarm = true
local FastForward = true 
local Client = require(game:GetService("Players").LocalPlayer.Packer.Client)
Client.Gui.DiagonalBlackscreen = function()
    if not Enabled and not RebattlerFarm or not FastForward then
        local Frame = Client.Utilities:Create("Frame")({
            Size = UDim2.new(0, 0, 0, 0), 
            Position = UDim2.new(0, 0, 0, -36), 
            BorderSizePixel = 0, 
            BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
            Rotation = -45, 
            Visible = true, 
            ZIndex = 3
        })
        Frame.Parent = Client.guiholder
        Frame:TweenSizeAndPosition(UDim2.new(3.2, 0, 3.2, 36), UDim2.new(-1.6, 0, -0.1, -36), "Out", "Quad", 1)
        task.wait(1)
        local Blackscren = Player.PlayerGui:WaitForChild("MainGui"):WaitForChild("Blackscreen")
        Blackscren.BackgroundTransparency = 0
        Blackscren.Visible = true
        Frame:Destroy()
    else
        local Blackscren = Player.PlayerGui:WaitForChild("MainGui"):WaitForChild("Blackscreen")
        Blackscren.BackgroundTransparency = 0
        Blackscren.Visible = true
    end
end
-------------------------Teleport by Aidez -----------------------
local function ChangeLocation(final_destination,Location)
    print("Inside the teleport function.")
    local CurrentChunk = Client.DataManager.RegionData.ChunkName or Client.DataManager.RegionData.Reference
    if CurrentChunk ~= Location then 
        if Player.Character == nil or not Player.Character:FindFirstChild("HumanoidRootPart") then
            
            error() -- LOL
        end
        Player.Character.HumanoidRootPart.Anchored = true
        -- Client.Network:post("PlayerData","LoadLocation")
        task.wait(0.1)
        Client.Overworld.ChunkFuncs:UpdateCurrentChunk(Location)
        task.wait(0.1)
        if Client.CurrentChunk then
            Client.CurrentChunk:Destroy()
        end
        Client.CurrentNPCs = {}
        Client.NPC:SetLoadFalse()
        local Chunk,Data = Client.Network:get("RequestChunk",Location,CFrame.new(0,0,0),Location)
        task.wait(0.1)
        Client.DataManager.RegionData = Data
        Client.CurrentChunk = Chunk.Map:Clone()
        Client.CurrentChunk.Parent = workspace
        if Client.pgui:FindFirstChild("ChunkRequest") then
            Client.Network:post("DeleteMap", Chunk.Folder)
            task.wait(0.1)
        end
        
        
        -- Client.Network:post("ChangeChunk")
        task.wait(0.1)
        -- Client.Network:post("PlayerData","ToggleBusy",false)
        task.wait(0.1)
        if Client.CurrentChunk:FindFirstChild("Entrance") then
            Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Entrance.CFrame
        elseif Client.CurrentChunk:FindFirstChild("RouteSign") and Client.CurrentChunk.RouteSign:FindFirstChild("Signage") then
            Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.RouteSign.Signage.CFrame
        elseif Client.Network:get("RequestChunkInfo",Location).Entrance ~= nil then
            Player.Character.HumanoidRootPart.CFrame = Client.Network:get("RequestChunkInfo",Location).Entrance
        else
            error()
        end


        Client.Network:post("PlayerData","Unanchor",false)
        task.wait(0.1)
        game.Workspace.TargetFilter.MapParts:ClearAllChildren()
        if Client.CurrentChunk:FindFirstChild("InvisWalls") then
            Client.CurrentChunk.InvisWalls.Parent = workspace.TargetFilter.MapParts
        end
        if Client.CurrentChunk:FindFirstChild("Water") then
            for i,v in pairs(Client.CurrentChunk.Water:GetChildren()) do
                game.Workspace.Terrain:FillBlock(v.CFrame, v.Size, Enum.Material.Water)
                v:Destroy()
            end
        end
        Client.CurrentChunk = Client.CurrentChunk
        Client.CurrentDoors = nil
        if Client.CurrentChunk:FindFirstChild("Doors") then
            Client.CurrentDoors = Client.CurrentChunk.Doors
        end
        if Client.CurrentChunk:FindFirstChild("AutoOpen") then
            for i,v in pairs(Client.CurrentChunk.AutoOpen:GetChildren()) do
                Client.GeometryInfo.AutomaticDoorOpen(v, v:FindFirstChild("AutoOpen").Value)
            end
        end
        if Client.CurrentChunk:FindFirstChild("Temporary") then
            for i,v in pairs(Client.CurrentChunk.Temporary:GetChildren()) do
                v:Destroy()
            end
        end
    end


    if final_destination == "Route1" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.Route1Teleport.CFrame
    end
    if final_destination == "Route2" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.Route2Entrance.CFrame
    end
    if final_destination == "Lakewood" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.ToLakewood.CFrame
    end
    if final_destination == "Sewer" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.SewerEntrance.CFrame
    end
    if final_destination == "Route3" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.Route3Exit.CFrame
    end
    if final_destination == "Route4" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.Route4Exit.CFrame
    end
    if final_destination == "GraphiteLodge" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.ToGraphite.CFrame
    end
    if final_destination == "Crossroads" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.ToCrossroads.CFrame
    end
    if final_destination == "CrystalCaverns" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.ToCaverns.CFrame
    end
    if final_destination == "GraphiteForest" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.ToForest.CFrame
    end
    if final_destination == "ForestMaze" then 
        --Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.NPC.Bodybuilder.HumanoidRootPart.CFrame
    end
    if final_destination == "Route5" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.ToRoute5.CFrame
    end
    if final_destination == "Sweetsville" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.ToTown.CFrame
    end
    if final_destination == "ChefsValley" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.SweetsvilleSubway.CFrame
    end
    if final_destination == "CandyFactory" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.Doors.ToFactory.CFrame
    end
    if final_destination == "Route6" then 
        Player.Character.HumanoidRootPart.CFrame = Client.CurrentChunk.ToRoute6.CFrame
    end
end


-----------------------------ANTI AFK-----------------------------
 
local VirtualUser=game:service'VirtualUser'
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
end)


------------------------------GUI--------------------------------


local VLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vep1032/VepStuff/main/Rgb%20Ui"))()


MAINTTL = "AnonValAidez"


local win = VLib:Window("Doodle World", Color3.fromRGB(196, 40, 28))


local mainTab = win:Tab("MAIN")
local settingsTab = win:Tab("FARM SETTINGS")
local teleportTab = win:Tab("TELEPORT")
local miscTab = win:Tab("MISCELLANEOUS")
local creditsTab = win:Tab("CREDITS")


mainTab:Toggle("Autofarm",function(t)
    getgenv().autoFarm = t
    print("autofarm toggled")
    if t == true then 
        AutoFarmDoods()
    else 
        reset_all()
    end
end)


mainTab:Toggle("Trainer Farm",function(t)
    getgenv().trainerFarm = t
    print("Trainer Farm toggled")
    AutoTrainerFarm()
end)


mainTab:Dropdown("Trainer",{
    "Riley - Crossroads",
    "Ryan - Sweetsville"
},function(t)
    getgenv().Trainer = t
end)

mainTab:Button("Reset All Settings",function()
    reset_all()    
    print("All settings have been reset.")
end)

settingsTab:Dropdown("Target Doodle", {
    "Angerler",
    "Appluff",
    "Apurrition",
    "Archuma",
    "Aspark",
    "Borbo",
    "Bunsweet",
    "Candeigon",
    "Coalt",
    "Cocosquid",
    "Crystik",
    "Dramask",
    "Eftue",
    "Faunsprout",
    "Flittum",
    "Geckgoo",
    "Gemin",
    "Glimmew",
    "Glummish",
    "Grimsugar",
    "Indigoo",
    "Kelpie",
    "Klydaskunk",
    "Larvennae",
    "Leapo",
    "Lilbulb",
    "Maelzuri",
    "Maskrow",
    "Meltimaw",
    "Mold",
    "Moss",
    "Muttish",
    "Muncheez",
    "Nibblen",
    "Pandishi",
    "Partybug",
    "Pebblett",
    "Plipo",
    "Riffrat",
    "Rosebug",
    "Ruffire",
    "Schiwi",
    "Shmellow",
    "Slibble",
    "Snobat",
    "Springling",
    "Squed",
    "Squelly",
    "Squonk",
    "Staligant",
    "Statikeet",
    "Tadappole",
    "Tortles",
    "Wiglet",
    "Wisp",
    "Yagoat"
},function(t)
    getgenv().targetdoodle = t
    print("Target selected is: "..targetdoodle)
end)


settingsTab:Dropdown("Encounter",{
    "CaveWater",
    "CoveGrass",
    "Lake",
    "Sewer",
    "WaterGrass",
    "WildGrass",
    "VPDoodleFight"
},function(t)
    getgenv().encounter_type = t
    print("Encounter selected is: "..encounter_type)
end)


settingsTab:Toggle("Build Chain",function(t)
    getgenv().build_chain = t
    print("Build Chain toggled: "..tostring(t))
end)
 
settingsTab:Toggle("Chain Booster",function(t)
    getgenv().chain_booster = t
    print("Chain Booster toggled: "..tostring(t))
end)


settingsTab:Toggle("Hunt for 6MHTs",function(t)
    getgenv().pause_on_smht = t
    print("Hunt 6MHTs toggled: "..tostring(t))
end)


settingsTab:Toggle("Hunt for 6Ms",function(t)
    getgenv().pause_on_sm = t
    print("Hunt 6Ms toggled: "..tostring(t))
end)


settingsTab:Toggle("Pause on Stars",function(t)
    getgenv().pause_on_stars = t
    print("Pause on Stars toggled: "..tostring(t))
end)


settingsTab:Slider("Minimum Stars",0,6,false,function(t)
    getgenv().desired_stars = t 
    print("Desired Minimum Stars: "..t)
end)


settingsTab:Toggle("Pause on Tint",function(t)
    getgenv().pause_on_tint = t
    print("Pause on Tint toggled: "..tostring(t))
end)
 
settingsTab:Toggle("Pause on Shiny",function(t)
    getgenv().pause_on_shiny = t
    print("Pause on Shiny toggled: "..tostring(t))
end)
 
settingsTab:Dropdown("Pause on Skin", {
    "Nope",
    "Any Skin Will Do",
    "Target Skin Only"
},function(t)
    if t == "Nope" then 
        getgenv().pause_on_skin = false
        getgenv().pause_on_anyskin = false
        getgenv().pause_on_targetskin = false
        return
    else 
        getgenv().pause_on_skin = true
        if t == "Any Skin Will Do" then 
            getgenv().pause_on_anyskin = true
            getgenv().pause_on_targetskin = false
            return
        else
            getgenv().pause_on_anyskin = false
            getgenv().pause_on_targetskin = true
            getgenv().SkinList = {}
            for i,v in pairs(Skins[targetdoodle]) do
                table.insert(SkinList,v.Name)
            end
            settingsTab:Dropdown("Target Skin",SkinList,function(sk)
                getgenv().targetskin = sk
                print("Target Skin: "..sk)    
            end)
        end
        return
    end    
end)

--[[
settingsTab:Dropdown("Pause on Trait", {
    "Nope",
    "Any Trait Will Do",
    "Target Trait Only"
},function(t)
    if t == "Nope" then 
        getgenv().pause_on_trait = false
        getgenv().pause_on_anytrait = false
        getgenv().pause_on_targettrait = false
        return
    else 
        getgenv().pause_on_trait = true
        if t == "Any Trait Will Do" then 
            getgenv().pause_on_anytrait = true
            getgenv().pause_on_targettrait = false
            return
        else
            getgenv().pause_on_anytrait = false
            getgenv().pause_on_targettrait = true
            getgenv().TraitList = {}
            for i,v in pairs(Skins[targetdoodle]) do
                table.insert(SkinList,v.Name)
            end
            settingsTab:Dropdown("Target Trait",TraitList,function(tr)
                getgenv().targettrait = tr
                print("Target Trait: "..tr)    
            end)
        end
        return
    end    
end)]]
--Teleport--


teleportTab:Button("Route 1",function()
    
    local Loaded = pcall(ChangeLocation,"Route1","006_Route2")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Route 2",function()
    local Loaded = pcall(ChangeLocation,"Route2","007_Lakewood")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Lakewood",function()
    local Loaded = pcall(ChangeLocation,"Lakewood","010_Route3")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Sewer",function()
    local Loaded = pcall(ChangeLocation,"Sewer","007_Lakewood")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Route 3",function()
    local Loaded = pcall(ChangeLocation,"Route3","013_Route4")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Route 4",function()
    local Loaded = pcall(ChangeLocation,"Route4","014_GraphiteLodge")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Graphite Lodge",function()
    local Loaded = pcall(ChangeLocation,"GraphiteLodge","017_Crossroads")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Crossroads",function()
    local Loaded = pcall(ChangeLocation,"Crossroads","020_GraphiteForest")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("CrystalCaverns",function()
    local Loaded = pcall(ChangeLocation,"CrystalCaverns","017_Crossroads")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Graphite Forest",function()
    local Loaded = pcall(ChangeLocation,"GraphiteForest","024_Route5")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Forest Maze",function()
    local Loaded = pcall(ChangeLocation,nil,"022_ForestMaze")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Route 5",function()
    local Loaded = pcall(ChangeLocation,"Route5","025_Sweetsville")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Pirate Cabin",function()
    local Loaded = pcall(ChangeLocation,"028_PirateCabin")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Sweetsville",function()
    local Loaded = pcall(ChangeLocation,"Sweetsville","031_CandyFactory")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Candy Factory",function()
    local Loaded = pcall(ChangeLocation,"CandyFactory","025_Sweetsville")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Chef's Valley",function()
    local Loaded = pcall(ChangeLocation,"ChefsValley","025_Sweetsville")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)


teleportTab:Button("Route 6",function()
    local Loaded = pcall(ChangeLocation,"Route6","031_CandyFactory")
        if not Loaded then
            print("Teleport failed.")
        end
        print("Teleporting to: "..t)
end)




miscTab:Button("🚑💨 Heal",function() --you dont need "arg" for a button
    Client.Network:post("PlayerData","Heal","GraphiteLodge")
end)
 
miscTab:Button("Magnifying Glass🔍", function()
    game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.MagnifyingGlass.Visible = true
end)


miscTab:Button("♻ Rejoin",function()
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    local player = game.Players.LocalPlayer
    if player then
        TeleportService:Teleport(PlaceId, player)
    end
end)


miscTab:Button("Doodle Storage",function()
    if Player.PlayerGui.MainGui.PCUI.Visible == false then
        CurrentPC = Client.PC.new()
        repeat wait() until CurrentPC.PCUI ~= nil
        local Box = CurrentPC.PCUI:WaitForChild("Box")
        local Background = Box:WaitForChild("Background")
        local TopBar = Background:WaitForChild("TopBar")
        local Close = TopBar:WaitForChild("Close")
        Close.MouseButton1Click:Connect(function()
            Client.Menu.DisableBlur()
            Client.Menu:Enable()
            Client.Controls:ToggleWalk(true)
        end)
    elseif Player.PlayerGui.MainGui.PCUI.Visible == true and 
        CurrentPC ~= nil and CurrentPC.Enabled then
        Client.Sound:Play("Boop")
        Client.Menu.DisableBlur()
        Client.Menu:Enable()
        Client.Controls:ToggleWalk(true)
        CurrentPC.PCUI.Visible = false
        CurrentPC:Destroy()
        Client.PCClosed:Fire()
        Client.guiholder.Dragging:ClearAllChildren()
    end
end)


miscTab:Button("Normal Shop",function()
    local CurrentShop
    CurrentShop = Client.NormalShop.new()
    Client.ShopClosed:Wait()
    Client.Menu.DisableBlur()
    Client.Menu:Enable()
    Client.Controls:ToggleWalk(true)
    CurrentShop.NormalShop.Visible = false
    CurrentShop:Destroy()
end)


miscTab:Button("Move Relearner",function()
    CurrentMR = Client.Party.new({
            Party = Client.ClientDatabase:PDSFunc("GetParty"), 
            String = "Which Doodle should relearn a move?", 
            Picker = true
        })
    local result = Client.GlobalSignal:Wait()
    if result == "None" then
        --Client.Dialogue:SaySimple("Don't waste my time!", false, "Move Relearner");
        Client.Menu.DisableBlur()
        Client.Menu:Enable()
        Client.Controls:ToggleWalk(true)
        CurrentMR:destroy()
        return;
    end;
    local Close = Player.PlayerGui.MainGui.PartyUI.CloseBar.Cancel
    Close.MouseButton1Click:Connect(function()
        Client.Menu.DisableBlur()
        Client.Menu:Enable()
        Client.Controls:ToggleWalk(true)
    end)
    Client.MoveRelearner:Show(result)
    local result2 = Client.GlobalSignal:Wait();
    --if result2 == "NoMessage" or result2 == "None" then
        Client.Menu.DisableBlur()
        Client.Menu:Enable()
        Client.Controls:ToggleWalk(true)
        CurrentMR:destroy()
    --end
end)


creditsTab:Label("Script by AnonymousX")


creditsTab:Label("Script by Valchampsteel")


creditsTab:Label("Script by Aidez")




--------------------------------------------------------
-- AUTO FARMING BEGINS HERE
 
-----------Chain Booster ----
function chain_boost(cb)
    if cb == "on" then
        Client.Network:post("PlayerData","ToggleBooster","cb",true)
    else 
        Client.Network:post("PlayerData","ToggleBooster","cb",false)
    end 
end
------------------------PAUSE---------------------------
function manual_pause()
    
    getgenv().autoFarm = false
    getgenv().in_battle = true
 
    local on_pause = true
    while on_pause do 
        wait(2)
        print ("[manual_pause] waiting for user action ...")
        if Player.PlayerGui.MainGui.MainBattle.Visible == true or 
          Player.PlayerGui.MainGui.Stats.Visible == true then
            on_pause = true
        else
            on_pause = false
        end
    end
    return true 
    
end


--------------------------KILL--------------------------
 
function kill_dood()
    getgenv().in_battle = true
    print("[kill_dood] inside the kill function ")
    print("[kill_dood] waiting for battle screen ...") 
    local battle_window_up = game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.Visible
    repeat 
        wait()
        if Player.PlayerGui.MainGui.MainBattle.Visible == true then
            battle_window_up = true
        end
    until battle_window_up
     
    while Player.PlayerGui.MainGui.MainBattle.Visible == true do 
        if chain_booster then
            chain_boost("on")
        end
        for _, v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.Moves.Move1.MouseButton1Click)) do
            v:Fire()
        end
        print("[kill_dood] attacked dood!")
        wait(0.5)
        if chain_booster then 
            chain_boost("off")
        end
        
        print("[kill_dood] waiting to see if it needs another shot...")
        wait(0.35)
    end
     
    print("[kill_dood] the dood is dead 💀 ")
    getgenv().in_battle = false
    print("[kill_dood] waiting done. going out of kill function")
    return(true)
end
 
--------------------------RUN--------------------------
 
function go_away()
    getgenv().in_battle = true
 
    print("[go_away] inside the run function")
    print("[go_away] main battle window is visble: ")
    print(Player.PlayerGui.MainGui.MainBattle.Visible)
 
    print("[go_away] waiting to make sure main battle screen is up")    
    local battle_window_up = false
    print("[go_away] waiting for BottomBar to load ...")
    repeat 
        wait()
        if Player.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Run.Visible == true then
            battle_window_up = true
            print("[go_away] BottomBar loaded.")
        end
    until battle_window_up
    
    while Player.PlayerGui.MainGui.MainBattle.Visible == true do 
        
        for _, v in pairs(getconnections(Player.PlayerGui.MainGui.MainBattle.BottomBar.Actions.Run.MouseButton1Click)) do
            v:Fire()
        end
        print("[go_away] run button hit!")
        print("[go_away] waiting see if it has successfully run away...")
        wait(1)
    end 
 
    print("[go_away] running away ...")
    getgenv().in_battle = false
    getgenv().run_button_free = true
    return(true)
end
 
--------------------------HEAL--------------------------
 
function auto_heal()
    if in_battle or doodle_healed then
        print("[auto_heal] still in battle or already healed. not healing.")
        getgenv().doodle_healed = false
    else
        Client.Network:post("PlayerData","Heal","GraphiteLodge")
        getgenv().doodle_healed = true
        print("[auto_heal] doodles healed")
        return true
    end
end
 
 
 
------------------------- CHECK DOODLE --------------------------
 
function check_doodle()
    
    print("[check_doodle] Checking Wild Doodle. ")
 
    local battle_window_up = false -- game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.Visible
    print("[check_doodle] waiting for battle screen ...")
    repeat 
        wait()
        if Player.PlayerGui.MainGui.MainBattle.Visible == true then
            battle_window_up = true
        end
    until battle_window_up
    print("[check_doodle] battle screen is up")
 
    local EnemyDoodle = Client.Battle.CurrentBattle["Player2Party"][1]
    print("Doodle Found: "..EnemyDoodle.RealName)
    
    if  EnemyDoodle.RealName ~= targetdoodle then
        getgenv().doodle_kill = true 
        go_away()
    else
        getgenv().doodle_kill = false
        
        print("[check_doodle] target found!")
        print("[check_doodle] Doodle stars: ", EnemyDoodle.Star)
        
        if EnemyDoodle.Star == desired_stars then 
            print("[check_doodle] Doodle has desired stars! ")
            getgenv().doodle_stars = true 
        else
            getgenv().doodle_stars = false
        end
        print("[check_doodle] Doodle's Ability is:", EnemyDoodle.Ability)
        if EnemyDoodle.Ability == EnemyDoodle.Info.HiddenAbility then 
            print("[check_doodle] Doodle is HT! ")
            getgenv().doodle_ht = true 
        else
            print("[check_doodle] Doodle has a regular Ability.")
            getgenv().doodle_ht = false
        end


        if EnemyDoodle.Tint ~= 0 then
            print("[check_doodle] found Tint")
            getgenv().doodle_tint = true 
        else
            getgenv().doodle_tint = false 
        end     
        if EnemyDoodle.Shiny then
            print("[check_doodle] found Shiny")
            getgenv().doodle_shiny = true 
        else
            getgenv().doodle_shiny = false 
        end
        if EnemyDoodle.Skin == 0 then
            getgenv().doodle_has_skin = false
        else 
            print("[check_doodle] found Skin")
            getgenv().doodle_has_skin = true
            if Skins[EnemyDoodle.RealName][EnemyDoodle.Skin].Name == targetskin then
            --Player.PlayerGui.MainGui.MainBattle.DoodleFront.NewSprite.Image 
                getgenv().doodle_has_targetskin = true
            else 
                getgenv().doodle_has_targetskin = false
            end
        end 
    end
end
 
-------------------------- PERFORM THE PROPER ACTION -----------------------
function perform_act()
    print("[perform_act] inside the function")
    if not getgenv().doodle_kill then 
        if (pause_on_shiny and doodle_shiny) or 
            (pause_on_anyskin and doodle_has_skin) or 
            (pause_on_anyskin and doodle_has_targetskin) or
            (pause_on_targetskin and doodle_has_targetskin) or 
            (pause_on_tint and doodle_tint) or 
            (pause_on_stars and doodle_stars) or 
            (pause_on_sm and doodle_stars and doodle_shiny) or
            (pause_on_smht and doodle_stars and doodle_shiny and doodle_ht) or
            build_chain == false then 
                
            manual_pause()
        else 
            kill_dood() 
        end 
    end 
    
    getgenv().in_battle = false
end
 
 
 
--------------------------- REQUEST ENCOUNTER  ---------------------------
function request_encounter()
    print("[request_encounter] inside request_encounter function")
    print("[request_encounter] making sure that main battle screen is not present before proceeding with the request")
    print("[request_encounter] main battle window is visible: ")
    print(game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.Visible)
    
    local battle_window_up = game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.Visible
    repeat 
        wait()
        print("[request_encounter] waiting for battle screen to clear ...")
        if game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.Visible == false then
            battle_window_up = false
        end
    until battle_window_up == false
     
     
    if game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.Visible == false and getgenv().encounter_requested == false then
        Client.Battle.WildBattIe(nil,nil,encounter_type)
        print("[request_encounter] starting encounter ...")
        getgenv().encounter_requested = true
        getgenv().in_battle = true 
       
    end
end
 
---- AUTO FARM ----
function AutoFarmDoods()
    while getgenv().autoFarm do 
        print(" 🔴  🔴  🔴  🔴  🔴 ")
        wait(0.3)
        print(" 🟡  🟡  🟡  🟡  🟡 ")
        wait(0.3)
        print(" 🟢  🟢  🟢  🟢  🟢 ")
        wait(0.3)
     
        print(" --- ")
        print(" --- ")
        print(" --- START FARM --- ")
        print(" --- ")
        print(" --- ")
        game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.FrontBox.NameLabel.Text = ""
        request_encounter()
        check_doodle()
        perform_act() -- == false then break end
        auto_heal()
        getgenv().encounter_requested = false
        wait(3)  
    end
end 
 
function AutoTrainerFarm()
    while getgenv().trainerFarm do
        print(" 🔴  🔴  🔴  🔴  🔴 ")
        wait(0.3)
        print(" 🟡  🟡  🟡  🟡  🟡 ")
        wait(0.3)
        print(" 🟢  🟢  🟢  🟢  🟢 ")
        wait(0.3)
     
        print(" --- ")
        print(" --- ")
        print(" --- START TRAINER FARM --- ")
        print(" --- ")
        print(" --- ")
        
        print("[Auto Trainer Farm] Healing Doodles.")
        Client.Network:post("PlayerData","Heal","GraphiteLodge")
        
        local current_chunk = Client.DataManager.RegionData.ChunkName or Client.DataManager.RegionData.Reference
        print("[Auto Trainer Farm] Finding a Random Trainer ...")
        NPCs =  game.Workspace[current_chunk].NPC:GetChildren()
        if #NPCs ~= 0 then
            i_npc = math.random(1,#NPCs)
            for i,v in pairs(NPCs) do
                if i == i_npc then 
                    current_trainer = v 
                end
            end
            print("[Auto Trainer Farm] We are battling ", current_trainer)
        else
            print("[Auto Trainer Farm] There are no NPCs in the area! Move to another one.")
            break
        end
        if getgenv().Trainer == "Riley - Crossroads" then 
            Client.Battle:TrainerBattle(39,current_trainer) --Riley
        else 
            Client.Battle:TrainerBattle(68,current_trainer) --Ryan
        end
        
        kill_dood()
        print("[Auto Trainer Farm] Trainer Defeated!")
        
    end
end


------- Side GUI by AnonymousX -----------
--------------------DOODLE STORAGE--------------------


local OpenPC = Instance.new("ImageButton",game.Players.LocalPlayer.PlayerGui.MainGui)
local CurrentPC
OpenPC.Name = "OpenPC"
OpenPC.AnchorPoint = Vector2.new(1,1)
OpenPC.Position = UDim2.new(1, 0, 1, -60)
OpenPC.Size = UDim2.new(0, 50, 0, 50)
OpenPC.Image = "rbxassetid://10649026745"
OpenPC.BackgroundTransparency = 1
OpenPC.Active = false
OpenPC.MouseEnter:Connect(function()
    OpenPC.ImageColor3 = Color3.new(0.5,0.5,0.5)
end)
OpenPC.MouseLeave:Connect(function()
    OpenPC.ImageColor3 = Color3.new(1,1,1)
end)
OpenPC.MouseButton1Click:Connect(function()
    if game.Players.LocalPlayer.PlayerGui.MainGui.PCUI.Visible == false then
        CurrentPC = Client.PC.new()
        repeat wait() until CurrentPC.PCUI ~= nil
        local Box = CurrentPC.PCUI:WaitForChild("Box")
        local Background = Box:WaitForChild("Background")
        local TopBar = Background:WaitForChild("TopBar")
        local Close = TopBar:WaitForChild("Close")
        Close.MouseButton1Click:Connect(function()
            Client.Menu.DisableBlur()
            Client.Menu:Enable()
            Client.Controls:ToggleWalk(true)
        end)
    elseif game.Players.LocalPlayer.PlayerGui.MainGui.PCUI.Visible == true and CurrentPC ~= nil and CurrentPC.Enabled then
        Client.Sound:Play("Boop")
        Client.Menu.DisableBlur()
        Client.Menu:Enable()
        Client.Controls:ToggleWalk(true)
        CurrentPC.PCUI.Visible = false
        CurrentPC:Destroy()
        Client.PCClosed:Fire()
        Client.guiholder.Dragging:ClearAllChildren()
    end
end)


--------------------MOVE RELEARNER--------------------


local MRGui = Instance.new("ScreenGui")
local MoveRelearner = Instance.new("ImageButton")


MRGui.Name = "MRGui"
MRGui.Parent = game.CoreGui
MRGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


MoveRelearner.Name = "MoveRelearner"
MoveRelearner.Parent = MRGui
MoveRelearner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MoveRelearner.BackgroundTransparency = 1.000
MoveRelearner.AnchorPoint = Vector2.new(1,1)
MoveRelearner.Position = UDim2.new(1, 0, 1, -110)
MoveRelearner.Size = UDim2.new(0, 50, 0, 50)
MoveRelearner.Image = "http://www.roblox.com/asset/?id=11108305865"
MoveRelearner.MouseEnter:Connect(function()
    MoveRelearner.ImageColor3 = Color3.new(0.5,0.5,0.5)
end)
MoveRelearner.MouseLeave:Connect(function()
    MoveRelearner.ImageColor3 = Color3.new(1,1,1)
end)
MoveRelearner.MouseButton1Down:connect(function()
    CurrentMR = Client.Party.new({
            Party = Client.ClientDatabase:PDSFunc("GetParty"), 
            String = "Which Doodle should relearn a move?", 
            Picker = true
        })
    local result = Client.GlobalSignal:Wait()
    if result == "None" then
        --Client.Dialogue:SaySimple("Don't waste my time!", false, "Move Relearner");
        Client.Menu.DisableBlur()
        Client.Menu:Enable()
        Client.Controls:ToggleWalk(true)
        CurrentMR:destroy()
        return;
    end;
    local Close = Player.PlayerGui.MainGui.PartyUI.CloseBar.Cancel
    Close.MouseButton1Click:Connect(function()
        Client.Menu.DisableBlur()
        Client.Menu:Enable()
        Client.Controls:ToggleWalk(true)
    end)
    Client.MoveRelearner:Show(result)
    local result2 = Client.GlobalSignal:Wait();
    --if result2 == "NoMessage" or result2 == "None" then
        Client.Menu.DisableBlur()
        Client.Menu:Enable()
        Client.Controls:ToggleWalk(true)
        CurrentMR:destroy()
end)


--------------------NORMAL SHOP--------------------


local ShopGui = Instance.new("ScreenGui")
local Shop = Instance.new("ImageButton")


ShopGui.Name = "ShopGui"
ShopGui.Parent = game.CoreGui
ShopGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


Shop.Name = "Shop"
Shop.Parent = ShopGui
Shop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shop.BackgroundTransparency = 1.000
Shop.AnchorPoint = Vector2.new(1,1)
Shop.Position = UDim2.new(1, 0, 1, -160)
Shop.Size = UDim2.new(0, 50, 0, 50)
Shop.Image = "http://www.roblox.com/asset/?id=11108505392"
Shop.MouseEnter:Connect(function()
    Shop.ImageColor3 = Color3.new(0.5,0.5,0.5)
end)
Shop.MouseLeave:Connect(function()
    Shop.ImageColor3 = Color3.new(1,1,1)
end)
Shop.MouseButton1Down:connect(function()
    local CurrentShop
    CurrentShop = Client.NormalShop.new()
    Client.ShopClosed:Wait()
    Client.Menu.DisableBlur()
    Client.Menu:Enable()
    Client.Controls:ToggleWalk(true)
    CurrentShop.NormalShop.Visible = false
    CurrentShop:Destroy()
end)


--------------------MAGNIFYING GLASS--------------------


local MGui = Instance.new("ScreenGui")
local MagnifyingGlass = Instance.new("ImageButton")


MGui.Name = "MGui"
MGui.Parent = game.CoreGui
MGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


MagnifyingGlass.Name = "MagnifyingGlass"
MagnifyingGlass.Parent = MGui
MagnifyingGlass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MagnifyingGlass.BackgroundTransparency = 1.000
MagnifyingGlass.AnchorPoint = Vector2.new(1,1)
MagnifyingGlass.Position = UDim2.new(1, 0, 1, -210)
MagnifyingGlass.Size = UDim2.new(0, 50, 0, 50)
MagnifyingGlass.Image = "rbxassetid://9137034166"
MagnifyingGlass.MouseEnter:Connect(function()
    MagnifyingGlass.ImageColor3 = Color3.new(0.5,0.5,0.5)
end)
MagnifyingGlass.MouseLeave:Connect(function()
    MagnifyingGlass.ImageColor3 = Color3.new(1,1,1)
end)
MagnifyingGlass.MouseButton1Down:connect(function()
game.Players.LocalPlayer.PlayerGui.MainGui.MainBattle.BottomBar.MagnifyingGlass.Visible = true
end)


--------------------MANUAL HEAL--------------------


local ScreenGui = Instance.new("ScreenGui")
local FirstAid = Instance.new("ImageButton")


ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


FirstAid.Name = "FirstAid"
FirstAid.Parent = ScreenGui
FirstAid.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FirstAid.BackgroundTransparency = 1.000
FirstAid.AnchorPoint = Vector2.new(1,1)
FirstAid.Position = UDim2.new(1, 0, 1, -260)
FirstAid.Size = UDim2.new(0, 50, 0, 50)
FirstAid.Image = "http://www.roblox.com/asset/?id=11110617522"
FirstAid.MouseEnter:Connect(function()
    FirstAid.ImageColor3 = Color3.new(0.5,0.5,0.5)
end)
FirstAid.MouseLeave:Connect(function()
    FirstAid.ImageColor3 = Color3.new(1,1,1)
end)
FirstAid.MouseButton1Down:connect(function()
    Client.Network:post("PlayerData","Heal","GraphiteLodge")
end)

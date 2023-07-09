local firebaseHandler = require(game.ServerScriptService.firebaseHandler)
local PlayerService = game:GetService('Players')

function makePlayerFolder(player)
	local folder = Instance.new("Folder", player)
	folder.Name = "leaderstats"

	local fname = Instance.new("StringValue", folder)
	fname.Name = "fname"
	
	local lname = Instance.new("StringValue", folder)
	lname.Name = "lname"

	local gang = Instance.new("StringValue", folder)
	gang.Name = "gang"
	
	local inventory = Instance.new("StringValue", folder)
	inventory.Name = "inventory"

	local cred = Instance.new("NumberValue", folder)
	cred.Name = "cred"
	
	local money = Instance.new("NumberValue", folder)
	money.Name = "money"

	local safeStorage = Instance.new("Folder", folder)
	safeStorage.Name = "safeStorage"
	
	local rank = Instance.new("IntValue", folder)
	rank.Name = "rank"
	
	local bank = Instance.new("NumberValue", folder)
	bank.Name = "bank"
	
	local policeRank = Instance.new("NumberValue", folder)
	policeRank.Name = "policeRank"
	
	local hunger = Instance.new("NumberValue", folder)
	hunger.Name = "hunger"
	
	local jailTime = Instance.new("NumberValue", folder)
	jailTime.Name = "jailTime"

	local safe = Instance.new("StringValue", folder)
	safe.Name = 'safe'

	return folder
end

function playerJoined(player)
	makePlayerFolder(player)

	-- IMPORT DATA FROM FIREBASE TO PHYSICAL GAME DATA WHEN THE PLAYER JOINS THE GAME
	local data = firebaseHandler.returnPlayerData(player.UserId)
	if data ~= "no data" then
		player.leaderstats.fname.Value = data["fname"]
		player.leaderstats.lname.Value = data["lname"]
		player.leaderstats.gang.Value = data["gang"]
		player.leaderstats.cred.Value = data["cred"]
		player.leaderstats.money.Value = data["money"]
		player.leaderstats.rank.Value = data["rank"]
		player.leaderstats.bank.Value = data["bank"]
		player.leaderstats.policeRank.Value = data["policeRank"]
		player.leaderstats.hunger.Value = data["hunger"]
		player.leaderstats.jailTime.Value = data["jailTime"]
		player.leaderstats.inventory.Value = data["inventory"]
		player.leaderstats.safe.Value = data["safe"] or ""
	else
		local data2 = firebaseHandler.returnPlayerData(player.UserId)
		wait(2)
		if(data2 ~= "no data") then
			player.leaderstats.fname.Value = data["fname"]
			player.leaderstats.lname.Value = data["lname"]
			player.leaderstats.gang.Value = data["gang"]
			player.leaderstats.cred.Value = data["cred"]
			player.leaderstats.money.Value = data["money"]
			player.leaderstats.rank.Value = data["rank"]
			player.leaderstats.bank.Value = data["bank"]
			player.leaderstats.policeRank.Value = data["policeRank"]
			player.leaderstats.hunger.Value = data["hunger"]
			player.leaderstats.jailTime.Value = data["jailTime"]
			player.leaderstats.inventory.Value = data["inventory"]
			player.leaderstats.safe.Value = data["safe"] or ""
		else
			-- DEFAULT DATA FOR NEW PLAYERS
			player.leaderstats.gang.Value = "Unaffiliated"
			player.leaderstats.money.Value = 500
			player.leaderstats.cred.Value = 0
			player.leaderstats.rank.Value = -1
			player.leaderstats.bank.Value = 0
			player.leaderstats.policeRank.Value = 0
			player.leaderstats.hunger.Value = 97
			player.leaderstats.jailTime.Value = 0
			player.leaderstats.inventory.value = ""
			player.leaderstats.safe.Value = ""
		end
	end
	
	player.CharacterRemoving:Connect(function(character)
		local tool = character:FindFirstChildOfClass('Tool')
		if(tool and tool.Name ~= 'Handcuffs' and tool.Name ~= 'Broom') then
			tool.Parent = PlayerService:GetPlayerFromCharacter(character).Backpack
		end
	end)
	
end

local function joinTable(names, character)
	local filteredNames = {}
	for _, name in ipairs(names) do
		if name ~= nil or name == "" then
			table.insert(filteredNames, name)
		end
	end
	return table.concat(filteredNames, character)
end

function playerLeaving(player)
	
	local playerBackpack = {}
	
	local reallyLoaded = player:FindFirstChild("ReallyLoaded")
	
	if(reallyLoaded) then
		for _,tool in pairs(player.Backpack:GetChildren()) do
			if(tool.Name == 'Handcuffs'  or tool.Name == 'Broom') then continue end
			table.insert(playerBackpack, tool.Name)
		end
		
		local backpackString = joinTable(playerBackpack, ';')
		
		local dataFolder = player.leaderstats:Clone()
		firebaseHandler.postPlayerData(player.UserId, dataFolder, backpackString) -- POST THE DATA TO FIREBASE
	end
end

game.Players.PlayerAdded:Connect(playerJoined)
game.Players.PlayerRemoving:Connect(playerLeaving)

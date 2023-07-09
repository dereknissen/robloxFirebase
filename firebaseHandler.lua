local module = {}

playerService = game:GetService("Players")

module.http = game:GetService("HttpService")
module.url = "######################" -- FOR DEMONSTRATION PURPOSES
module.auth = "######################" -- FOR DEMONSTRATION PURPOSES
module.put = "?x-http-method-override=PUT"
module.get = "?x-http-method-override=GET"

function module.returnPlayerData(userId)
	local player = game.Players:FindFirstChild(playerService:GetNameFromUserIdAsync(userId))
	local fullPath = module.url..tostring(player.UserId)..".json"..module.get.."&auth="..module.auth
	local data = module.http:JSONDecode(module.http:GetAsync(fullPath))
	
	if data then
		return data
	else
		return "no data"
	end
	
end

function module.postPlayerData(userId, dataFolder, backpackString)
	local data = {}
	if dataFolder then
		data["fname"] = dataFolder.fname.Value
		data["lname"] = dataFolder.lname.Value
		data["cred"] = dataFolder.cred.Value
		data["gang"] = dataFolder.gang.Value
		data["money"] = dataFolder.money.Value
		data["rank"] = dataFolder.rank.Value
		data["bank"] = dataFolder.bank.Value
		data["policeRank"] = dataFolder.policeRank.Value
		data["hunger"] = dataFolder.hunger.Value
		data["jailTime"] = dataFolder.jailTime.Value
		data["inventory"] = backpackString
		data["safe"] = dataFolder.safe.Value
	else
		local player = game.Players:FindFirstChild(playerService:GetNameFromUserIdAsync(userId))
		data["fname"] = player.leaderstats.fname.Value
		data["lname"] = player.leaderstats.lname.Value
		data["cred"] = player.leaderstats.cred.Value
		data["gang"] = player.leaderstats.gang.Value
		data["money"] = player.leaderstats.money.Value
		data["rank"] = dataFolder.rank.Value
		data["bank"] = player.leaderstats.bank.Value
		data["policeRank"] = player.leaderstats.policeRank.Value
		data["hunger"] = player.leaderstats.hunger.Value
		data["jailTime"] = player.leaderstats.jailTime.Value
		data["inventory"] = backpackString
		data["safe"] = player.leaderstats.safe.Value
	end
	local key = tostring(userId)
	local fullPath = tostring(module.url..key..".json"..module.put.."&auth="..module.auth)
	module.http:PostAsync(fullPath, module.http:JSONEncode(data))
end



return module

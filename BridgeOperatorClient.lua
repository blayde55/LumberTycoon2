local downTime = script.Parent.Parent.DownTime

local NPCModule = require(game.ServerScriptService.NPCDialog.NPCList)

NPCModule:AddNPC(script.Parent.Seranok, function(player, chatSelection)	
		
	if chatSelection == "ConfirmPurchase" then

		local success = game.ReplicatedStorage.Transactions.ServerToServer.AttemptPurchase:Invoke(player, 100)
		if success then
			local thx = script.Parent.Seranok.Dialog.BridgeUp.Dialog.ConfirmPurchase.ItWorked.Thanks
			if downTime.Value <= 0 then
				if checkForEye() then
					downTime.GoSpooky.Value = true
					thx = script.Parent.Seranok.Dialog.BridgeUp.Dialog.ConfirmPurchase.ItWorked.Thanks2
					downTime.Value = downTime.Value + 1.5 * 60
				else
					downTime.GoSpooky.Value = false
				end
			end
			
			downTime.Value = downTime.Value + 30 * 60
			
			return thx
		else
			return script.Parent.Seranok.Dialog.BridgeUp.Dialog.ConfirmPurchase.NotWorked.NoThanks
		end
		
	elseif chatSelection == "Initiate" then
		
		if downTime.Value > 0 then
			return script.Parent.Seranok.Dialog.BridgeDown.Dialog
		else
			return script.Parent.Seranok.Dialog.BridgeUp.Dialog
		end
		
	elseif chatSelection == "InquireTime" then
	
		local minutes = math.floor(downTime.Value / 60)
		local seconds = downTime.Value % 60
		if minutes > 0 then
			script.Parent.Seranok.Dialog.BridgeDown.Dialog.InquireTime.ResponseDialog = minutes.." minutes and "..seconds.." seconds."
		else
			script.Parent.Seranok.Dialog.BridgeDown.Dialog.InquireTime.ResponseDialog = seconds.." seconds."
		end

	end
end)




function partToRegion3(part)
	local corner1 = (part.CFrame * CFrame.new(part.Size.X/2, part.Size.Y/2, part.Size.Z/2)).p
	local corner2 = (part.CFrame * CFrame.new(part.Size.X/-2, part.Size.Y/-2, part.Size.Z/-2)).p
	
	local boundsMin = Vector3.new(math.min(corner1.X, corner2.X),math.min(corner1.Y, corner2.Y),math.min(corner1.Z, corner2.Z))
	local boundsMax = Vector3.new(math.max(corner1.X, corner2.X),math.max(corner1.Y, corner2.Y),math.max(corner1.Z, corner2.Z))
	
	part:Destroy()
	return Region3.new(boundsMin, boundsMax)
end
local hole = partToRegion3(script.Parent.Hole)

function checkForEye()
	for _, part in pairs(workspace:FindPartsInRegion3(hole)) do
		local type = part.Name == "Main" and part.Parent:FindFirstChild("Owner") and part.Parent:FindFirstChild("ItemName") and part.Parent.ItemName.Value
		
		if type == "Eye1" then
			coroutine.resume(coroutine.create(function()
				part.Anchored = true
				part.Parent.Owner:Destroy()
				for i = 0, 1, 0.02 do
					part.Transparency = i
					wait()
				end
				part.Parent:Destroy()
			end))
			return true
		end
	end
	return false
end

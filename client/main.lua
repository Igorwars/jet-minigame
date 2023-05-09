ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



RegisterCommand("setdim", function(source, args, rawCommand)
	ESX.TriggerServerCallback("dps:hasGroup", function(val)
		if val == 'true' then
			TriggerServerEvent("dps:setDim", GetPlayerServerId(PlayerId()), args[1], args[2])
		end
	end)
end)

RegisterCommand("getdim", function(source, args, rawCommand)
	ESX.TriggerServerCallback("dps:hasGroup", function(val)
		if val == 'true' then
			local player = GetPlayerPed(args[1])
			Citizen.Trace(player)
			TriggerServerEvent("dps:getDim", GetPlayerServerId(PlayerId()), args[1])
		end
	end)
end)

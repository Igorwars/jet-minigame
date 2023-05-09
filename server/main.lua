ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

ESX.RegisterServerCallback('dps:hasGroup', function(source, cb)
    local _source = source
    local aPlayer  = ESX.GetPlayerFromId(_source)
	local group = aPlayer.getGroup()	

    if group == 'admin' then
        cb("true")
    else
        cb("false")
    end
end)

ESX.RegisterServerCallback('dps:getRot', function(source, cb)
    local _source = source
    local o = GetPlayerCameraRotation(source)
    cb(o)
end)

ESX.RegisterServerCallback('dps:getDimNew', function(source, cb)
    local _source = source
    local lol = GetPlayerRoutingBucket(source)
    cb(lol)
end)
end)

RegisterNetEvent('dps:DeleteAircrafts')
AddEventHandler('dps:DeleteAircrafts', function(source)
    local _source = source
    local vehicles = GetAllVehicles()
        for i, vehicle in ipairs(vehicles) do
            --print(GetEntityRoutingBucket(vehicle))
            -- Überprüfen, ob das Flugzeug in der Dimension 15 ist und unbemannt ist
            if (GetEntityRoutingBucket(vehicle) == 15) and GetPedInVehicleSeat(vehicle , -1) == 0 then
                print(GetPedInVehicleSeat(vehicle , -1))
                -- Flugzeug löschen, wenn es seit 15 Sekunden unbemannt ist
                DeleteEntity(vehicle)
            end
        end

end)


RegisterNetEvent('dps:showNotification')
AddEventHandler('dps:showNotification', function(source, str)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    xPlayer.showNotification(str, true, true, 30)
end)

RegisterNetEvent('dps:reanimate')
AddEventHandler('dps:reanimate', function(source)
    ResurrectPed(source)
end)


RegisterNetEvent('dps:setDim')
AddEventHandler('dps:setDim', function(source, player, dim)
    local _source = source
    Citizen.Trace(tostring(tonumber(dim)))
    SetPlayerRoutingBucket(player, tonumber(dim))
end)

RegisterNetEvent('dps:getDim')
AddEventHandler('dps:getDim', function(source, player)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    Citizen.Trace(player)
    local lol = GetPlayerRoutingBucket(player)
    local str = "Die Dimension des Spielers ist: " .. lol
    xPlayer.showNotification(str, true, true, 30)
end)



RegisterNetEvent('dps:getDimScr')
AddEventHandler('dps:getDimScr', function(source, cb)
    local _source = source
    local lol = GetPlayerRoutingBucket(source)
    cb(lol)
end)

RegisterNetEvent('dps:getDimScr')
AddEventHandler('dps:getDimScr', function(source, cb)
    local _source = source
    local lol = GetPlayerRoutingBucket(source)
    cb(lol)
end)

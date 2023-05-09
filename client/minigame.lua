ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local dimension = 15
local aircraftModel = "strikeforce"
local aircraftSpawnPoints = {
    --SPAWN COORDS AREN'T CORRECT YET
    {x = -964.02, y = -3163.9, z = 13.96, a=60.3},
    {x = -964.02, y = -3312.4, z = 13.96, a=60.3},
    {x = -1525.9, y = -3163.9, z = 13.96, a=240.3},
    {x = -1589.7, y = -2997.2, z = 13.96, a=240.3},
    {x = -1326.5, y = -2193.9, z = 13.96, a=150.0},
    {x = -1742.0, y = -2913.5, z = 13.96, a=60.0}
}

-- Funktion zum Erstellen eines neuen Flugzeugs an einem freien Punkt
function createNewAircraft()
    for i, spawnPoint in ipairs(aircraftSpawnPoints) do
        -- �berpr�fen, ob der Punkt frei ist
        if not IsAnyVehicleNearPoint(spawnPoint.x, spawnPoint.y, spawnPoint.z, 50.0) then
            -- Flugzeug erstellen und den Spieler hineinsetzen
            RequestModel(GetHashKey(aircraftModel))
			Citizen.CreateThread(function() 
				local waiting = 0
				local canSpawn = true
				while not HasModelLoaded(GetHashKey(aircraftModel)) do
					waiting = waiting + 100
					Citizen.Wait(100)
					if waiting > 5000 then
						canSpawn = false
						break
					end
				end
				if canSpawn then
                    print("idiot")
                    --TriggerServerEvent("dps:reanimate", GetPlayerPed(-1))
                    RespawnPed(GetPlayerPed(-1), GetEntityCoords(GetPlayerPed(-1)), 0.0)
                    local aircraft = CreateVehicle(GetHashKey(aircraftModel), spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.a, true, false)
                    SetPedIntoVehicle(GetPlayerPed(-1), aircraft, -1)
                end

            end)
            return
        end
    end
end

-- Funktion zum Teleportieren des Spielers in ein neues Flugzeug
function respawnInAircraft()
    -- �berpr�fen, ob der Spieler in keinem Flugzeug mehr sitzt oder tot ist
    if not IsPedInAnyVehicle(GetPlayerPed(-1), true) or IsPedDeadOrDying(GetPlayerPed(-1), true) then
        -- Neues Flugzeug erstellen und den Spieler hineinsetzen
        createNewAircraft()
    end
end

function RespawnPed(ped, coords, heading)
    StopScreenEffect('DeathFailOut')
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false,
                            false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true,
                                false)
    SetPlayerInvincible(ped, false)
    TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
    ClearPedBloodDamage(ped)

    TriggerServerEvent('esx:onPlayerSpawn')
    TriggerEvent('esx:onPlayerSpawn')

    ESX.UI.Menu.CloseAll()
end


-- Funktion zum Aktualisieren des Skripts
function update()
    if(ESX ~= nil) then
    ESX.TriggerServerCallback("dps:getDimNew", function(dim)
        print(dim)
        if dim == dimension then
            TriggerServerEvent('dps:DeleteAircrafts', GetPlayerServerId(PlayerId()))

            Citizen.CreateThread(function()
                    Citizen.Wait(500)
                    respawnInAircraft()
            end)
            SetTimeout(7500, update)

            
        else
            SetTimeout(15000, update) 
        end
    end)
    else
        SetTimeout(7500, update) 
    end
    
end

update()
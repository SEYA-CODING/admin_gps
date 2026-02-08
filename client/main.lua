local Trackers = {}
local TabletOpen = false

RegisterCommand(Config.TabletCommand, function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
    TabletOpen = true
    TriggerServerEvent('admin_gps:requestTrackers')
end)

RegisterNetEvent('admin_gps:updateTrackers', function(data)
    Trackers = data
    SendNUIMessage({
        action = 'update',
        trackers = Trackers
    })
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    TabletOpen = false
end)

RegisterCommand('installgps', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local label = GetVehicleNumberPlateText(vehicle)

    FreezeEntityPosition(vehicle, true)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)

    Wait(Config.InstallTime)

    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(vehicle, false)

    TriggerServerEvent('admin_gps:addTracker', netId, label)
end)

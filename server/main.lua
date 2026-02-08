local QBCore, ESX = nil, nil
local Trackers = {}

CreateThread(function()
    if Config.Framework == 'qb' or Config.Framework == 'auto' then
        if GetResourceState('qb-core') == 'started' then
            QBCore = exports['qb-core']:GetCoreObject()
        end
    end

    if Config.Framework == 'esx' or Config.Framework == 'auto' then
        if GetResourceState('es_extended') == 'started' then
            ESX = exports['es_extended']:getSharedObject()
        end
    end
end)

local function IsAdmin(src)
    if QBCore then
        return QBCore.Functions.HasPermission(src, 'admin')
    elseif ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        for _,group in pairs(Config.AdminGroups) do
            if xPlayer.getGroup() == group then
                return true
            end
        end
    end
    return false
end

RegisterNetEvent('admin_gps:addTracker', function(netId, label)
    local src = source
    if not IsAdmin(src) then return end

    Trackers[netId] = {
        label = label,
        addedBy = src
    }

    TriggerClientEvent('admin_gps:updateTrackers', -1, Trackers)
end)

RegisterNetEvent('admin_gps:removeTracker', function(netId)
    local src = source
    if not IsAdmin(src) then return end

    Trackers[netId] = nil
    TriggerClientEvent('admin_gps:updateTrackers', -1, Trackers)
end)

RegisterNetEvent('admin_gps:requestTrackers', function()
    TriggerClientEvent('admin_gps:updateTrackers', source, Trackers)
end)

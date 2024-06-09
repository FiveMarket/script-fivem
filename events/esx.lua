local ESX

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('fivemarket:addMoney', AddMoney)
AddEventHandler('fivemarket:removeMoney', RemoveMoney)
AddEventHandler('fivemarket:addItem', AddItem)
AddEventHandler('fivemarket:removeItem', RemoveItem)
AddEventHandler('fivemarket:addWarn', AddWarn)
AddEventHandler('fivemarket:removeWarn', RemoveWarn)
AddEventHandler('fivemarket:addCar', AddCar)
AddEventHandler('fivemarket:addCarTemporary', AddCarTemporary)
AddEventHandler('fivemarket:removeCar', RemoveCar)
AddEventHandler('fivemarket:addHouse', AddHouse)
AddEventHandler('fivemarket:addHouseTemporary', AddHouseTemporary)
AddEventHandler('fivemarket:removeHouse', RemoveHouse)
AddEventHandler('fivemarket:addGroup', AddGroup)

function AddMoney(playerId, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not xPlayer then
        return
    end

    xPlayer.addMoney(amount)
end

function RemoveMoney(playerId, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not xPlayer then
        return
    end

    xPlayer.removeMoney(amount)
end

function AddItem(playerId, item, count)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not xPlayer then
        return
    end

    xPlayer.addInventoryItem(item, count)
end

function RemoveItem(playerId, item, count)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not xPlayer then
        return
    end

    xPlayer.removeInventoryItem(item, count)
end

function AddWarn()
end

function RemoveWarn()
end

function AddCar()
end

function AddCarTemporary()
end

function RemoveCar()
end

function AddHouse()
end

function AddHouseTemporary()
end

function RemoveHouse()
end

function AddGroup()
end
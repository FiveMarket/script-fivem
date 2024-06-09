local QBCore = exports['qb-core']:GetCoreObject()

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
    QBCore.Functions.AddMoney("bank", playerId, amount)
end

function RemoveMoney(playerId, amount)
    QBCore.Functions.RemoveMoney("bank", playerId, amount)
end

function AddItem(playerId, item, count)
    QBCore.Functions.AddItem(playerId, item, count)
end

function RemoveItem(playerId, item, count)
    QBCore.Functions.RemoveItem(playerId, item, count)
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
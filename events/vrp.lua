local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

function AddMoney(Passport, Amount)
    vRP.GiveBank(Passport, Amount)
end

function RemoveMoney(Passport, Amount)
    vRP.RemoveBank(Passport, Amount)
end

function AddItem(Passport, Item, Amount)
    vRP.GiveItem(Passport, Item, Amount)
end

function RemoveItem(Passport, Item, Amount)
    vRP.TakeItem(Passport, Item, Amount)
end

function AddWarn(Passport)
end

function RemoveWarn(Passport)
end

function AddCar(Passport, Name)
    vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = vRP.GeneratePlate(), work = "false" })
end

function AddCarTemporary(Passport, Model, Name, ExpireDate)
end

function RemoveCar(Passport, Name)
    vRP.Query("vehicles/removeVehicles",{ Passport = Passport, vehicle = Name })
end

function AddHouse(Passport)
end

function AddHouseTemporary(Passport)
end

function RemoveHouse(Passport)
end

function AddGroup(Passport, Group)
    vRP.addUserGroup(Passport, Group)
end

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
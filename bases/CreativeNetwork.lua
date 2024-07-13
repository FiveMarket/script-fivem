-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ VRP ]]
-----------------------------------------------------------------------------------------------------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------

local Markers = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDMONEY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addMoney',function(Passport, Amount)
    return vRP.GiveBank(Passport, Amount)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEMONEY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeMoney',function(Passport, Amount)
    return vRP.RemoveBank(Passport, Amount)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDITEM ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addItem', function(Passport, Item)
    local source = vRP.Source(Passport)

    if source then
        return vRP.GenerateItem(Passport, Item, 1, false)
    else
        return GiveItemToOfflinePlayer(Passport, Item)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEITEM ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeItem', function(Passport, Item)
    local source = vRP.Source(Passport)

    if source then
        return vRP.RemoveItem(Passport, Item, 1, false)
    else
        return RemoveItemFromOfflinePlayer(Passport, Item)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDCAR ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- PERMANENTE
AddEventHandler('fivemarket:addCar',function(Passport, Vehicle)
    return vRP.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Vehicle, plate = vRP.GeneratePlate(), work = "false" })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDCARTEMPORARY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- Por padrão 30 dias. Caso seja algum outro tempo, alterar em seu vRP.Prepare.
AddEventHandler('fivemarket:addCarTemporary',function(Passport, Vehicle)
    return vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = Vehicle, plate = vRP.GeneratePlate(), work = "false" })
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVECAR ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeCar',function(Passport, Vehicle)
    return vRP.Query("vehicles/removeVehicles",{ Passport = Passport, vehicle = Vehicle })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDWARN ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addWarn',function(Passport, Amount)
    --Crie sua lógica de aplicação de advertência ou banimento.
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEWARN ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeWarn',function(Passport)
    --Crie sua lógica de remoção de advertência ou banimento. 
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDHOUSE ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- PERMANENTE
-- POR PADRÃO AS BASES CREATIVES NÃO POSSUEM CASAS PERMANENTES. Caso queira, você pode criar uma lógica para adicionar casas permanentes ao seu servidor.
-- OBSERVAÇÃO: PARÂMETRO "NAME" É REFERENTE AO NOME DA CASA, NÃO DO INTERIOR.
AddEventHandler('fivemarket:addHouse',function(Passport, Name)
    -- Crie sua lógica de casa permanente aqui. Você pode seguir o modelo abaixo da temporária, colocando um alto valor em "tax", para simular ser "permanente".
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDHOUSETEMPORARY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- TEMPORÁRIA
-- OBSERVAÇÃO: PARÂMETRO "NAME" É REFERENTE AO NOME DA CASA, NÃO DO INTERIOR.
AddEventHandler('fivemarket:addHouseTemporary',function(Passport, Name)
    local source = source
    local Interior = "Amber" -- altere para o tipo de interior que você quer setar para o jogador. Normalmente encontrado em propertys/server-side/informations.lua
    local Consult = vRP.Query("propertys/Exist",{ name = Name })

    if not Consult[1] then
        Markers[Name] = true
        local Serial = PropertysSerials()
        local Vault = 1000 -- Tamanho do cofre (baú). Altere ao seu gosto.
        local Fridge = 1000 -- Tamanho da "Geladeira" (baú). Altere ao seu gosto.

        if source then
            vRP.GiveItem(Passport,"propertys-"..Serial,1,true)
        else
            GiveItemToOfflinePlayer(Passport,"propertys-"..Serial)
        end
        
        TriggerClientEvent("propertys:Markers",-1,Markers)
        vRP.Query("propertys/Buy",{ name = Name, interior = Interior, passport = Passport, serial = Serial, vault = Vault, fridge = Fridge, tax = os.time() + 2592000 })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEHOUSE ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- OBSERVAÇÃO: PARÂMETRO "NAME" É REFERENTE AO NOME DA CASA, NÃO DO INTERIOR.
AddEventHandler('fivemarket:removeHouse',function(Passport, Name)
    local Consult = vRP.Query("propertys/Exist",{ name = Name })

    if Consult[1] then
        if parseInt(Consult[1]["Passport"]) == Passport then

            if Markers[Name] then
                Markers[Name] = nil
                TriggerClientEvent("propertys:Markers",-1,Markers)
            end

            vRP.RemSrvData("Vault:"..Name)
            vRP.RemSrvData("Fridge:"..Name)
            vRP.Query("propertys/Sell",{ name = Name })
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDGROUP ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addGroup',function(Passport, Permission)
    return vRP.SetPermission(Passport, Permission)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEGROUP ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeGroup',function(Passport, Permission)
    return vRP.RemovePermission(Passport, Permission)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ GIVEITEMTOOFFLINEPLAYER ]]
-----------------------------------------------------------------------------------------------------------------------------------------

function GiveItemToOfflinePlayer(Passport, Item)
    local Consult = vRP.Query("playerdata/GetData", { Passport = Passport, dkey = "Datatable" })

    if Consult and Consult[1] then
        local data = Consult[1].dvalue
        local playerData = json.decode(data)
        local inventory = playerData.Inventory
        local itemFound = false

        for k, v in pairs(inventory) do
            if v.item == Item then
                v.amount = v.amount + 1
                itemFound = true
                break
            end
        end

        if not itemFound then
            local newIndex = nil
            for i = 1, 100 do
                if inventory[tostring(i)] == nil then
                    newIndex = tostring(i)
                    break
                end
            end

            if newIndex then
                inventory[newIndex] = {item = Item, amount = 1}
            else
                print("Inventário cheio, não foi possível adicionar o item: " .. Item)
            end
        end

        playerData.Inventory = inventory
        local updatedData = json.encode(playerData)

        vRP.Query("playerdata/SetData", {Passport = Passport, dkey = "Datatable", dvalue = updatedData})
    else
        print("Dados do jogador não encontrados para o passaporte: " .. Passport)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEITEMFROMOFFLINEPLAYER ]]
-----------------------------------------------------------------------------------------------------------------------------------------

function RemoveItemFromOfflinePlayer(Passport, Amount)
    local Consult = vRP.Query("playerdata/GetData", { Passport = Passport, dkey = "Datatable" })

    if Consult and Consult[1] then
        local data = Consult[1].dvalue
        local playerData = json.decode(data)
        local inventory = playerData.Inventory
        local itemRemoved = false

        for k, v in pairs(inventory) do
            if v.item == Item then
                if v.amount > 1 then
                    v.amount = v.amount - 1
                else
                    inventory[k] = nil
                end
                itemRemoved = true
                break
            end
        end

        if itemRemoved then
            playerData.Inventory = inventory
            local updatedData = json.encode(playerData)

            vRP.Query("playerdata/SetData", {Passport = Passport, dkey = "Datatable", dvalue = updatedData})
        else
            print("Item não encontrado no inventário para o passaporte: " .. Passport)
        end
    else
        print("Dados do jogador não encontrados para o passaporte: " .. Passport)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ PROPERTYSSERIALS ]]
-----------------------------------------------------------------------------------------------------------------------------------------

function PropertysSerials()
	local Serial = vRP.GenerateString("LDLDLDLDLD")
	local Consult = vRP.Query("propertys/Serial",{ serial = Serial })

	if Consult[1] then
		PropertysSerials()
	end

	return Serial
end
-- Este modelo foi feito em cima da Creative v5 original. Sujeito a diferenças quando comparado a sua base.
-- Caso você tenha alguma dúvida ou problema referente a adaptação, você pode solicitar um orçamento no Discord da gho$tware: https://discord.gg/rzfTSQ29Dn

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ VRP ]]
-----------------------------------------------------------------------------------------------------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDMONEY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addMoney',function(Passport, Amount)
    return vRP.addBank(Passport, Amount, "Private")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEMONEY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeMoney',function(Passport, Amount)
    return vRP.delBank(Passport, Amount, "Private")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDITEM ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addItem', function(Passport, Item, Quantity)
    local source = vRP.userSource(Passport)

    if source then
        return vRP.generateItem(Passport, Item, Quantity, false)
    else
        return GiveItemToOfflinePlayer(Passport, Item, Quantity)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEITEM ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeItem', function(Passport, Item, Quantity)
    local source = vRP.userSource(Passport)

    if source then
        return vRP.removeInventoryItem(Passport, Item, Quantity, false)
    else
        return RemoveItemFromOfflinePlayer(Passport, Item, Quantity)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDCAR ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- PERMANENTE
AddEventHandler('fivemarket:addCar',function(Passport, Vehicle)
    return vRP.execute("vehicles/addVehicles",{ user_id = Passport, vehicle = Vehicle, plate = vRP.generatePlate(), work = "false" })

end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDCARTEMPORARY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- Por padrão 30 dias. Caso seja algum outro tempo, alterar em seu vRP.prepare.
AddEventHandler('fivemarket:addCarTemporary',function(Passport, Vehicle)
    return vRP.execute("vehicles/rentalVehicles",{ user_id = Passport, vehicle = Vehicle, plate = vRP.generatePlate(), work = "false" })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVECAR ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeCar',function(Passport, Vehicle)
    return vRP.execute("vehicles/removeVehicles",{ user_id = Passport, vehicle = Vehicle })
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
-- OBSERVAÇÃO: PARÂMETRO "NAME" É REFERENTE AO NOME DA CASA, NÃO DO INTERIOR.
AddEventHandler('fivemarket:addHouse',function(Passport, Name)
    local source = vRP.userSource(Passport)
    local Interior = "Mansion" -- altere para o tipo de interior que você quer setar para o jogador. Normalmente encontrado em homes/server-side/server.lua
    local Consult = vRP.query("propertys/permissions",{ name = Name })

    if not Consult[1] then
        local Vault = 1000 -- Tamanho do cofre (baú). Altere ao seu gosto.
        local Fridge = 1000 -- Tamanho da "Geladeira" (baú). Altere ao seu gosto.
        local Residents = 5 -- Quantidade de residents. Altere ao seu gosto.

        vRP.execute("propertys/buying",{ name = Name, user_id = Passport, interior = Interior, price = 300000, residents = Residents, vault = Vault, fridge = Fridge })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDHOUSETEMPORARY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- TEMPORÁRIA
-- POR PADRÃO AS BASES CREATIVES V5 POSSUEM CASAS PERMANENTES. Caso queira, você pode criar uma lógica para adicionar casas temporárias ao seu servidor.
-- OBSERVAÇÃO: PARÂMETRO "NAME" É REFERENTE AO NOME DA CASA, NÃO DO INTERIOR.
AddEventHandler('fivemarket:addHouseTemporary',function(Passport, Name)
    -- Crie sua lógica de casa temporária aqui.
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEHOUSE ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- OBSERVAÇÃO: PARÂMETRO "NAME" É REFERENTE AO NOME DA CASA, NÃO DO INTERIOR.
AddEventHandler('fivemarket:removeHouse',function(Passport, Name)
    local Consult = vRP.query("propertys/userPermissions",{ name = Name, user_id = Passport })

    if Consult[1] then
        vRP.remSrvdata("wardrobe:"..Name)
        vRP.remSrvdata("fridge:"..Name)
        vRP.remSrvdata("vault:"..Name)
        TriggerEvent("garages:removeGarages",Name)
        vRP.execute("propertys/selling",{ name = Name })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDGROUP ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addGroup',function(Passport, Permission)
    return vRP.setPermission(Passport, Permission)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEGROUP ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeGroup',function(Passport, Permission)
    return vRP.remPermission(Passport, Permission)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ GIVEITEMTOOFFLINEPLAYER ]]
-----------------------------------------------------------------------------------------------------------------------------------------

function GiveItemToOfflinePlayer(Passport, Item, Quantity)
    local Consult = vRP.execute("playerdata/getUserdata", { user_id = Passport, dkey = "Datatable" })

    if Consult and Consult[1] then
        local data = Consult[1].dvalue
        local playerData = json.decode(data)
        local inventory = playerData.Inventory
        local itemFound = false

        for k, v in pairs(inventory) do
            if v.item == Item then
                v.amount = v.amount + Quantity
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
                inventory[newIndex] = {item = Item, amount = Quantity}
            else
                print("Inventário cheio, não foi possível adicionar o item: " .. Item)
            end
        end

        playerData.Inventory = inventory
        local updatedData = json.encode(playerData)

        vRP.execute("playerdata/setUserdata", {Passport = Passport, dkey = "Datatable", dvalue = updatedData})
    else
        print("Dados do jogador não encontrados para o passaporte: " .. Passport)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEITEMFROMOFFLINEPLAYER ]]
-----------------------------------------------------------------------------------------------------------------------------------------

function RemoveItemFromOfflinePlayer(Passport, Amount, Quantity)
    local Consult = vRP.execute("playerdata/getUserdata", { user_id = Passport, dkey = "Datatable" })

    if Consult and Consult[1] then
        local data = Consult[1].dvalue
        local playerData = json.decode(data)
        local inventory = playerData.Inventory
        local itemRemoved = false

        for k, v in pairs(inventory) do
            if v.item == Item then
                if v.amount > 1 then
                    v.amount = v.amount - Quantity
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

            vRP.execute("playerdata/setUserdata", {user_id = Passport, dkey = "Datatable", dvalue = updatedData})
        else
            print("Item não encontrado no inventário para o passaporte: " .. Passport)
        end
    else
        print("Dados do jogador não encontrados para o passaporte: " .. Passport)
    end
end
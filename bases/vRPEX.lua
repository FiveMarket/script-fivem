-- Este modelo foi feito em cima de uma vRPEX modificada, encontrada em comunidades. Sujeito a diferenças quando comparado a sua base.
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
    return vRP.giveBankMoney(Passport, Amount)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEMONEY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeMoney',function(Passport, Amount)
    local temp = vRP.getUserTmpTable(Passport)
    
    if temp then
        temp.bank = temp.bank - Amount
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDITEM ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addItem', function(Passport, Item)
    local source = source

    if source then
        return vRP.giveInventoryItem(Passport,Item,1)
    else
        -- adicione sua lógica para gerar o item para o jogador caso esteja offline.
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEITEM ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeItem', function(Passport, Item)
    local source = source

    if source then
        return vRP.tryGetInventoryItem(Passport,Item,1)
    else
        -- adicione sua lógica para remover o item para o jogador caso esteja offline.
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDCAR ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- PERMANENTE

vRP._prepare("fivemarket/add_vehicle","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle) VALUES(@user_id,@vehicle)")

AddEventHandler('fivemarket:addCar',function(Passport, Vehicle)
    return vRP.execute("fivemarket/add_vehicle",{ user_id = Passport, vehicle = Vehicle, ipva = parseInt(os.time()) })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDCARTEMPORARY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addCarTemporary',function(Passport, Vehicle)
    -- return Adicione sua lógica para adição de carros temporários
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVECAR ]]
-----------------------------------------------------------------------------------------------------------------------------------------

vRP._prepare("fivemarket/rem_vehicle","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")

AddEventHandler('fivemarket:removeCar',function(Passport, Vehicle)
    return vRP.execute("fivemarket/rem_vehicle",{ user_id = Passport, vehicle = Vehicle }) 
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
    -- Crie sua lógica de casa permanente aqui.
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDHOUSETEMPORARY ]]
-----------------------------------------------------------------------------------------------------------------------------------------

-- TEMPORÁRIA
-- OBSERVAÇÃO: PARÂMETRO "NAME" É REFERENTE AO NOME DA CASA, NÃO DO INTERIOR.
AddEventHandler('fivemarket:addHouseTemporary',function(Passport, Name)
    -- Crie sua lógica de casa temporária aqui.
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEHOUSE ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addHouseTemporary',function(Passport, Name)
    -- Crie sua lógica de remoção da casa do usuário aqui.
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ ADDGROUP ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:addGroup',function(Passport, Permission)
    return vRP.addUserGroup(Passport,Permission)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- [[ REMOVEGROUP ]]
-----------------------------------------------------------------------------------------------------------------------------------------

AddEventHandler('fivemarket:removeGroup',function(Passport, Permission)
    return vRP.removeUserGroup(Passport, Permission)
end)
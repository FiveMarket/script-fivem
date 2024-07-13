fx_version "bodacious"
game "gta5"
author 'FiveMarket, made by gho$tware'
gho'$'tware 'https://discord.gg/rzfTSQ29Dn'
FiveMarket 'https://discord.gg/X5gXTtuFSB'
version '1.0'

local base = "CreativeNetwork" -- bases compatíveis: vRP, vRPEX, Creativev5, CreativeNetwork, ESX, QBCore

if base == "vRP" then
    server_scripts { "@vrp/lib/utils.lua", "script.js", "bases/vRP.lua" }
elseif base == "vRPEX" then
    server_scripts { "@vrp/lib/utils.lua", "script.js", "bases/vRPEX.lua" }
elseif base == "Creativev5" then
    server_scripts { "@vrp/lib/Utils.lua", "script.js", "bases/Creativev5.lua" }
elseif base == "CreativeNetwork" then
    server_scripts { "@vrp/lib/Utils.lua", "script.js", "bases/CreativeNetwork.lua" }
elseif base == "ESX" then
    -- terminar estrutura esx
elseif base == "QBCore" then
    -- terminar estrutura QBCore
elseif base == "Custom" then
    -- Caso você tenha uma base customizada, coloque sua lógica aqui e "Custom" como string na variável base.
end
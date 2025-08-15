--[[
 ________  ___  ___  ________   ________  ___  ___  ___     
|\   ____\|\  \|\  \|\   ___  \|\   ____\|\  \|\  \|\  \    
\ \  \___|\ \  \\\  \ \  \\ \  \ \  \___|\ \  \\\  \ \  \   
 \ \_____  \ \  \\\  \ \  \\ \  \ \_____  \ \   __  \ \  \  
  \|____|\  \ \  \\\  \ \  \\ \  \|____|\  \ \  \ \  \ \  \ 
    ____\_\  \ \_______\ \__\\ \__\____\_\  \ \__\ \__\ \__\
   |\_________\|_______|\|__| \|__|\_________\|__|\|__|\|__|
   \|_________|                   \|_________|              
]]--

local PLUGIN = PLUGIN

PLUGIN.name = "Auto join default class"
PLUGIN.author = "Sunshi"
PLUGIN.description = "Automatically join the default class when a player join a faction."

if SERVER then
local character = ix.meta.character
local _oldSetFaction = character.SetFaction

function character:SetFaction(faction, ...)
    _oldSetFaction(self, faction, ...)
    hook.Run("OnCharacterTransferred", self, faction)
end

hook.Add("OnCharacterTransferred", "SetDefaultClass", function(character, faction)
    local client = character:GetPlayer()
    if isstring(ix.faction.Get(faction).models) then
     character:SetModel(ix.faction.Get(faction).models)
    elseif istable(ix.faction.Get(faction).models) then
     character:SetModel(ix.faction.Get(faction).models[math.random(1, table.Count(ix.faction.Get(faction).models))])
    end

    for i,v in ipairs(ix.class.list) do
        if v.faction == faction then
           if v.isDefault then
              character:JoinClass(i)
              break
           end
        end
    end
end)


function PLUGIN:PlayerJoinedClass(client, class, oldClass)
                local character = client:GetCharacter()
    if isstring(ix.class.Get(class).model) then
     character:SetModel(ix.class.Get(class).model)
     if ix.class.Get(class).skin then client:SetSkin(ix.class.Get(class).skin) else client:SetSkin(0) end
    end
end


end
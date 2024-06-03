
local _G = GLOBAL
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
require 'eryuehong/eyh_24'   ---语句
require 'eryuehong/eyh_25'   ---语句



--预运行
if not GLOBAL.TheNet:GetIsClient() then
	AddPlayerPostInit(function(inst)
	    inst:AddComponent("allachiv")
    	inst.components.allachiv:Init(inst)
	end)
end





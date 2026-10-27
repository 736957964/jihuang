
local prizevalues = 
{
	goldnugget = 2.5,
	myth_coin = 5,
	lucky_goldnugget = 2.5,
}

local SMASHABLE_TAGS = { "smashable", "quakedebris", "_combat","myth_coin" }
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable" }

local HEAVY_WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}

local HEAVY_SMASHABLE_TAGS = { "smashable", "quakedebris", "_combat", "_inventoryitem", "NPC_workable" }
for k, v in pairs(HEAVY_WORK_ACTIONS) do
    table.insert(HEAVY_SMASHABLE_TAGS, k.."_workable")
end
local HEAVY_NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable", "caveindebris" }

local Myth_quaker = Class(function(self, inst)
    self.inst = inst
end)

local function GetDebris()
	local prizevalue = weighted_random_choice(prizevalues)
	return prizevalue
end

local GetSpawnPoint = function(pt)
    local theta = math.random() * 2 * PI
    local result_offset = FindValidPositionByFan(theta, math.random(4,8), 30, function(offset)
        local x = pt.x + offset.x
        local z = pt.z + offset.z
        return TheWorld.Map:IsAboveGroundAtPoint(x, 0, z)
            and not TheWorld.Map:IsPointNearHole(Vector3(x, 0, z))
    end)
    return result_offset ~= nil and pt + result_offset or nil
end

local UpdateShadowSize = function(shadow, height)
    local scaleFactor = Lerp(.5, 1.5, height / 35)
    shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
end

local _BreakDebris =function(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, 0, z)
    debris:Remove()
end

local _GroundDetectionUpdate = function(debris, override_density)
    local x, y, z = debris.Transform:GetWorldPosition()
    if y <= .2 then
        if not debris:IsOnValidGround() then
            debris:PushEvent("detachchild")
            debris:Remove()
        elseif TheWorld.Map:IsPointNearHole(Vector3(x, 0, z)) then
            if debris.prefab == "mole" or debris.prefab == "rabbit" then
                debris:PushEvent("detachchild")
                debris:Remove()
            else
                _BreakDebris(debris)
            end
        else
            local softbounce = false
            if debris:HasTag("heavy") then
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, HEAVY_NON_SMASHABLE_TAGS, HEAVY_SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        if v:HasTag("quakedebris") then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                            v:Remove()
                        elseif v.components.workable ~= nil then
                            if v.sg == nil or not v.sg:HasStateTag("busy") then
                                local work_action = v.components.workable:GetWorkAction()
                                if (    (work_action == nil and v:HasTag("NPC_workable")) or
                                        (work_action ~= nil and HEAVY_WORK_ACTIONS[work_action.id]) ) and
                                    (work_action ~= ACTIONS.DIG
                                    or (v.components.spawner == nil and
                                        v.components.childspawner == nil)) then
                                    v.components.workable:Destroy(debris)
                                end
                            end
                        elseif v.components.combat ~= nil then
                            v.components.combat:GetAttacked(debris, 30, nil)
                        elseif v.components.inventoryitem ~= nil then
                            if v.components.mine ~= nil then
                                v.components.mine:Deactivate()
                            end
                            Launch(v, debris, TUNING.LAUNCH_SPEED_SMALL)
                        end
                    end
                end
            else
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, NON_SMASHABLE_TAGS, SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        if v:HasTag("quakedebris") or v:HasTag("myth_coin") then --物品移除哦
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                            v:Remove()
                        elseif v.components.combat ~= nil and not (v:HasTag("epic") or v:HasTag("wall") or v:HasTag("myth_small_goldfrog")) then
                            v.components.combat:GetAttacked(debris, 20, nil)
                        end
                    end
                end
            end
            debris.Physics:SetDamping(.9)
            if softbounce then
                local speed = 3.2 + math.random()
                local angle = math.random() * 2 * PI
                debris.Physics:SetMotorVel(0, 0, 0)
                debris.Physics:SetVel(
                    speed * math.cos(angle),
                    speed * 2.3,
                    speed * math.sin(angle)
                )
            end
            debris.shadow:Remove()
            debris.shadow = nil
            debris.updatetask:Cancel()
            debris.updatetask = nil
            if math.random() < .01 then
                --keep it
                debris.persists = true
                debris.entity:SetCanSleep(true)
                if debris._restorepickup then
                    debris._restorepickup = nil
                    if debris.components.inventoryitem ~= nil then
                        debris.components.inventoryitem.canbepickedup = true
                    end
                end
                debris:PushEvent("stopfalling")
            elseif debris:GetTimeAlive() < 1.5 then
                debris:DoTaskInTime(softbounce and .4 or .6, _BreakDebris)
            else
                _BreakDebris(debris)
            end
        end
    elseif debris:GetTimeAlive() < 3 then
        if y < 2 then
            debris.Physics:SetMotorVel(0, 0, 0)
        end
        UpdateShadowSize(debris.shadow, y)
    elseif debris:IsInLimbo() then
        debris.persists = true
        debris.entity:SetCanSleep(true)
        debris.shadow:Remove()
        debris.shadow = nil
        debris.updatetask:Cancel()
        debris.updatetask = nil
        if debris._restorepickup then
            debris._restorepickup = nil
            if debris.components.inventoryitem ~= nil then
                debris.components.inventoryitem.canbepickedup = true
            end
        end
        debris:PushEvent("stopfalling")
    elseif debris.prefab == "mole" or debris.prefab == "rabbit" then
        debris:PushEvent("detachchild")
        debris:Remove()
    else
        _BreakDebris(debris)
    end
end

local OnRemoveDebris =  function(debris)
    debris.shadow:Remove()
end

local SpawnDebris = function(spawn_point, override_prefab, override_density)
    local prefab =  GetDebris()
    if prefab ~= nil then
        local debris = SpawnPrefab(prefab)
        if debris ~= nil then
            debris.entity:SetCanSleep(false)
            debris.persists = false
            if debris.components.inventoryitem ~= nil and debris.components.inventoryitem.canbepickedup then
                debris.components.inventoryitem.canbepickedup = false
                debris._restorepickup = true
            end
            if math.random() < .5 then
                debris.Transform:SetRotation(180)
            end
            debris.Physics:Teleport(spawn_point.x, 35, spawn_point.z)
			if prefab == "myth_coin" then
				debris.AnimState:PlayAnimation("drop")
			end

            debris.shadow = SpawnPrefab("warningshadow")
            debris.shadow:ListenForEvent("onremove", OnRemoveDebris, debris)
            debris.shadow.Transform:SetPosition(spawn_point.x, 0, spawn_point.z)
            UpdateShadowSize(debris.shadow, 35)

            debris.updatetask = debris:DoPeriodicTask(FRAMES, _GroundDetectionUpdate, nil, override_density)
            debris:PushEvent("startfalling")
        end
        return debris
    end
end

local function DoDrop(inst)
	for k = 1 ,math.random(25,30) do
		local char_pos = Vector3(inst.Transform:GetWorldPosition())
		local spawn_point = GetSpawnPoint(char_pos)
		if spawn_point ~= nil then
			inst:DoTaskInTime(math.random()*0.4,function()
				SpawnDebris(spawn_point)
			end)
		end		
	end
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 12, {"player"},{"playerghost"})
	for i,v in ipairs(ents) do
		local pt = v:GetPosition()
		SpawnDebris(pt)
	end
end

function Myth_quaker:StartQuake()
	DoDrop(self.inst)
end

return Myth_quaker

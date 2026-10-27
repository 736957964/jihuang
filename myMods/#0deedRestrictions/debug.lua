
AddPlayerPostInit(function(inst)
	if inst.components.health and inst.components.hunger and inst.components.sanity and not inst:HasTag("playerghost") then --实体有饥饿、精神、生命值
		inst.components.locomotor.walkspeed =  16 --步行速度
		inst.components.locomotor.runspeed = 18 --跑步速度
	end
	if inst.components.health and inst.components.health.invincible == false then 
		inst.components.health:SetInvincible(true) 
	end
	inst:AddTag('notarget') inst:AddTag('noattack ')
end)

local _G = GLOBAL
_G.chhData = nil
_G.chhInit = nil
function tablePrint(data, otherPrinting, SetTextNumber,isTablePrint2)
	if SetTextNumber == nil then SetTextNumber = 123 end
	if otherPrinting == nil then otherPrinting = true end
    if data then
		if(isTablePrint2) then 
			_G.chhData = data 
		else 
			_G.chhInit = data
			_G.chhData = data
		end
        if type(data) == 'number' or type(data) == 'string' then  
			print(string.format("-----打印数据表开始---数据:%s",data))
        elseif type(data) == 'boolean' then 
			print(string.format('-----打印数据表开始---布尔值:%s',tostring(data)))
		else
			print(string.format("-----打印数据表开始----当前预设物:%s",data.prefab or '无'))
			local dataString = '' local number = 1
			for k,v in pairs(data) do
				if type(v) == "string" or type(v) == "number" then
					if string.utf8len(dataString..(string.format("%s=>%s",k,v)))/SetTextNumber >= number then  dataString=dataString..'\n' number=number+1 end
					dataString = dataString..(string.format("%s=>%s",k,v))..' ◆ '
				elseif type(v) == 'boolean' then 
					if string.utf8len(dataString..(string.format("%s=>布尔%s",k,tostring(v))))/SetTextNumber >= number then  dataString=dataString..'\n' number=number+1 end
					dataString = dataString..(string.format("%s=>布尔%s",k,tostring(v)))..' ◆ '
				else
					if string.utf8len(dataString..(string.format("%s=>%s",k,type(v))))/SetTextNumber >= number then  dataString=dataString..'\n' number=number+1  end
                    if otherPrinting then dataString = dataString..(string.format("%s=>类:%s",k,type(v)))..' ◆ ' end
                end
			end
			if otherPrinting then dataString = dataString..'\n当前没有打印为nil的参数,可能会有参数但显示为0的问题 ◆ ' end
			print(dataString..'总长度'..(string.utf8len(dataString)))
			return dataString..'\n总长度'..(string.utf8len(dataString))
        end
        print('-----打印数据表结束-----')
    else
        print('--打印的数据为空--')
    end
end
function tablePrint2(data)
	tablePrint(data,nil,nil,true)
end
_G.tablePrint = tablePrint
_G.tablePrint2 = tablePrint2
-- local a = lfs.currentdir()
-- os.execute("mkdir JSON\\666")

AddPrefabPostInit("hound", function(inst) inst:DoTaskInTime(0, inst.Remove) end)
AddPrefabPostInit("icehound", function(inst) inst:DoTaskInTime(0, inst.Remove) end)
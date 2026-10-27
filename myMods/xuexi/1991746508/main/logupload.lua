local ismodmain = false
--自己设置一下 modkey 然后在 modmain里面 modimport一下就行
local modkey = "Myth_World"
local logtopath = false         --如果需要输出本地日志 请设置成true
local path = nil                --默认输出路径 可以自己设置
local DontTraceEntity = true    --堆栈追踪的时候 不详细展开实体 (太占空间了)
local TableTraceLevel = 2    --堆栈追踪的时候 表展开的等级 (太占空间了) 默认2
--如果没自己设置路径的话 要在mod目录创建一个log文件夹 log自动保存在里面
--如果上传的话 里面记得只是留个文件 不然wg的会自动删除空目录 st的不清楚

if not rawget(getfenv(1),"getdebugstack") then
    --是在modmain环境里
    ismodmain = true
end
if ismodmain and not TheSim then  --没有一键global 补一个
    GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})
end
local function getextendinfo()
--用于追加一些额外信息
    local str = ""
    if package.loaded["soraupdate/manager"] and SoraUpdate then
        str = str .. "SoraUpdateInfo:\n"
        local s,j = pcall(json.encode,SoraUpdate.data)
        str = str .. j or "Data Error" .."\n"
    end
    return str
end
local function formatvar(name,value,level,visit)  
    --格式化变量用于显示
    level = level or 1 
    visit = visit or {}
    local f = string.rep("\t",level+2)
    local t = type(value)
    if t == "table" then
        if visit[value] then return "visited "..tostring(name or "U").." : "..tostring(value or "nil") end
        visit[value] = true
        if DontTraceEntity and EntityScript.is_a(value,EntityScript) then return tostring(name or "U").." : "..tostring(value or "nil") end    --不展开实体 太大了
        local str = {}
        if level > TableTraceLevel then return tostring(name or "U").." : "..tostring(value or "nil") end
        if next(value) then
            local knum = 0      
            table.insert(str,tostring(name or "U").." : "..tostring(value).."{")
            for k,v in pairs(value) do
                if knum < 100 then      --一个表最多展开100项
                    table.insert(str,"\t"..formatvar(k,v,level+1,visit) .. ",")
                elseif knum == 100 then
                    table.insert(str,"...")
                end
                knum = knum +1
            end
            table.insert(str,"}")
        else
            table.insert(str,tostring(name or "U").." : "..tostring(value).."{} ")
        end
        return table.concat(str,"\n"..f)
    elseif t == "function" then
        local info = debug.getinfo(value)
        local source = info.source
        if #source > 100 then
            source = "load"
        end
        return "fn:"..tostring(name or "U").." src:"..source.."("..info.linedefined.."-"..info.lastlinedefined..")"
    end
    return tostring(name or "U").." : "..tostring(value or "nil")
end
local function getextendtrace(start)
--追踪堆栈上的local 和 upvalue
    local get = {}
    for i = start + 3,101,1 do
        
        local info = debug.getinfo(i)
        if info then
            table.insert(get,string.format("Level: %d Function Info:",i))
            for k,v in pairs(info) do
                table.insert(get,string.format("\t%s : %s",tostring(k),tostring(v)))
            end
            --local 
            local index = 0
            while true do
                index = index +1
                local k,name = debug.getlocal(i,index)
                if k then
                    table.insert(get,"\t\tLocal "..formatvar(k,name))
                else
                    break
                end
            end
            --upvalue
            local index = 0
            while info.func do
                index = index +1
                local k,name = debug.getupvalue(info.func,index)
                if k then
                    table.insert(get,"\t\tUpvalue "..formatvar(k,name))
                else
                    break
                end
            end
        else
            break
        end
    end
    return table.concat(get,"\n")
end
if logtopath and not path then
    if ismodmain then
        path = "../mods/"..modname.."/log/"
    else
        local info = debug.getinfo(getextendinfo).source
        local modname = info and info:match("%.%./mods/([^/]+)/")
        if modname then
        path = "../mods/"..modname.."/log/"
        end
    end
end
        
local function InitLogUpload()
    local logcache = nil
    local function clientlogcache(str)
        table.insert(logcache,str)
    end
    if not TheNet:IsDedicated() then
        logcache = {}
        AddPrintLogger(clientlogcache)
    end
    local oldgetdebugstack = getdebugstack
    --组包log
    local function getenvinfo()
        local info = ""
        return info 
    end
    --获取在线玩家信息
    local function getplayerinfo()
        local info = ""
        for k,v in pairs(AllPlayers or {}) do 
            if k and v then
                info = info..string.format("%s %s %s \n",v.name or "NoName",v.userid or "NoUserid",v.prefab or "UnKnow")
            end
        end
        return info 
    end
    
    local function getserverinfo()
        local info = ""
        --平台和服务器信息
        info = info .. string.format("PLATFORM : %s  IsServer: %s IsDedicated: %s World: %s  \n",PLATFORM or "UnKnow",tostring(TheNet:GetIsServer()),tostring(TheNet:IsDedicated()),TheWorld and TheWorld.prefab or "UnKnow")
        --开启的mod
        if ModManager then
            for k,v in pairs(ModManager.mods) do
                if k and v and v.modinfo then
                    info = info .. string.format("MOD : %s\t%s\t%s\t%s\n",v.modname or "UnKnow",v.modinfo.name or "UnKnowMod",v.modinfo.author or "UnKnowAuthor",v.modinfo.version or "UnKnow")
                    if v.modname then
                        local config, temp_options = KnownModIndex:GetModConfigurationOptions_Internal(v.modname, false)
                        if config and type(config) == "table" then
                            if type(temp_options) == "table" then
                                for kc,kv in pairs(temp_options) do
                                    info = info .. string.format("\tTempOption  %s  : %s \n",kc or "nil",kv or "nil")
                                end
                            end
                            for kc,kv in pairs(config) do
                                if type(kv) == "table" then 

                                    info = info .. string.format("\tConfig  %s  : %s \n",tostring( kv.name or "nil"),tostring(kv.saved or kv.default or "nil" ))
                                elseif type(kv) == "boolean" then
                                    info = info .. string.format("\tConfig  %s  : %s \n",tostring(kc or "nil"),tostring(kv and "True" or "false") )
                                else
                                    info = info .. string.format("\tConfig  %s  : %s \n",tostring( kc or "nil"),tostring(kv or "nil" ))
                                end
                            end
                        end
                    end
                end
            end
        end
        --WorldState
        if TheWorld and TheWorld.state then
            info = info .. "WorldState：\n"
            for k,v in pairs(TheWorld.state) do
                info = info .. string.format("\t  %s  : %s  \n",tostring(k or "nil"),tostring(v or "nil"))
            end
        end
        return info 
    end
    local banstr = {
            --筛除一些没意义的
        '^.*GetModsToLoad inserting moddir.*$',
        '^.*Overriding mod.+option.*$',
        '^.*applying configuration_options.*$',
        '^.*modimport:.*$',
        '^.*SimLuaProxy::QueryServer.*$',
        '^.*NotPatched.*$',
        '^.*Could not find anim.*$',
        '^.*MiniMapComponent::AddAtlas.*$',
        '^.*Could not preload undefined prefab.*$',
        '^.*Registering prefab file.*$',
        '^.*Mod: .+ %(.+%)%s+.*$',
        '^.*Validating portal.*$',
        '^.*Processing initializers with.*$',
        
    }
    local function getserverlog()
        local info = "Can't Read Server Log"
        local function onload(load_success, str)
            if load_success then
                info = str
            end
        end
        TheSim:GetPersistentString("../server_log.txt", onload)
        if logcache then
            info = table.concat(logcache,"\n")
        end
        local infotable = string.split(info,"\n")
        local infotablenew = {}
        local save
        for k,v in pairs(infotable) do
            save = true
            for _,str in pairs(banstr) do
                if v and v:match(str) then
                    save = false
                end
            end
            if save then
                table.insert(infotablenew,v)
            end
        end

        return table.concat(infotablenew,"\n")
    end
    local function packlog(ret,start)
        local retlog = table.concat(ret,"\n")
        local _,envinfo = pcall(getenvinfo)
        local _,playerinfo = pcall(getplayerinfo)
        local _,serverlog = pcall(getserverlog)
        local _,ExtendTrace = pcall(getextendtrace,start)
        local _,extendinfo = pcall(getextendinfo)
        local _,serverinfo = pcall(getserverinfo)
        
        local alllog = string.format(
[[---------------------Envinfo---------------------------
{
%s
}
---------------------Playinfo---------------------------
{
%s
}
---------------------Traceback--------------------------
{
%s
}
---------------------Extendinfo--------------------------
{
%s
}
---------------------ServerInfo-------------------------
{
%s
}   
---------------------Server_Log-------------------------
{
%s
}
---------------------ExtendTrace--------------------------
{
%s
}
]],envinfo or "ERROR",playerinfo or "ERROR",retlog or "ERROR",extendinfo or "",serverinfo or "ERROR",serverlog or "ERROR",ExtendTrace or "ERROR")
        --给饥荒加一份 方便其他modder排查
        local last = 1
        local num = 0
        TheSim:LuaPrint('----Logupload-ExtendTrace-Start----')
        for i=1,#ExtendTrace,1 do
            num = num +1 
            if num >3000 and ExtendTrace:byte(num+last-1) == 10 then
                TheSim:LuaPrint(ExtendTrace:sub(last,last+num-2))
                num=0
                last = i 
            end
            
        end
        TheSim:LuaPrint(ExtendTrace:sub(last,-1))
        TheSim:LuaPrint('----Logupload-ExtendTrace-End----')
        return alllog
    end

    function getdebugstack(res, start, top, bottom,...)
        start = (start or 1) + 2

        local logid = os.date("%Y-%m-%d_%H-%M-%S_")..(TheWorld and TheWorld.meta.session_identifier or "Load")
                ..(TheNet:GetIsServer() and ("_server_" .. TheShard:GetShardId()) or "_client")
        local ret = oldgetdebugstack(res,start,top,bottom,...)
        local success,topost = pcall(packlog,ret,start)
        if err then topost = err .."\n"..table.concat(ret,"\n") end
        TheSim:QueryServer("http://jh.flapi.cn/logupload.php?mod="..modkey.."&id="..logid,function() end,"POST",topost or "Error")--packlog(ret))
        --io.open()
        if logtopath and path then      --输出本地日志
            local file = io.open(path..logid..".log","w")
            if file then
                file:write(topost)
                file:close()
            end
        end
        print(#topost)
        if err then table.insert(topost,1,err) end
        --table.insert(ret,1,"已自动上报LOG,LogId = "..logid)
        local t = os.clock() +  #topost /102400     --认为每秒可以上传100K数据 则预计上传结束时间为t
        while os.clock() < t do end              --死循环卡住 等上传完成
        return ret
    end

    if ismodmain then
        --modmain 环境要补一下GLOBAL
        GLOBAL.getdebugstack = getdebugstack
    end
end

if ismodmain then
    AddSimPostInit(InitLogUpload)
elseif TheWorld then --引用的时候 TheWorld 已经生成了
    InitLogUpload()
else    --这个时候不在modmain里面 而且还没生成TheWorld 那么估计是在modmain里面require的 
    for k,v in pairs(ModManager.mods) do
        if k and v and v.postinitfns and v.postinitfns.SimPostInit then
            table.insert(v.postinitfns.SimPostInit,InitLogUpload)       --调皮 我自己来吧
            break
        end
    end
end


--这个组件用于保存玩家 换人之后需要的属性(一般是组件和对应需要保存的值)

local  needtosave = { --需要保存哪些呢
    myth_favorability = { --嫦娥好感度的积分
        jifen = true,
    },
    save_yutu_songs = { --玉兔的谱子和药粉
        songs = true,
    }
}

return Class(function(self, inst)
    assert(TheWorld.ismastersim, "好好学习天天向上")

    self.inst = inst

    local _world = TheWorld
    local _ismastershard = _world.ismastershard

    self._savedata = {}

    --下面开始瞎编
    if _ismastershard then
        inst:ListenForEvent("ms_newplayerspawned", function(world, player)
            if self._savedata[player.userid] ~= nil then
                for k, v in pairs(self._savedata[player.userid]) do
                    if player.components[k] ~= nil then
                        for k1,v1 in pairs(v) do
                            player.components[k][k1] = v1
                        end 
                        self._savedata[player.userid][k] = nil
                        --给组件留一个接口 有的组件更新数据之后需要刷新触发就可以用 
                        if player.components[k].DoneInfoLoad then
                            player.components[k]:DoneInfoLoad()
                        end
                    else
                        --说明这个玩家没有 那么继续保存
                    end
                end
            end
        end)
    end

    inst:ListenForEvent("ms_playerdespawnanddelete", function(inst,player)
        local save = {}
        save[player.userid] = {}
        for k,v in pairs(needtosave) do 
            if player and player.components[k]  ~= nil then
                save[player.userid][k] = {}
                --给组件留一个接口 有的组件平时不需要保存 只有换人的时候需要紧急处理 就用这个 比如换人时候处理保存需要的配方
                if player.components[k].PreInfoSave then
                    player.components[k]:PreInfoSave()
                end
                for k1,v1 in pairs(v) do
                    save[player.userid][k][k1] = player.components[k][k1]
                end
            end
        end
        if next(save) ~= nil then
			local success,a  = pcall(json.encode,save)
            if success then
                SendModRPCToShard(SHARD_MOD_RPC["myth_saveinfo"]["myth_saveinfo"],{"1","0"},a)    
			end
        end
    end)

    if _ismastershard then function self:AddPlayerInfo(playerid,infostr)
        if not self._savedata[playerid] then
            self._savedata[playerid] = {}
        end
        for k, v in pairs(infostr) do
            self._savedata[playerid][k] = v
        end
    end end

    if _ismastershard then function self:OnSave()
        return {_savedata = self._savedata}
    end end

    if _ismastershard then function self:OnLoad(data)
        if data and data._savedata then
            self._savedata = data._savedata
        end
    end end

end)

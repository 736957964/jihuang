--by : う丶青木
--常用功能
-------------------------------************* 局部化 ************--------------------------
local	_G = GLOBAL
local	Point,Vector3,type,tostring,tonumber,GetTime,pairs,ipairs,SpawnPrefab,TheSim,FRAMES,pcall,TheWorld,jsbao,jsjie =
		Point,Vector3,type,tostring,tonumber,GetTime,pairs,ipairs,SpawnPrefab,TheSim,FRAMES,pcall,TheWorld,json.encode,json.decode
local	Point,Vector3,type,tostring,tonumber,GetTime,pairs,ipairs = _G.Point,_G.Vector3,type,_G.tostring,_G.tonumber,_G.GetTime,pairs,ipairs
local	SpawnPrefab,TheSim,FRAMES,pcall,jsbao,jsjie,PI = _G.SpawnPrefab,_G.TheSim,_G.FRAMES,_G.pcall,_G.json.encode,_G.json.decode,_G.PI
local	table,next,string,TheNet,unpack,distsq,STRINGS,Sleep = _G.table,_G.next,string,_G.TheNet,_G.unpack,_G.distsq,_G.STRINGS,_G.Sleep
-------->>>>>>>>>>>>>>>>>>>>>>>>>>
local isstr = function(vla) return type(vla) == "string" end
local isnum = function(vla) return type(vla) == "number" end
local isnil = function(vla) return type(vla) == "nil" end
local isbool = function(vla) return type(vla) == "boolean" end
local istbl = function(vla) return type(vla) == "table" end
local isfnn = function(vla) return type(vla) == "function" end
local isuser = function(vla) return type(vla) == "userdata" end
-------->>>>>>>>>>>>>>>>>>>>>>>>>>
-------->>>>>>>>>>>>>>>>>>>>>>>>>>
-------->>>>>>>>>>>>>>>>>>>>>>>>>>	常用项	<<<<<<<<<<<<<<<<<<<<<<<--------------------------------------

-------->>>>>>>>>>>>>>>>>>>>>>>>>>	组件相关
inst:AddComponent("areaaware")								--添加组件
inst:RemoveComponent("talker")								--移除组件
-->>	组件附加说明
		self:OnRemoveFromEntity()							--在移除组件时, 会调用此方法
		self:OnRemoveEntity()								--在实体删除时, 会调用此方法
		
		self:OnSave()										--组件的数据保存方法
			return {},{}
		end

		self:OnLoad(data, newents)							--组件的数据载入方法
		self:LoadPostPass(newents, data)					--世界生成 -> 全实体生成 -> 载入保存数据后调用的组件方法
		
		self.inst:StartUpdatingComponent(self)				--启用对组件的更新函数
		self.inst:StopUpdatingComponent(self)				--停止对组件的更新函数
		self:OnUpdate(dt)
		
		self.inst:StartWallUpdatingComponent(self)
		self.inst:StopWallUpdatingComponent(self)
		self:OnWallUpdate(dt)
		
-------->>>>>>>>>>>>>>>>>>>>>>>>>>	事件监听相关
inst:ListenForEvent("qm_cc", function(owner, data)  end, owner)					--设置监听“qm_cc”事件【被监听者为owner】
inst:PushEvent("qm_cc", {q = "1", m = inst, cc = 9})							--推动事件给监听器
-->>	事件附加说明
																				--移除和'qm_cc'相关的所有监听事件
		for k,v in pairs(self.event_listening["qm_cc"]) do
			inst:RemoveEventCallback("qm_cc", v)
		end
		
		inst:RemoveAllEventCallbacks()											--取消全部监听
		
-------->>>>>>>>>>>>>>>>>>>>>>>>>>	计时器相关
inst:DoTaskInTime(1.5, inst.Remove)												--单步触发计时器
inst:DoPeriodicTask(30, function()  end, 0)										--周期触发计时器
																				-->>参1:每次周期时间
																				-->>参1:被执行的函数(默认参数1为inst)
																				-->>参3:计时器创建完毕后第n秒就开始执行, 缺省值为参1
																				
local task = inst:DoTaskInTime(1.5, function(inst, ...) end, ...)				--带参导入
task:Cancel()																	--停用计时器
local time = GetTaskRemaining(task)												--返回计时器剩余时间， (nil or 不足)时候返回 -1
local time = GetTaskTime(task)													--返回计时器下次时间， (nil or 不足)时候返回 -1
																				-->>[返回值 - GetTime() == 剩余时间]
																				
local task = inst:StartThread(function() while true do Sleep(0.1) end end)		--协程周期触发器[伪]
task:SetList(nil)																--取消协程周期触发器

require("scheduler")
scheduler:ExecuteInTime(0.05, function() Check_Mods() end)
scheduler:ExecutePeriodic(period, fn, limit, initialdelay, id, ...)				--周期， fn， 次数限制， 起始延迟， id or nil，  传入的参数
scheduler:KillTask(Check_Mods)

TheGlobalInstance:DoTaskInTime(1, function() end)

-------->>>>>>>>>>>>>>>>>>>>>>>>>>	特殊标签相关
inst:AddTag("noplayerindicator")												--不显示玩家目标指示器
inst:AddTag("multithruster")													--武器标签，  连击
inst:AddTag("NOCLICK")															--不可被点击, 查看
inst:AddTag("NOBLOCK")															--不可被查看, 建造不会被遮挡
inst:AddTag("ignorewalkableplatforms")											--忽略可行走的平台
inst:AddTag("notarget")															--不能被作为目标
inst:AddTag("CLASSIFIED")														--增加保密标签
inst:AddTag("irreplaceable")													--玩家携带下线后会掉落
inst:AddTag("hide_percentage")													--隐藏装备百分比
inst:AddTag("companion")														--友军标签
inst:AddTag("notraptrigger")													--不触发陷阱标签
inst:AddTag("noauradamage")														--不被光环攻击伤害
inst:AddTag("smallcreature")													--小动物标签
inst:AddTag("outofreach")														--AI层, 不拾取标签, AI不去拾取带有该标签的道具
inst:AddTag("show_spoilage")
inst.components.weapon:SetProjectile("blowdart_lava_projectile")				--设置武器攻击的弹丸	
inst:AddTag("debugnoattack")													--不可见
inst:AddTag("shadow")															--影子, 加入该标签后, AI不会进行对该目标进攻ThePlayer:AddTag("shadow")
inst:AddTag("noauradamage")														--不被光环攻击伤害
inst:AddTag("notarget")															--不能被作为目标
inst:RemoveTag("pollinator")													--移除标签
inst:HasTag("player")															--判定有"player"标签
inst:HasTag("playerghost")														--判定有"playerghost"标签
inst:IsStandState("quad")														--判定有"quad" 行为标签
inst:SetStandState("quad")														--设置增加"quad" 行为标签
inst.sg:RemoveStateTag("busy")													--设置取消"busy" 行为标签
inst.sg:AddStateTag("parrying")					
inst.sg:HasStateTag("parrying")					
inst.sg:HasState("hit")															--判断是否有"hit"行为函数

-------->>>>>>>>>>>>>>>>>>>>>>>>>>	物理性相关
inst.Physics:CollidesWith(COLLISION.OBSTACLES)									--增加对船的冲突碰撞 （不会被撞退）
MakeInventoryPhysics(inst)														--增加物理性【物品】
RemovePhysicsColliders(inst)													--取消物理性碰撞	RemovePhysicsColliders(ThePlayer)
inst.Physics:SetDontRemoveOnSleep(true)											--休眠状态下物理碰撞依旧生效
inst.Physics:SetActive(false)													--关闭所有物理性(物理碰撞机全面暂停)
if inst.Physics:IsActive() then end												--逻辑判断物理机是否处于工作状态

inst.Physics:SetMass(0)															--自由落体速率   0为不掉落，默认1	质量
inst.Physics:SetSphere(.5)														--物理范围
inst.Physics:SetFriction(.1)													--设置摩擦
inst.Physics:SetDamping(0)														--设置阻尼		对速度的衰弱
inst.Physics:SetRestitution(.5)													--设置恢复		落地反弹力	反作用力
inst.Physics:SetCollisionGroup(COLLISION.ITEMS)									--设置碰撞组
inst.Physics:ClearCollisionMask()												--清除冲突面	SetCollisionMask
inst.Physics:CollidesWith(COLLISION.WORLD)										--增加冲突面
inst.Physics:CollidesWith(COLLISION.OBSTACLES)									--增加冲突面
inst.Physics:SetCapsule(rad, 1)													--物理碰撞体积，碰撞高度
inst.Physics:SetCylinder(.6, 2)													--中空类型的物理性
inst.Physics:SetTriangleMesh(PLAYER_COLLISION_MESH)								--设置三角形网格	
phys:SetDontRemoveOnSleep(true)													--休眠时，物理特性不删除
					
inst.Physics:SetCollides(false)													--设置碰撞关闭， 设定坐标后再开启碰撞
inst.Physics:ConstrainTo(target.entity)											--将自己约束到目标实体身上		nil
					
inst.Physics:GetMass()															--获取质量
inst.Physics:GetRadius()														--获取物理碰撞范围
inst.Physics:Teleport(x,y,z)													--物理传送
inst.Physics:ClearTransformationHistory()										--清除转换历史记录
Vector3(inst.Physics:GetVelocity()):LengthSq() > .1)							--获取速度
inst.Physics:SetMotorVelOverride(0,0,0)											--物理运行覆盖
inst.Physics:ClearMotorVelOverride()											--清除运行
inst.Physics:SetCollisionCallback(OnCollide)									--碰撞回调  function(inst, other) end
inst.Physics:SetCollisionMask(COLLISION.WORLD, COLLISION.OBSTACLES, COLLISION.SMALLOBSTACLES, COLLISION.GIANTS)
																				--设置本地碰撞掩码
if not TheWorld.ismastersim then
	inst.Physics:SetLocalCollisionMask(COLLISION.GROUND)
end

local cur_speed = self.inst.Physics:GetMotorSpeed()								

local x,y,z = self.inst.Physics:GetMotorVel()

function TemporarilyRemovePhysics(obj, time)
    local origmask = obj.Physics:GetCollisionMask()
    obj.Physics:ClearCollisionMask()
    obj.Physics:CollidesWith(COLLISION.WORLD)
    obj:DoTaskInTime(time, function(obj)
        obj.Physics:ClearCollisionMask()
        obj.Physics:SetCollisionMask(origmask)
    end)
end


if inst.Physics:CheckGridOffset(0,-1) then table.insert(angles, -90) end				--检测物理碰撞偏移
if inst.Physics:CheckGridOffset(0,1) then table.insert(angles, 90) end
if inst.Physics:CheckGridOffset(-1,0) then table.insert(angles, 180) end
if inst.Physics:CheckGridOffset(1,0) then table.insert(angles, 0) end

-------->>>>>>>>>>>>>>>>>>>>>>>>>>	部分 C层组件 and UI模块 相关
-----------------------------------------------------------------------------------实体元
inst.entity:SetIsPredictingMovement											--设置运动预测开关
ThePlayer:EnableMovementPrediction(true)									--切换延迟补偿，行动预测
SendRPCToServer(RPC.DirectWalking, x, z)									--关闭补偿后使用RPC移动
SendRPCToServer(RPC.StopWalking)											--停止移动
ThePlayer.components.locomotor:GoToPoint(Point(0,0,0))						--开启补偿后使用延迟移动
inst.entity:AddRoadManager()												--添加道路管理器  TheGlobalInstance
inst.entity:MoveToFront()													--搬至前端
inst.entity:AddImage()														--添加图层管理器
inst.entity:AddFollower()													--添加追随管理器
inst.entity:AddAnimState()													--添加动画管理器
inst.entity:GetParent()														--获取追随者				
inst.entity:AddShardClient()												--添加碎片世界管理器
inst.entity:Show()															--实体隐藏	
inst.entity:SetParent(ta.entity)											--设置追随者	
inst.entity:AddEnvelopeManager()											-- 未知	
inst.entity:SetClickable(false)												--是否允许点击
inst.entity:AddMapGenSim()													--添加根源地图管理器
inst.entity:GetDebugString()												--获取debug打印数据
inst.entity:FlattenMovementPrediction()										--平移运动预测
inst.entity:AddLabel()														--添加字体显示管理器
inst.entity:AddPhysics()													--添加物理碰撞机管理器
inst.entity:Retire()														--退休 [被删除]
inst.entity:SetPrefabName("11")												--设置预设名
inst.entity:WorldToLocalSpace()	
inst.entity:CanPredictMovement()											--是否开启了运动预测
inst.entity:IsVisible()														--是否是有效实体	
inst.entity:SetCanSleep(false)												--是否允许休眠	
inst.entity:AddLight()														--添加光照管理器
inst.entity:LocalToWorldSpaceIncParent	
inst.entity:GetPrefabName()													--获取预设名	
inst.entity:AddTextEditWidget()												--添加可输入文本管理器
inst.entity:AddNetwork()													--添加网络传输管理器
inst.entity:SetSelected(true)												--可被选择检查
inst.entity:AddTextWidget()													--添加文本管理器
inst.entity:AddPostProcessor()												-- 未知
inst.entity:AddTag("qm")													--增加标签			
inst.entity:EnableMovementPrediction(true)									--启动运动预测
inst.entity:AddWaveComponent()	
inst.entity:Hide()															--实体隐藏	
inst.entity:LocalToWorldSpace	
inst.entity:GetName															--获取名字
inst.entity:AddGroundCreepEntity()											--添加地皮蠕变管理器	
inst.entity:SetName															--设置名字
inst.entity:AddGroundCreep													--添加地皮管理器
inst.entity:AddMapExplorer													--添加地图预览管理器
inst.entity:AddDebugRender													--添加debug调试器
inst.entity:HasTag("qm")													--检测是否有该标签
inst.entity:AddSoundEmitter													--添加音轨管理器
inst.entity:AddLightWatcher													--添加光照感知管理器
inst.entity:AddClientSleepable	
inst.entity:FrustumCheck													--检查物体是否在相机的视锥里
inst.entity:AddGraphicsOptions	
inst.entity:AddFontManager	
inst.entity:AddVideoWidget	
inst.entity:AddImageWidget	
inst.entity:AddUITransform	
inst.entity:AddMiniMap	
inst.entity:SetPristine	
inst.entity:IsValid	
inst.entity:AddMiniMapEntity	
inst.entity:SetAABB	
inst.entity:CallPrefabConstructionComplete	
inst.entity:AddShadowManager	
inst.entity:SetInLimbo	
inst.entity:GetGUID	
inst.entity:AddDynamicShadow	
inst.entity:AddStaticShadow	
inst.entity:AddAccountManager	
inst.entity:AddParticleEmitter	
inst.entity:MoveToBack	
inst.entity:AddMap	
inst.entity:AddPathfinder	
inst.entity:RemoveTag	
inst.entity:AddTwitchOptions	
inst.entity:AddTransform	
inst.entity:AddMapLayerManager	
inst.entity:AddShardNetwork	
inst.entity:FlushLocalDirtyNetVars											--清理本地net数据？
inst.entity:IsAwake	
inst.entity:AddVFXEffect	
-------->>>>>>>光照组件
inst.entity:AddLight()
inst.Light:Enable(true)										-- 开启照明    false为关闭
inst.Light:SetIntensity(.75)								-- 光照强度.99为强光	1很方
inst.Light:SetColour(200 / 255, 150 / 255, 50 / 255)
inst.Light:SetFalloff(0.5)									-- 最大范围再向外辐射的光效，1几乎不辐射
inst.Light:SetRadius(6)										-- 照明范围
inst.Light:EnableClientModulation(false)					-- false 不读取客户端的设置，  true 读取客户端本地数据
--------
inst.Light:GetRadius()										-- 获取照明范围
inst.Light:GetFalloff()										-- 获取辐射力度
inst.Light:GetColour()										-- 获取颜色
inst.Light:GetIntensity()									-- 获取照明强度
inst.Light:GetCalculatedRadius()							-- 获取计算半径

-------->>>>>>>追随组件
local inst = SpawnPrefab("ash")
inst.entity:AddFollower()
inst.Follower:FollowSymbol(A.GUID, "swap_object", 50, -25, 0)		---左0右偏移,  -上0下偏移
inst.Follower:FollowSymbol(0, "", 0, 0, 0)

-------->>>>>>>字体组件
inst.entity:AddLabel()
inst.Label:SetFontSize(50)										--字体大小
inst.Label:SetFont(DEFAULTFONT)									--字体库
inst.Label:SetWorldOffset(0, 3, 0)								--偏移量【世界坐标系数】
inst.Label:SetUIOffset(0, 0, 0)									--偏移量【像素坐标系数】
inst.Label:SetColour(1, 1, 1)									--设置颜色
inst.Label:Enable(true)											--设置开启显示
inst.Label:SetText("1111")

-------->>>>>>>图形组件
inst.entity:AddImage()
inst.Image:SetTexture("images/inventoryimages.xml", "spear_rose.tex") 
inst.Image:GetSize()											--local w,h = inst.Image:GetSize()
inst.Image:SetSize()											
inst.Image:SetBlendMode()
inst.Image:SetAlphaRange()
inst.Image:SetEffect()
inst.Image:SetTextureHandle()
inst.Image:SetTint(1,1,1,1) 
inst.Image:SetWorldOffset(0,3,0) 								-- 左右  上下
inst.Image:SetUIOffset(12,0,0) 									-- 左右  上下
inst.Image:Enable(true) 

-------->>>>>>>音频组件
inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/glommer_bell", nil, nil, true)			--单次播放
inst.SoundEmitter:PlaySound("dontstarve/music/lava_arena/fight_1", "bgm")						--循环播放	
inst.SoundEmitter:SetVolume("bgm", 2)															--设置音量
inst.SoundEmitter:KillSound("bgm")																--关闭音乐
inst.SoundEmitter:KillAllSounds()																--关闭所有音乐
inst.SoundEmitter:OverrideVolumeMultiplier(speed)												-- speed 速率
inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/antlion/sfx/ground_break", { size = math.pow(stage / NUM_CRACKING_STAGES, 2) })

-------->>>>>>>动画组件
if inst.AnimState:IsCurrentAnimation("open_loop") then end				--判定当前播放的动画
inst.AnimState:AnimDone()												--获取动画是否为正常播放完毕的 【非打断】
inst:ListenForEvent("animover", inst.Remove)							--监听动画结束，动画结束后删除
inst.entity:AddAnimState()												--创建图像动画集
inst.AnimState:SetBank("ceshi")											--设置动画组
inst.AnimState:SetBuild("ceshi")										--设置动画图层包
inst.AnimState:SetBankAndPlayAnimation("floating_item", "left")			--设置动画组，并同时播放动画，  双推
inst.AnimState:PlayAnimation("sway_loop_agro", true)					--指定播放动作
inst.AnimState:PushAnimation("dart_long", false)						--播放完上一段动画后播放本动画
inst.AnimState:OverrideSymbol("swap_object", "swap_qmwq", "swap_qm7")	--覆盖图层包
inst.AnimState:BuildHasSymbol("swap_object")							--检查是否带有特定特征符
inst.AnimState:Show("HAIR_HAT")											--显示特征符图层
inst.AnimState:Hide("HAIR_NOHAT")										--隐藏特征符图层
inst.AnimState:OverrideMultColour(0, 0, 0, 1)							--覆盖颜色
inst.AnimState:SetAddColour(0, 1, 0, 1)									--设置增加颜色
inst.AnimState:GetAddColour()											--获取被增加的颜色
inst.AnimState:SetMultColour(0, 1, 0, 1)								--设置颜色		服务端版
inst.AnimState:GetMultColour()											--获取颜色
inst.AnimState:OverrideShade(1)											--设置着色	（0 - 1）  纯黑 -- 彩色
inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)				--设置图层样式，  OnGround=1, 地皮    Default=0,默认
inst.Transform:SetRotation(45)											--设置旋转角度
inst.AnimState:SetFinalOffset(1)										--SetSortWorldOffset	inst.AnimState:SetSortWorldOffset(0, 0, 0)
inst.AnimState:SetLayer(LAYER_BACKGROUND)								--设置图层覆盖优先度	1=地皮	覆盖优先级		2不遮挡		3=后端  5=前端
inst.AnimState:SetSortOrder(3)											--同上			1=最低优先度 图层覆盖优先级相同时生效
--[==[
	inst.AnimState:SetOrientation(1)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
--]==]
inst.Transform:SetScale(2, 2, 2)										--设置实体规模大小
inst.AnimState:SetLightOverride(1)										--设置自身光照等级	0-1	1=夜幕不遮挡	0=随夜幕变暗
inst.AnimState:SetHaunted(true)											--设置闪耀(作祟效果)    false为关闭
inst.AnimState:GetCurrentAnimationLength()								--获取当前动画时间总长度
inst.AnimState:GetCurrentAnimationTime									--获取当前动画时间被播放长度
local k = 1 - inst.AnimState:GetCurrentAnimationTime() / inst.AnimState:GetCurrentAnimationLength()
inst.AnimState:SetPercent("grow", 0.5)									--设置播放动画到50%的帧数位置
inst.AnimState:PlayAnimation("idle", true)
inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())		--在指定位置开始播放动画
inst.AnimState:GetCurrentFacing()										--获取当前动画的朝向 象限
inst.AnimState:SetHighlightColour(r, g, b, 0)							--设置高亮色彩
inst.AnimState:SetScale(scale, widthscale)								--设置图像宽和高，负数为旋转90°
inst.AnimState:FastForward(t)											--快进播放
inst.AnimState:SetDeltaTimeMultiplier(speed)							--设置动画播放速率	1=默认	.5=变慢50%
inst.AnimState:SetOceanBlendParams(TUNING.OCEAN_SHADER.EFFECT_TINT_AMOUNT)	--饱和度， 0=全量，  1=纯黑
inst.AnimState:SetScale(1,1)											--设置图层[长],[宽]度
inst.AnimState:SetErosionParams(0, 0.1, 1.0)							--设置淡出效果(恢复状态为 0, 0.1, 1.0)
inst.AnimState:AddOverrideBuild("fossilized")							--添加覆盖建设
inst.AnimState:ClearOverrideBuild("fossilized")							--明确清理覆盖建设
																		--淡出参数(叠加图大小),(叠加图扩散大小),(透明度，位深)
x,y,z = inst.AnimState:GetSymbolPosition("hat",0,0,0)					--获取Symbol的坐标点

inst.AnimState:SetFloatParams(-0.05, 1.0, self.bob_percent)				--设置漂浮参数	1. 剪切区域,高度 y	2.十字星		3.上下漂浮值
inst.AnimState:SetFloatParams(0.0, 1.0, 0.0)							--十字星以下全部遮罩
		inst:AddComponent("amphibiouscreature")
		inst.components.amphibiouscreature:SetBanks("wilson", "wilson")
		MakeInventoryFloatable(inst, "med", nil, 0.85)

inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")		--全屏泛光[低光]  [高光为"shaders/anim.ksh"]

inst.Transform:SetNoFaced()												--无面向
inst.Transform:SetTwoFaced()											--两面向
inst.Transform:SetFourFaced()											--四面向
inst.Transform:SetSixFaced()											--六面向	上下左右+左下、右上
inst.Transform:SetEightFaced()											--八面向

-------->>>>>>>net数据块
net_bool(inst.GUID,"inst.qmmmm","QM_jianting")						-- 布尔值 true false
net_tinybyte(inst.GUID,"inst.qmmmm","QM_jianting")					-- 3位的无符号整数	[ 0 .. 7 ]
net_smallbyte(inst.GUID,"inst.qmmmm","QM_jianting")					-- 6位的无符号整数	[ 0 .. 63 ]
net_byte(inst.GUID,"inst.qmmmm","QM_jianting")						-- 8位的无符号整数	[ 0 .. 255 ]
net_shortint(inst.GUID,"inst.qmmmm","QM_jianting")					-- 16位有符号整数	[ -32767 .. 32767 ]
net_ushortint(inst.GUID,"inst.qmmmm","QM_jianting")					-- 16位无符号整数	[ 0 .. 65535 ]
net_int(inst.GUID,"inst.qmmmm","QM_jianting")						-- 32位有符号整数	[ -2147483647 .. 2147483647 ]
net_uint(inst.GUID,"inst.qmmmm","QM_jianting")						-- 32位无符号整数	[ 0，4294967296 ]
net_float(inst.GUID,"inst.qmmmm","QM_jianting")						-- 32位浮点
net_hash(inst.GUID,"inst.qmmmm","QM_jianting")						-- 32位哈希字符串的指定
net_string(inst.GUID,"inst.qmmmm","QM_jianting")					-- 可变长字符串		#str 8000 - 8100
net_entity(inst.GUID,"inst.qmmmm","QM_jianting")					-- 实体实例				:set(inst)
net_bytearray(inst.GUID,"inst.qmmmm","QM_jianting")					-- 8位无符号整数数组（最大尺寸= 31）[0 .. 255]
net_smallbytearray(inst.GUID,"inst.qmmmm","QM_jianting")			-- 6位无符号整数数组（最大尺寸= 31）[0 .. 63]
net_event(inst.GUID,"inst.qmmmm","QM_jianting")						-- 事件推送			net_event:push()

inst._NeT = net_smallbyte(inst.GUID, "_NeT", "QM_NeT")
inst:ListenForEvent("QM_NeT", inst.Remove)
inst._NeT:set_local(5)
inst._NeT:set(5)
inst._NeT:value()

AddPrefabPostInit("player_classified",function(inst)
	inst._DHK = GLOBAL.net_string(inst.GUID, "inst._zizcc", "QM_dhkxx")
	--inst:ListenForEvent("QM_dhkxx", function(inst) print(#inst._DHK:value()) end)
end)

-------->>>>>>>TheShard数据
TheShard:GetShardId()												-- 返回当前世界编号 "2" 字符串
TheShard:IsPlayer()													-- 返回是否为 代理玩家  【服务端false  主机true】
TheShard:IsMigrating("KU_uGVY9vC8")									-- 返回是否正在迁移
TheShard:GetSlavePlayerCounts(5)									-- 返回计分板标识符
TheShard:IsMaster()													-- 返回是否为主世界	
TheShard:SetSlaveLoading(true)										-- 未知 false	
TheShard:GetDefaultShardEnabled()									-- 返回是否启用了多层配置
TheShard:StartMigration(玩家id，目标世界id)							-- 迁移玩家
TheShard:IsSlave()													-- 返回是否为从属世界

-------->>>>>>>实体地图(小图标相关)组件
inst.entity:AddMiniMapEntity()
inst.MiniMapEntity:SetIcon("atrium_key.png")								--添加图标层
inst.MiniMapEntity:SetPriority(15)											--设置优先级
inst.MiniMapEntity:SetCanUseCache(false)									--可以使用缓存 ？
inst.MiniMapEntity:SetDrawOverFogOfWar(true)								--战争迷雾是否覆盖
inst.MiniMapEntity:SetRenderOnTopOfMask( true )								--设置渲染层
inst.MiniMapEntity:SetEnabled(false)										--设置是否生效显示
inst.MiniMapEntity:SetRestriction("")										--"nightmaretracker"
inst.MiniMapEntity:CopyIcon(target.MiniMapEntity)							--拷贝目标数据
inst.MiniMapEntity:SetIsProxy(true)											--设置为替代物
-------->>>>>>>常规Sim组件
local x,y,z = inst.Transform:GetWorldPosition()							--获取实体 inst 当前的世界坐标
local ens = TheSim:FindEntities(x, 0, z, 6, {"locomotor","bbbb"}, {"FX"},{"player","aaa"})
--ens抓取后返回的一个表,	x,0,z 以当前给定的坐标为中心索引，   6 半径系数，  
--{"locomotor","bbbb"}		在索引时，每个物质必须同时具备给定的所有标签才合格  
--{"FX"}					在索引时，每个物质必须没有给的每个标签
--{"player","aaa"}			在索引时，每个物质有其中一个标签就合格

local mubiao = FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags) -- 获取最近的一个目标
--【目标单位{内部自动获取目标坐标}】【范围】【fn(v[被搜索的目标变量],inst[自身目标变量])判定true或fales{ nil为真 }】
--【必须同时有1和2标签，可以nil】【不能有3或4标签，可以nil】【至少有一个标签5或者6，可以nil】
------------------------------------->>>>>>> UI相关模块部分解释 <<<<<<<<--------------------------------------
ThePlayer.HUD.controls.crafttabs:Hide()											--制作栏
ThePlayer.HUD.controls.inv:Hide()												--道具栏
ThePlayer.HUD.controls.containerroot_side:Hide()								--背包栏
ThePlayer.HUD.controls.item_notification:Hide()									--未知
ThePlayer.HUD.controls.status:Hide()											--右上角 血 san 饱食度
ThePlayer.HUD.controls.status.brain:Hide()										--san
ThePlayer.HUD.controls.status.stomach:Hide()									--饱食度
ThePlayer.HUD.controls.status.heart:Hide()										--血槽
ThePlayer.HUD.controls.status.beaverness:Hide()									--木头值
ThePlayer.HUD.controls.clock:Hide()												--时间时钟
ThePlayer.HUD:Toggle()															--[隐藏 or 显示] 所有UI

ThePlayer.HUD.controls.status.temperature:Hide()								--温度			workshop-100010057
ThePlayer.HUD.controls.status.tempbadge:Hide()									--温度小头像	workshop-100010057
ThePlayer.HUD.controls.seasonclock:Hide()										--季节时钟		workshop-100010057


----------------------------->>>>>>>	Widget类, 以及继承至 Widget 的类
self.inst.UITransform:UpdateTransform()											--刷新UI尺寸
Widget:IsDeepestFocus()															--是否被指针聚焦【如果焦点在子实体上，返回false】		返回值true
Widget:OnMouseButton(button, down, x, y)										--在被点击时候调用
Widget:MoveToBack()																--搬到底层
Widget:MoveToFront()															--搬到前段
Widget:OnFocusMove(dir, down)													--在被指针聚焦时调用
Widget:IsDeepestFocus()															--获取是否为聚焦状态【本体，不含父集】
Widget:IsVisible()																--是否为显示状态
Widget:OnRawKey(key, down)														--在被聚焦时候，按键行为fn
Widget:OnTextInput(text)														--在被输入字符串时候调用
Widget:ScaleTo(from, to, time, fn)												--变换大小【动画】【指定从大小，变换到大小，时间，完成后调用【可nil】】
Widget:MoveTo(from, to, time, fn)												--移动位置【动画】【指定从位置，移动到位置，时间，完成后调用【可nil】】
Widget:CancelMoveTo(run_complete_fn)											--|取消移动【可nil】
Widget:TintTo(from, to, time, fn)												--变换颜色【动画】
Widget:ForceStartWallUpdating()													--强制启动动画完成之前的设定
Widget:ForceStopWallUpdating()													--强制停止动画效果
Widget:GetParent()																--获取父体
Widget:GetChildren()															--获取子表 返回 {}
Widget:RemoveChild(child)														--删除指定子体
Widget:KillAllChildren()														--删除全部子体
Widget:AddChild(child)															--增加指定子体
Widget:Hide()																	--实体显示
Widget:OnHide()																	--在实体被显示时候调用
Widget:Show()																	--实体隐藏
Widget:OnShow()																	--在实体被隐藏时候调用
Widget:Kill()																	--删除自己
Widget:GetWorldPosition()														--获取在世界上的坐标	Vector3
Widget:GetPosition()															--获取被附加后的偏移坐标	Vector3
Widget:GetLocalPosition()														--获取被附加后的偏移坐标【同上，函数功能一模一样】Vector3
Widget:Nudge(offset)															--在现有偏移坐标上 + offset坐标
Widget:SetPosition(pos, y, z)													--设置坐标
Widget:UpdatePosition(x, y)														--设置坐标【同上】
Widget:SetRotation(angle)														--设置旋转
Widget:SetScaleMode(mode)														--设置缩放模式【0原始	1满屏	2均衡	3固定比例	4非动态】
Widget:SetScale(pos, y, z)														--设置大小比例【0-1】
Widget:HookCallback(event, fn)													--设置监听事件【self.callbacks[event] = fn】
Widget:SetVAnchor(anchor)														--设置位置【上下便宜  0居中,1顶对齐,2底对齐】
Widget:SetHAnchor(anchor)														--设置位置【左右偏移  0居中,1左对齐,2右对其】
Widget:StartUpdating()															--开启循环更新【:OnUpdate(dt)】
Widget:StopUpdating()															--停止循环更新【:OnUpdate(dt)】
Widget:SetFadeAlpha(alpha, skipChildren)										--设置透明度【参数2，为nil时，子体同步设置】
Widget:SetCanFadeAlpha(fade, skipChildren)										--设置可以被调整透明度【true or false ，true or nil，为nil时，子体同步设置】
Widget:SetClickable(val)														--设置可否被点击【true or false】
Button:SetControl(CONTROL_ACCEPT)												--设置点击需要的按键	CONTROL_ACCEPT左键[29]		CONTROL_CANCEL右键[30] or CONTROL_SECONDARY 编码[1]
function Widget:OnControl(control, down)					
	if Widget._base.OnControl(self, control, down) then					
		return true																--如果子实体按键有响应就传递给子实体执行
	end
	if not down then
		if control == CONTROL_ACCEPT then			--左键抬起时
			if self.onclick then
				self.onclick()
			end
			return true
		elseif control == CONTROL_CANCEL then		--右键抬起时
			if self.onrlick then
				self.onrlick()
			end
			return true
		end
	end
end
Widget:SetOnClick(function() end)												--被点击时调用			点击抬起时执行
Button:SetWhileDown(function() end)												--被点击按住时候调用	0.03333秒 / 次
Widget:FollowMouse()															--开启跟随指针
Widget:StopFollowMouse()														--停止跟随指针
Widget:GetScale()																--获得大小比例【优先获取父体】	
Widget:GetLooseScale()															--获取大小比例【自己】
Widget:GetDeepestFocus()														--获取被指针聚焦的实体【优先级：子体】
Widget:GetFocusChild()															--获取被指针聚焦的实体【子体】
Widget:ClearFocus()																--取消被聚焦状态【调用self:OnLoseFocus() 和 self.onlosefocusfn()】
Widget:SetFocus()																--设置聚焦状态【调用self:OnGainFocus() 和 self.ongainfocusfn()】
Widget:SetHoverText(text, params)												--设置指针悬停信息
--[[
A:SetHoverText("111",{})						--参数2详细↓
A:ClearHoverText()								--删除悬停信息
{	font		=	DEFAULTFONT,				--悬停文本字体
	font_size	=	28,							--文本字体大小
	region_h	=	1000,						--设置区域
	region_w	=	40,							--设置区域
	wordwrap	=	true,						--自动换行
	offset_x	=	0,							--坐标偏移
	offset_y	=	0,							--坐标偏移
	colour		=	{1,1,1,1},					--设置色彩
	bg		=	true,							--悬停开启背景框  false为不启用
	bg_atlas	=	"images/frontend.xml",		--设置xml
	bg_texture	=	"scribble_black.tex",		--设置tex
}
]]

----------------------------->>>>>>>	Text类, 以及继承至 Text 的类
self:AddChild(Text(DEFAULTFONT, 25, "1111" or nil))
DEFAULTFONT																		--默认字体(小描边, 我常用的字体)
DIALOGFONT																		--对话框字体
TITLEFONT																		--标题字体
UIFONT																			--界面字体
BUTTONFONT																		--按钮字体(无描边，数字比汉字高)		--这个也不错
NEWFONT																			--新字体(无描边)
NEWFONT_SMALL						
NEWFONT_OUTLINE						
NEWFONT_OUTLINE_SMALL						
NUMBERFONT																		--数字体(有描边)
TALKINGFONT						
SMALLNUMBERFONT																	--小字体(有描边,数字略模糊)
BODYTEXTFONT
CODEFONT

Text:SetColour(r, g, b, a)															--设置字体颜色
Text:SetOverColour(0,1,1,1)															--聚焦时换色
Text:GetColour()																	--获取字体颜色 local r, g, b, a
Text:SetHorizontalSqueeze(squeeze)													--挤压【0-1】
Text:SetFadeAlpha(a, skipChildren)													--设置透明度【最后 * a】
Text:SetAlpha(a)																	--指定透明度
Text:SetFont(font)																	--设置字体库
Text:SetSize(sz)																	--设置字体大小
Text:SetRegionSize(w,h)																--设置区域大小【像素级】
Text:GetRegionSize()																--获取区域大小【没被指定时，会自动计算字符串总大小】
Text:ResetRegionSize()																--复位区域大小
Text:SetString(str)																	--设置显示字符串
Text:GetString()																	--获取被设置的字符串  返回 ""
Text:SetTruncatedString(str, maxwidth, maxchars, ellipses)							--设置最大字符串字数【字符串，最大区域长度，最大字数，true or "..."】
Text:SetVAlign(anchor)																--字体上下对齐【】
Text:SetHAlign(anchor)																--字体左右对齐【ANCHOR_LEFT=左】
Text:EnableWordWrap(enable)															--设置自动换行【true】
Text:EnableWhitespaceWrap(enable)													--启用“空格换行”	【true】

----------------------------->>>>>>>	TextEdit类, 以及继承至 TextEdit 的类
self:AddChild( TextEdit( DEFAULTFONT, 25, "" ) )
TextEdit:SetIdleTextColour(r,g,b,a)													--设置非输入状态时的字体颜色
TextEdit:SetEditTextColour(r,g,b,a)													--设置在输入状态时的字体颜色
TextEdit:SetEditCursorColour(r,g,b,a)												--设置光标的颜色
TextEdit:ShowEditCursor(true)														--显示光标
TextEdit:SetString(str)																--指定字符串
TextEdit:SetAllowNewline(allow_newline)												--允许换行【true】
TextEdit:SetForceEdit(true)															--设置“正在编辑”状态 【true】
TextEdit:SetEditing(true)															--设置“能被编辑”状态 【true】
TextEdit:OnMouseButton(button, down, x, y)											--在点击时调用
TextEdit:ValidateChar(text)															--验证字符串【？】
TextEdit:ValidatedString(str)														--过滤掉【？】
TextEdit:SetTextLengthLimit(2)														--限制字节数
TextEdit:SetCharacterFilter("1234567890")											--输入限制【仅限此类字符串】
TextEdit:EnableScrollEditWindow(true)												--滚动编辑窗口
TextEdit:SetPassControlToScreen(CONTROL_CANCEL, true)								--设置传递控制到屏幕[输入时，按键在游戏内有操作行为]
TextEdit.OnStopForceEdit = function() self:Close() end								--在停止编辑后调用
TextEdit:EnableRegionSizeLimit(enable)												--是否开启区域限制【默认false】
TextEdit:SetTextConversion(in_char, out_char)										--设置文本转换【把当前输入的字符替换成设置的字符】
TextEdit.OnTextInputted()															--有按键输入后调用
TextEdit.OnTextEntered = function(str) end											--验证整体字符串

----------------------------->>>>>>>	Image类, 以及继承至 Image 的类
self:AddChild( Image("images/textboxes.xml", "textbox_long.tex") )
Image:SetAlphaRange(min, max)														--设置可以被透明的最小和最大值
Image:SetTexture("images/textboxes.xml", "textbox_long.tex")						--设定成像
Image:SetMouseOverTexture(atlas, tex)												--设置指针悬停时的图像
Image:SetDisabledTexture(atlas, tex)												--设置禁用时的图像
Image:SetSize(w,h)																	--设置图像大小(像素级， 自动缩放大小)
Image:GetSize()																		--获取图像大小比例(像素级)
Image:ScaleToSize(w, h)																--按设定像素 / 原始大小比例
Image:SetTint(r,g,b,a)																--设置颜色覆盖
Image:SetFadeAlpha(a, skipChildren)													--按比例设置透明度
Image:SetVRegPoint(anchor)															--设置...  就叫 中心点 吧		0,1,2
Image:SetHRegPoint(anchor)															--设置...  就叫 中心点 吧		0,1,2
Image:SetUVScale(xScale, yScale)							
Image:SetBlendMode(BLENDMODE.Additive)												--设置混合模式（0-6）

----------------------------->>>>>>>	特殊事件监听
---客户端
TheWorld:PushEvent("screenflash", .5)												-- 屏幕闪光灯
inst:PushEvent("mouseover")															-- 鼠标聚焦时， 世界实体
self.hoverinst:PushEvent("mouseout")												-- 脱离聚焦时， 世界实体
--------------------
inst:RemoveEventCallback("death", OnDeath)
TheWorld:PushEvent("ms_sendlightningstrike", ConsoleWorldPosition())				-- 打个雷
inst:PushEvent("killed", { victim = self.inst })
TheWorld:ListenForEvent("ms_playerdespawn", OnPlayerDespawn)						-- 有玩家离开时触发
TheWorld:ListenForEvent("ms_playerdespawnanddelete", OnPlayerDespawnAndDelete)		-- 重生或者删除
inst:ListenForEvent("animover", inst.Remove)										-- 监听动画结束后
inst:ListenForEvent("animqueueover", inst.Remove)									-- 监听动画结束后 (所有队列播放完毕后)
inst:ListenForEvent("onremove", inst.Jomr)											-- 监听删除时
inst:ListenForEvent("onbuilt", onbuilt)												-- 监听在建造后触发
inst:ListenForEvent("clocktick", function(TheWorld)  end, TheWorld)					-- 监听时钟 （附加判定黑天白天）
inst:ListenForEvent("death", function()  end)										-- 监听死亡触发
inst:ListenForEvent("ms_becameghost", function()  end)								-- 监听玩家变成鬼时触发，  触发时，玩家已经添加了inst:HasTag("playerghost")标签
inst:ListenForEvent("ms_respawnedfromghost",function()  end)						-- 监听玩家复活时	触发时，玩家已经移除了inst:HasTag("playerghost")标签
inst:ListenForEvent("freeze", function()  end)										-- 监听冻结触发
inst:ListenForEvent("attacked", function()  end)									-- 监听被击触发
inst:StopWatchingWorldState("isday", OnIsDay)										-- 停止监听世界（天明）
inst:WatchWorldState("isday", ToggleUpdate)											-- 监听世界（天明）
inst:WatchWorldState("isnight", OnIsNight)											-- 监听世界（入夜）

inst:WatchWorldState("phase", update_phase)											-- 监听变天	update_phase(inst, phase) if phase == "day" then end  end
update_phase(inst, _G.TheWorld.state.phase)											-- "day", "dusk", "night"
				
inst:WatchWorldState("isfullmoon", OnToggleWere)									-- 监听世界（月圆）
inst:WatchWorldState("isautumn", OnAutumn)											-- 监听世界（入秋）
inst:WatchWorldState("israining", OnIsRaining)										-- 监听世界（下雨）
inst:ListenForEvent("killed", function() end)										-- 监听杀死目标 
TheWorld:PushEvent("ms_setclocksegs", {day=a,dusk=b,night=c})						-- 推动世界事件
inst:ListenForEvent("qm_xjjl", function(world, j) julifn(inst, j) end, TheWorld)	-- 监听世界时间
inst:ListenForEvent("unequip", {item=item, eslot=equipslot, slip=slip})				-- 监听脱下装备	已经脱下后触发
inst:ListenForEvent("equip", { item = item, eslot = eslot })						-- 监听穿戴装备	已经穿戴后触发
inst:ListenForEvent("ms_becameghost", function(inst, data)  end)					-- 监听玩家变成鬼时触发		{ corpse = true }
inst:ListenForEvent("killed", function(inst, data)  end)							-- 监听击杀目标			{ victim = self.inst }
inst:ListenForEvent("onhitother", function(inst, data)  end)						-- 监听击中目标			{ target = self.inst, damage = damage, damageresolved = damageresolved, stimuli = stimuli, weapon = weapon, redirected = damageredirecttarget }
inst:ListenForEvent("attacked", function(inst, data)  end)							-- 监听被击				{ attacker = attacker, damage = damage, damageresolved = damageresolved, weapon = weapon, stimuli = stimuli, redirected = damageredirecttarget, noimpactsound = self.noimpactsound }
self.onhitfn(self.inst, attacker, damage)											-- 击中回调
inst:ListenForEvent("onmissother", function(inst, data)  end)						-- 监听攻击Miss时触发	{ target = targ, weapon = weapon }
inst:ListenForEvent("oneat", function(inst, data)  end)								-- 监听吃下的食物		{ food = food, feeder = feeder }
inst:ListenForEvent("fishingcatch", function(inst, data)  end)						-- 监听钓上鱼来时		{ build = self.caughtfish.build }
																					   
inst:ListenForEvent("newstate", function(inst, data)  end)							-- 监听inst.sg:GoToState	时触发 【新的行为】

----------------------------->>>>>>>	状态逻辑 (世界 or 其他)
if TheWorld.state.iscaveday then			end										--是否为 洞穴白天
if TheWorld.state.iscavedusk then			end										--是否为 洞穴黄昏
if TheWorld.state.iscavenight then			end										--是否为 洞穴黑夜
if TheWorld.state.cavephase == "" then		end										--洞穴状态	白天"day"	黄昏"dusk"	 黑夜"night"
if TheWorld.state.phase == "" then			end										--地上状态	如果是洞穴会返回"night"
if TheWorld.state.isday then				end										--是否为白天	洞穴世界会返回false
if TheWorld.state.isdusk then				end										--是否为黄昏	洞穴世界会返回false
if TheWorld.state.isnight then				end										--是否为黑夜	洞穴世界会返回true
if TheWorld.state.moonphase == "" then		end										--月相	新月"new"	半月"half"
if TheWorld.state.season == "" then			end										--季节	春天"spring"	夏天"summer"	秋天"autumn"	冬天"winter"
----推送到下个季节		时辰不变
for i=1,TheWorld.state.remainingdaysinseason do
	TheWorld:PushEvent("ms_advanceseason")
end

TheWorld:PushEvent("ms_setseasonlength", {season="autumn", length=12})
TheWorld:PushEvent("ms_setseasonlength", {season="winter", length=10})
TheWorld:PushEvent("ms_setseasonlength", {season="spring", length=12})
TheWorld:PushEvent("ms_setseasonlength", {season="summer", length=10})
TheWorld:PushEvent("ms_nextphase")													--推送时间到下一个时钟阶段， 白天 傍晚 黑夜 (起点)

if TheWorld.state.isspring then		end												--是否为春天
if TheWorld.state.issummer then		end												--是否为夏天
if TheWorld.state.isautumn then		end												--是否为秋天
if TheWorld.state.iswinter then		end												--是否为冬天
if TheWorld.state.elapseddaysinseason > 5 then		end								--当前季节已经经过了多少天
if TheWorld.state.remainingdaysinseason > 5 then	end								--当前季节剩余天数
TheWorld.state.autumnlength															--秋天所分配的天数
TheWorld.state.winterlength															--冬天所分配的天数
TheWorld.state.springlength															--春天所分配的天数
TheWorld.state.summerlength															--夏天所分配的天数
TheWorld.state.temperature															--当前世界的温度
TheWorld.state.moisture																--当前世界的潮湿度
TheWorld.state.moistureceil															--当前世界的潮湿细胞[啥玩意?]
if TheWorld.state.israining then		end											--当前世界是否为雨天
if TheWorld.state.issnowing then		end											--当前世界是否为雪天
if TheWorld.state.issnowcovered then	end											--当前世界是否已经被大雪覆盖
if TheWorld.state.isfullmoon then		end											--是否为满月
TheWorld:PushEvent("moonphasechanged2", { moonphase = "new", waxing = true})
--改变月相

TheWorld.state.time																	--时钟经过的时间 (百分比)
TheWorld.state.cycles																--世界经过了多少天   世界天数,  显示天数为 +1

----------------------------->>>>>>>	Mod部分常用API函数
AddStategraphPostInit("wilson", function(sg)										--玩家.sg
	sg.actionhandlers[ACTIONS.CASTAOE] = function(inst, action) return "idle" end
	sg.events["locomote"] = EventHandler("locomote", function(inst, data) end)
	sg.events["attacked"] = function(inst, data) end
	sg.states["death"].onenter = function(inst) end
	sg.states["death"].onexit = function(inst) end
	sg.states["death"].events["animover"] = function(inst) end
	sg.states["death"].ontimeout = function(inst) end
	sg.states["death"].timeline[1] = function(inst) end
	sg.states["death"].onupdate = function(inst) end
end)

AddStategraphPostInit("wilson", function(sg)
	sg.states["death"].onexit = nil
end)

local SGTagsToEntTags =
{
    ["attack"] = true,
    ["autopredict"] = true,
    ["busy"] = true,
    ["dirt"] = true,
    ["doing"] = true,
    ["fishing"] = true,
    ["flight"] = true,
    ["giving"] = true,
    ["hiding"] = true,
    ["idle"] = true,
    ["invisible"] = true,
    ["lure"] = true,
    ["moving"] = true,
    ["nibble"] = true,
    ["noattack"] = true,
    ["nopredict"] = true,
    ["pausepredict"] = true,								--暂停预测
    ["sleeping"] = true,
    ["working"] = true,
    ["jumping"] = true,
}

{ "busy", "doing", "nomorph", "nopredict", "nointerrupt", "canrotate" }			--inst.sg:RemoveStateTag("busy")

AddPlayerPostInit(function(inst) 							end)				--所有玩家
AddPrefabPostInitAny(function(inst)							end)				--所有预设物
AddPrefabPostInit("world",function(inst)					end)				--指定预设物
AddComponentPostInit("health", function(self)				end)				--组件模块
AddClassPostConstruct("widgets/controls", function(self)	end)				--类
AddLevelPreInit("SURVIVAL_TOGETHER",function(level)								--指定修改世界预设值
	if type(level) == "table" then
	end
end)

AddLevelPreInitAny(function(level)											--修改任意模式世界预设值
end)

AddRoomPreInit("Clearing", function(room)
	if type(room) == "table" then
		room.colour={r=0,g=0,b=0,a=.0001}									--
		room.value = 1														--生成的瓷砖类型， 1为海域	GROUND.IMPASSABLE
		room.type = NODE_TYPE.Blank											--有效区域为空白		NODE_TYPE.Room == 洞穴分叉路
		room.internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid		--为内部结构			可nil	有此项的一般都是海域节点
		room.tags = {}														--task任务集
		room.required_prefabs = {"sacred_chest"}							--需求的预设物		required_prefabs = nil
		room.contents =  {													--contents = {}
			countprefabs = {
					spawnpoint_multiplayer = 1,								--所需要的预设物数量		countprefabs = nil	也可能指定生成数量
				},
			countstaticlayouts = {
				["RabbitTown"]=1,											--附加的静态布局数量		countstaticlayouts = nil	Room型 也可能是 布局型
			},
			distributepercent = 1,											--节点内生成物质的间隔， 越小间隔越大
			distributeprefabs= {
				cavelight = 0.05,
			},
			prefabdata = {													--对生成的物质重定向		prefabdata = nil
				spiderden = function()
					if math.random() < 0.2 then
						return { growable={stage=2}}
					else
						return { growable={stage=1}}
					end
				end,
			},
		}
	end
end)

--------------------------------------人物Mod相关参数
STRINGS.CHARACTER_TITLES.qm_xxxx = "标题"
STRINGS.CHARACTER_NAMES.qm_xxxx = "人物名"
STRINGS.CHARACTER_DESCRIPTIONS.qm_xxxx = "描述"
STRINGS.CHARACTER_QUOTES.qm_xxxx = "引文"

STRINGS.NAMES.QM_XXXX = "人物名"											--人物在游戏里的预设名

STRINGS.NAMES[string.upper("qm_item00")] = "物品名"
STRINGS.RECIPE_DESC[string.upper("qm_item00")] = "物品在制作时的描述~"

STRINGS.CHARACTERS.QM_XXXX = require("speech_wilson")						--人物对话信息文件，自定义修改
AddMinimapAtlas("images/map_icons/qm_xxxx.xml")								--增加小地图图标		64*64
AddModCharacter("qm_xxxx", "FEMALE")										--增加人物到mod人物列表的里面 性别为女性（MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）

inst.soundsname = "willow"	-- 人物音效

Asset( "IMAGE", "images/selectscreen_portraits/change.tex" ),				--单机选人界面
Asset( "ATLAS", "images/selectscreen_portraits/change.xml" ),
Asset( "IMAGE", "bigportraits/change.tex" ),								--人物大图（方形的那个）
Asset( "ATLAS", "bigportraits/change.xml" ),
Asset( "IMAGE", "images/map_icons/change.tex" ),							--小地图
Asset( "ATLAS", "images/map_icons/change.xml" ),
Asset( "IMAGE", "images/avatars/avatar_change.tex" ),						--tab键人物列表显示的头像
Asset( "ATLAS", "images/avatars/avatar_change.xml" ),
Asset( "IMAGE", "images/avatars/avatar_ghost_change.tex" ),					--tab键人物列表显示的头像（死亡）
Asset( "ATLAS", "images/avatars/avatar_ghost_change.xml" ),
Asset( "IMAGE", "images/avatars/self_inspect_change.tex" ),					--人物检查按钮的图片
Asset( "ATLAS", "images/avatars/self_inspect_change.xml" ),
Asset( "IMAGE", "bigportraits/change_none.tex" ),							--人物大图（椭圆的那个）
Asset( "ATLAS", "bigportraits/change_none.xml" ),
--------------行为逻辑API
--------------------------------------建立组件，行为， 监听 一体化API
----------客户端部分只需要AddAction("TILL", STRINGS.ACTIONS.TILL or "锄地", function(act) end)
AddAction("TILL", STRINGS.ACTIONS.TILL or "锄地", function(act)
	if act.pos ~= nil and act.invobject ~= nil and act.invobject.components.tiller then
		act.invobject.components.tiller:DoTill(act.pos, act.doer)
		return true
	end
end)
ACTIONS.TILL.distance = 1
ACTIONS.TILL.rmb = true
ACTIONS.TILL.instant = false
ACTIONS.TILL.priority = 10
--------------------------会检测服务端是否有该组件名
SCENE = --args: inst, doer, actions, right					--场景		(inst:指针指向实体, doer:行为人实体, right:左键行为)
USEITEM = --args: inst, doer, target, actions, right		--使用项目	(inst:指针手持实体, target:指针指向实体)
POINT = --args: inst, doer, pos, actions, right				--地面		(inst:指针手持实体(种植型), pos:指针坐标)
EQUIPPED = --args: inst, doer, target, actions, right		--装备
INVENTORY = --args: inst, doer, actions, right				--库存		(inst:指针指向实体)
ISVALID = --args: inst, action, right						--是有效的

AddComponentAction("POINT", "tiller", function (inst, doer, pos, actions, right)
	if right and pos and #TheSim:FindEntities(pos.x, 0, pos.z, 1, { "dirtpile" }) <= 0 then
		table.insert(actions, ACTIONS.TILL)
	end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.TILL, "till_start"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.TILL, "till_start"))

--------------------------------------------------------怪物AI
require "behaviours/chaseandattack"
require "behaviours/leash"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/runaway"

local QM_AI_1 = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function QM_AI_1:OnStart()
    local root =
        PriorityNode(
        {
			--恐慌逃跑
			WhileNode(function() return self.inst.components.combat:GetCooldown() > 0 end, "PanicHaunted", Panic(self.inst)),
		
			--盾牌(实体，承受多少伤害200，防御持续时间5秒，避免射弹攻击true，害怕时true)
			UseShield(self.inst, DAMAGE_UNTIL_SHIELD, SHIELD_TIME, AVOID_PROJECTILE_ATTACKS, HIDE_WHEN_SCARED),
			--循环判定执行
			WhileNode(function()
					return self.inst.components.combat.target ~= nil
						and (self.inst.sg:HasStateTag("running") or
							not self.inst.components.combat.target:IsNear(self.inst, 6))
				end,
				"RamAttack", ChaseAndRam(self.inst, MAX_CHASE_TIME, CHASE_GIVEUP_DIST, MAX_CHARGE_DIST)),
			--逃离(实体,标签 or {fn,tags={},notags={},oneoftags={}}, 判定距离,逃离最大距离,fn(mubiao))
			RunAway(self.inst, "player", MIN_RUNAWAY, MAX_RUNAWAY),
			
			--进攻(实体，最大追逐时间，放弃距离[^2]，最大攻击次数【峰值后会被设置为nil目标】，fn(self.inst)【目标为nil时重新搜索目标】，false or true)
			ChaseAndAttack(self.inst,5,10),
			
			--返回记录点(实体，记录点，最大脱离距离【自动^2】，返回带指定范围内【^2】，true or false【跑步，走步】)
			Leash(self.inst, HomePoint, 20, 10),
		
			--漫步(实体，获取坐标[三维向量]，最大距离，{minwalktime=最小随机时间,randwalktime=随机行走时间,minwaittime=最小等待时间,randwaittime=等待时间, fn=Get方向,fn=Set方向})
			Wander(self.inst, GetNoLeaderHomePos, 20,{
				minwalktime = .5,
				randwalktime = 2,
				minwaittime = 5,
				randwaittime = 10,
    		}),
			--做执行
			ActionNode(function() self.inst.components.combat:SetAttackPeriod(TUNING.ANTLION_MAX_ATTACK_PERIOD) end),
			
			--判定执行
			IfNode(
				function()
					return not self.inst.sg:HasStateTag("busy")
						and FindLeader(self) == nil
				end,
				"No Leader",
				ActionNode(function() self.inst.sg:GoToState("deactivate") end)),
			
			--做行为
			DoAction(self.inst, function() return BaseDestroy(self.inst) end, "DestroyBase", true),
			
			--追随主人(本体，fn获取追随的目标，与追随者的最小间距，脱离最大范围后返回与追随者的距离， 最大范围)
			Follow(self.inst, function() return self.inst.components.follower.leader end, 2, 5, 9),
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
			
        }, .25)
    self.bt = BT(self.inst, root)
end

local function HomePoint(inst)
	return inst.components.knownlocations and inst.components.knownlocations:GetLocation("qm_yuandian")
end

function QM_AI_1:OnInitializationComplete()							--AI初始化时调用
	if self.inst.components.knownlocations == nil then
		self.inst:AddComponent("knownlocations")
	end
	if not self.inst.components.knownlocations:GetLocation("qm_yuandian") then
		self.inst.components.knownlocations:RememberLocation("qm_yuandian", self.inst:GetPosition())
	end
end

return QM_AI_1








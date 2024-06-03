>  lua通用随笔
## lua
```lua
--60,80,0 金黄  0,0,255 蓝紫黑（好看） 45,0,95 小粉 0,1,0 绿 200,100,0 淡黄 0,88,255 青绿(比绿的好看)
--80,0,0  淡红
Vector3(x,y,z)
string.rep('★',inst.lddj) --复制文本
math.floor(12.5)--拿到向下取整
math.ceil(11.5)--拿到向上取整
string.format("%.2f", x) --保留俩位小数
math.random()--不填min max 则随机0-1
table.insert(PrefabFiles, "pinkstaff") --插入到表PrefabFiles
math.atan2()--返回点(x,y)和原点(0,0)之间直线的倾斜角的反正切值，返回值的单位是弧度。
string.gmatch(message, "%S+") --匹配字符串  https://blog.csdn.net/suifcd/article/details/78928559
tonumber("123") --转化为数字  注意写 _G  饥荒函数里有这玩意
tostring() --转化为字符串
string.sub(message,1,4)--截取1-4字符串（中文是多个字符）
-- %.1f 保留一位小数
string.format("字符串：%s\n整数：%d\n小数：%f\n十六进制数：%X","qweqwe",1,0.13,348)--第一个参数为字符串格式，后面的参数可以任意多个，用于填充第一个参数中的格式控制符，最后返回完整的格式化后的字符串。 （字符串较长或者有特殊的格式转换操作） https://blog.csdn.net/anita9999/article/details/82346552
shallowcpopy--浅拷贝
GLOBAL.deepcopy(table) --深度复制一份表   不想改变原表又想改变数据的情况
_G.rawget() --忽略元表的__index作用
string.upper("变量名") -- 小写字母变成大写
table.insert(Table,tb) --把tb插入大的Table
math.sqrt(16) --求更号 这里得的4
XX:utf8len() XX:len() --获取字符串的长度  utf8中文算一位  len的算三位
for k,_ in pairs(data) do
--获取表data里面的所有可用参数
	print("____________________________")
	print(k)
	next(data,k) -- 循环的时候可以通过next获取下一个循环的数 作用： 判定键值是否是最后一个 做一些额外处理
end)
--只有在 StartThread 里面才能使用 sleep 执行  用 sleep 协程可以间隔一点点 也就是不一口气执行完 ------用循环任务也能写 但这种有随机间隔不好写
reader:StartThread(function()
	for k = 1, num do
		local pos = birdspawner:GetSpawnPoint(pt)
		if pos ~= nil then
			local bird = birdspawner:SpawnBird(pos, true)
			if bird ~= nil then
			   bird:AddTag("magicalbird")
			end
		end
		Sleep(math.random(.2, .25))
	end
 end)
```
## 长度
```lua
-- net_bool                1-bit boolean
-- net_tinybyte            3-bit unsigned integer   [0..7]
-- net_smallbyte           6-bit unsigned integer   [0..63]
-- net_byte                8-bit unsigned integer   [0..255]
-- net_shortint            16-bit signed integer    [-32767..32767]
-- net_ushortint           16-bit unsigned integer  [0..65535]
-- net_int                 32-bit signed integer    [-2147483647..2147483647]
-- net_uint                32-bit unsigned integer  [0..4294967295]
-- net_float               32-bit float
-- net_hash                32-bit hash of the string assigned
-- net_string              variable length string
-- net_entity              entity instance
-- net_bytearray           array of 8-bit unsigned integers (max size = 31)
-- net_smallbytearray      array of 6-bit unsigned integers (max size = 31)
```

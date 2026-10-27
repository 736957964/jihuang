
--热更新
--仅开发环境下使用
--do return end

local prefabs = {
	 ['yama_soulfire_purple'] = 'yama_soulfire_purple',
}

local classes = {
	[''] = true,
}

local old_spawn = GLOBAL.SpawnPrefab
function GLOBAL.SpawnPrefab(prefab, ...)
	if prefabs[prefab] then
		LoadPrefabFile('prefabs/'..prefabs[prefab])
	end
	return old_spawn(prefab, ...)
end

local old_require = GLOBAL.require
function GLOBAL.require(path)
	if classes[path] then
		package.loaded[path] = nil
	end
	return old_require(path)
end
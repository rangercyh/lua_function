--[[
这里是一些lua实现面向对象技术的相关方法
]]

--复制一个table
--org为源table，des为复制出来的新table
function gf_CopyTable(tbOrg)
    local tbSaveExitTable = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif tbSaveExitTable[object] then	--检查是否有循环嵌套的table
            return tbSaveExitTable[object]
        end
        local tbNewTable = {}
        tbSaveExitTable[object] = tbNewTable
        for index, value in pairs(object) do
            tbNewTable[_copy(index)] = _copy(value)	--要考虑用table作索引的情况
        end
        return setmetatable(tbNewTable, getmetatable(object))
    end
    return _copy(tbOrg)
end

--继承
--参数tbInitInfo是为了对基类的成员进行初始化或为派生类中增加新成员
function gf_Inherit(base, tbInitInfo)
	local derive = {}
	local metatable = {}
	metatable.__index = base
	setmetatable(derive, metatable)
	for i, v in pairs(base) do
		if type(v) == "table" then
			derive[i] = gf_CopyTable(v)
		end
	end
	if tbInitInfo then	--如果要改变基类的成员或增加新的成员
		for i, v in pairs(tbInitInfo) do
			derive[i] = v
		end
	end
	return derive
end

--获得某个脚本的内容，以table的方式封装返回
function gf_GetScriptTable(szPath)
	local szEvn = GetScriptEnv(szPath)
	local tbScript = _G[szEvn]
	return tbScript
end

--获得某个脚本的某个变量的值
function gf_GetScriptValue(szPath,szValueName)
	local tbScript = gf_GetScriptTable(szPath)
	if tbScript then
		return tbScript[szValueName]
	else
		return nil
	end
end
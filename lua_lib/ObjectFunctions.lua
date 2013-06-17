--[[
������һЩluaʵ���������������ط���
]]

--����һ��table
--orgΪԴtable��desΪ���Ƴ�������table
function gf_CopyTable(tbOrg)
    local tbSaveExitTable = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif tbSaveExitTable[object] then	--����Ƿ���ѭ��Ƕ�׵�table
            return tbSaveExitTable[object]
        end
        local tbNewTable = {}
        tbSaveExitTable[object] = tbNewTable
        for index, value in pairs(object) do
            tbNewTable[_copy(index)] = _copy(value)	--Ҫ������table�����������
        end
        return setmetatable(tbNewTable, getmetatable(object))
    end
    return _copy(tbOrg)
end

--�̳�
--����tbInitInfo��Ϊ�˶Ի���ĳ�Ա���г�ʼ����Ϊ�������������³�Ա
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
	if tbInitInfo then	--���Ҫ�ı����ĳ�Ա�������µĳ�Ա
		for i, v in pairs(tbInitInfo) do
			derive[i] = v
		end
	end
	return derive
end

--���ĳ���ű������ݣ���table�ķ�ʽ��װ����
function gf_GetScriptTable(szPath)
	local szEvn = GetScriptEnv(szPath)
	local tbScript = _G[szEvn]
	return tbScript
end

--���ĳ���ű���ĳ��������ֵ
function gf_GetScriptValue(szPath,szValueName)
	local tbScript = gf_GetScriptTable(szPath)
	if tbScript then
		return tbScript[szValueName]
	else
		return nil
	end
end
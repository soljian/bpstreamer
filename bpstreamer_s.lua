--[[
This script is a modification of the soundstreamer package, inspired by the Galax's lightstreamer : 
https://github.com/BlueMountainsIO/OnsetLuaScripts/tree/master/soundstreamer
Modified By Soljian
]]--

local StreamedBps = {}

local function OnPackageStart()
    math.randomseed(os.time())
end
AddEvent("OnPackageStart", OnPackageStart)

local function OnPackageStop()
    for k, v in pairs(StreamedBps) do
        DestroyObject(k)        
    end
    StreamedBps = nil
end
AddEvent("OnPackageStop", OnPackageStop)

local function CreateBp(bpPath, x, y, z, rx, ry, rz)
    if not bpPath or bpPath == "" then
        print('× The bpPath parameter should not be null and should reference the path of your blueprint')
        return false
    end

    local bpObject = CreateObject(1, x, y, z, rx or 0, ry or 0, rz or 0)
    if not bpObject then
        print('× Can\'t create the bpObject. Please check location parameters.')
        return false
    end

    local _bpStream = {
        bpPath = bpPath
    }

    SetObjectPropertyValue(bpObject, "_bpStream", _bpStream, true)
    
    StreamedBps[bpObject] = _bpStream
    
    return bpObject
end
AddFunctionExport("CreateBp", CreateBp)

local function DestroyBp(bpObject)
    if not bpObject then
        print('× Please add the bpObject parameter to destroy it')
        return false
    end
    if not StreamedBps[bpObject] then
        print('× This bpObject doesn\'t exist')
        return false
    end
    StreamedBps[bpObject] = nil
    return DestroyObject(bpObject)
end
AddFunctionExport("DestroyBp", DestroyBp)

local function IsValidBp(bpObject)
    return StreamedBps[bpObject] ~= nil
end
AddFunctionExport("IsValidBp", IsValidBp)
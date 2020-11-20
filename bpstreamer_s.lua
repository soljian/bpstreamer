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
        bpPath = bpPath,
        isAttached = false
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

local function SetBpAttached(bpObject, attachType, attachId, x, y, z, rx, ry, rz, socketName)
    if not bpObject then
        print('× Please add the bpObject parameter to attach it')
        return false
    end

    if not StreamedBps[bpObject] then
        print('× This bpObject doesn\'t exist')
        return false
    end

    if not SetObjectAttached(bpObject, attachType, attachId, x or 0.0, y or 0.0, z or 0.0, rx or 0.0, ry or 0.0, rz or 0.0, socketName or "") then        
        print('× Can\'t attach this Bp')
        return false
    end
    
    StreamedBps[bpObject].isAttached = true
    StreamedBps[bpObject].attachType = attachType
    StreamedBps[bpObject].attachId = attachId
    SetObjectPropertyValue(bpObject, "_bpStream", StreamedBps[bpObject], true)

    return true
end
AddFunctionExport("SetBpAttached", SetBpAttached)

local function GetAttachedBps(attachType, attachId)
    if not attachType or not attachId then
        print('× Please specify attachType and attachId')
        return false
    end

    local bps = {}

    for k, v in pairs(StreamedBps) do
        if v.isAttached then
            if v.attachType == attachType and v.attachId == attachId then
                table.insert(bps, k)
            end
        end
    end

    return bps
end
AddFunctionExport("GetAttachedBps", GetAttachedBps)

local function SetBpDetached(bpObject)
    if not bpObject then
        print('× Please specify bpObject')
        return false
    end

    if not StreamedBps[bpObject] then
        print('× This bpObject doesn\'t exist')
        return false
    end

    if not StreamedBps[bpObject].isAttached then
        print('× This bpObject is not attached')
        return false
    end

    SetObjectDetached(bpObject)
    StreamedBps[bpObject].isAttached = false
    StreamedBps[bpObject].attachType = nil
    StreamedBps[bpObject].attachId = nil
    SetObjectPropertyValue(bpObject, "_bpStream", StreamedBps[bpObject], true)
    return true
end
AddFunctionExport("SetBpDetached", SetBpDetached)

local function IsBpAttached(bpObject)
    if not bpObject then
        print('× Please specify bpObject')
        return false
    end

    if not StreamedBps[bpObject] then
        print('× This bpObject doesn\'t exist')
        return false
    end

    return StreamedBps[bpObject].isAttached or false
end
AddFunctionExport("IsBpAttached", IsBpAttached)

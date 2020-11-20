--[[
This script is a modification of the soundstreamer package, inspired by the Galax's lightstreamer : 
https://github.com/BlueMountainsIO/OnsetLuaScripts/tree/master/soundstreamer
Modified By Soljian
]]--

-- Expose attach types like on the server.
if ATTACH_NONE == nil then
	ATTACH_NONE = 0
end
if ATTACH_PLAYER == nil then
	ATTACH_PLAYER = 1
end
if ATTACH_VEHICLE == nil then
	ATTACH_VEHICLE = 2
end
if ATTACH_OBJECT == nil then
	ATTACH_OBJECT = 3
end
if ATTACH_NPC == nil then
	ATTACH_NPC = 4
end

local StreamedBps = {}

local function OnPackageStop()
    StreamedBps = nil
end
AddEvent("OnPackageStop", OnPackageStop)

local function OnObjectStreamIn(object)
    if StreamedBps[object] ~= nil then
		print("× [BPSTREAMER] OnObjectStreamIn("..object..") called where we already have one")
		return
    end
    
    local _bpStream = GetObjectPropertyValue(object, "_bpStream")
    
    if _bpStream then
        StreamedBps[object] = _bpStream

        local objectActor = GetObjectActor(object)
        
        -- Make the object hidden for players
		objectActor:SetActorScale3D(FVector(0.0, 0.0, 0.0))
        GetObjectStaticMeshComponent(object):SetHiddenInGame(true)
        
        -- Disable the object's collisions
        objectActor:SetActorEnableCollision(false)

        -- Create the bp
        local x, y, z = GetObjectLocation(object)
        local rx, ry, rz = GetObjectRotation(object)        
        StreamedBps[object].bp = GetWorld():SpawnActor(UClass.LoadFromAsset(StreamedBps[object].bpPath), FVector(x, y, z), FRotator(rx, ry, rz))
        StreamedBps[object].bp:SetActorEnableCollision(false)
        
        -- Fail checks
        if not StreamedBps[object].bp then
            if IsGameDevMode() then
                local error = "× [BPSTREAMER] An error occured while creating the bp"
                AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..error..'</>')
                print(error)
            end
            StreamedBps[object] = nil
            return
        end

        if IsGameDevMode() then
			AddPlayerChat("[BPSTREAMER] STREAMIN: Server Bp for Object "..object)
		end
    end
end
AddEvent("OnObjectStreamIn", OnObjectStreamIn)

local function OnObjectStreamOut(object)
    if StreamedBps[object] then
        StreamedBps[object].bp:Destroy()

        if IsGameDevMode() then
			AddPlayerChat("[BPSTREAMER] STREAMOUT: Server Bp "..object)
        end
        
        StreamedBps[object] = nil
    end
end
AddEvent("OnObjectStreamOut", OnObjectStreamOut)

local function OnObjectNetworkUpdatePropertyValue(object, PropertyName, PropertyValue)
    if PropertyName == "_bpStream" and StreamedBps[object] then
        Delay(100, function()
            local tempBp = StreamedBps[object].bp
            StreamedBps[object] = GetObjectPropertyValue(object, "_bpStream")
            StreamedBps[object].bp = tempBp
        end)
	end
end
AddEvent("OnObjectNetworkUpdatePropertyValue", OnObjectNetworkUpdatePropertyValue)

local function OnGameTick()
    for k, v in pairs(StreamedBps) do
        if v.isAttached then            
            local x, y, z = GetObjectLocation(k)
            local rx, ry, rz = GetObjectRotation(k)
			v.bp:SetActorLocation(FVector(x, y, z))
			v.bp:SetActorRotation(FRotator(rx or 0.0, ry or 0.0, rz or 0.0))
		end
	end
end
AddEvent("OnGameTick", OnGameTick)
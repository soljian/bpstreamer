--[[
This script is a modification of the soundstreamer package, inspired by the Galax's lightstreamer : 
https://github.com/BlueMountainsIO/OnsetLuaScripts/tree/master/soundstreamer
Modified By Soljian
]]--

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
		objectActor:SetActorScale3D(FVector(0.01, 0.01, 0.01))
        GetObjectStaticMeshComponent(object):SetHiddenInGame(true)
        
        -- Disable the object's collisions
        objectActor:SetActorEnableCollision(false)

        -- Create the bp
        local x, y, z = GetObjectLocation(object)
        local rx, ry, rz = GetObjectRotation(object)        
        StreamedBps[object].bp = GetWorld():SpawnActor(UClass.LoadFromAsset(StreamedBps[object].bpPath), FVector(x, y, z), FRotator(rx, ry, rz))
        
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
        print('BP', StreamedBps[object].bp)
        StreamedBps[object].bp:Destroy()

        if IsGameDevMode() then
			AddPlayerChat("[BPSTREAMER] STREAMOUT: Server Bp "..object)
        end
        
        StreamedBps[object] = nil
    end
end
AddEvent("OnObjectStreamOut", OnObjectStreamOut)

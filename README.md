# Blueprint Streamer

Serverside streamed blueprints.

[![Image from Gyazo](https://i.gyazo.com/220b7f6411c326cc2dfee0128fca2433.jpg)](https://gyazo.com/220b7f6411c326cc2dfee0128fca2433)

This package allow developers to sync for everyone that is in range of streaming the spawn of a Blueprint made in Unreal Engine. The script use a object created on server and some ObjectProperties to carry datas.

The blueprint can be attached to players, vehicles, objects, npcs (optionnal).

A car on fire 
[![Image from Gyazo](https://i.gyazo.com/ad1bbd4abdcf4e90d5766bdfe05cb70b.gif)](https://gyazo.com/ad1bbd4abdcf4e90d5766bdfe05cb70b)

Kindof Ghost Rider
[![Image from Gyazo](https://i.gyazo.com/0dd5d225a328fff1417152c7b9030a0b.gif)](https://gyazo.com/0dd5d225a328fff1417152c7b9030a0b)

The BP used in those examples was made from [M5 VFX Vol2](https://www.unrealengine.com/marketplace/en-US/product/m5-vfx-vol2-fire-and-flames).

# Usages

Be carefull to import the bpstreamer package in your server script like :

`local bps = ImportPackage("bpstreamer")` 

## Basic examples

To spawn a fire blueprint that will be placed on the player position :

```
local bp = "/effect_fire_01/effect_fire_01"
local x, y, z = GetPlayerLocation(player)
bps.CreateBp(bp, x, y, z)
```

To spawn a fire blueprint that will be attached to a car (see previous gifs) :

```
local bp = "/effect_fire_01/effect_fire_01"
local playerVeh = GetPlayerVehicle(player)
local x, y, z = GetPlayerLocation(player)
local obj = bps.CreateBp(bp, x, y, z)
bps.SetBpAttached(obj, ATTACH_VEHICLE, playerVeh)
```

## Functions availables

### CreateBp

Use `CreateBp(bpPath, x, y, z, rx, ry, rz)` to spawn your blueprint. The BP path should your asset's path from your pak (be carefull to mount it first !)

x, y and z parameters are mandatory

rx, ry and rz are optionnals. They relate to the rotation of the blueprint.

Return the object id

### DestroyBp

Use `DestroyBp(bpObject)` to destroy the object that is streaming your blueprint and the blueprint itself.

bpObject is mandatory and relate to the object created by the `CreateBp` function.

Return true or false

### IsValidBp

Use `IsValidBp(bpObject)` to check if your bpObject exist.

bpObject is mandatory and relate to the object created by the `CreateBp` function.

Return true or false

### SetBpAttached

Use `SetBpAttached(bpObject, attachType, attachId, x, y, z, rx, ry, rz, socketName)` to attach a bpObject to something. The blueprint's location and rotation will be updated `OnGameTick`.

bpObject, attachType, attachId are mandatory. Refer to [the attach types list](https://dev.playonset.com/wiki/AttachType).

x, y, z, rx, ry, rz are mandatory and relate to relative location and rotation for the blueprint.

socketName is mandatory and relate to the `bone` to attach the object. Refer to [the list of socket bones](https://dev.playonset.com/wiki/PlayerBones).

Return true or false

### GetAttachedBps

Use `GetAttachedBps(attachType, attachId)` to get the list of objects that are attached to the thing you sent in parameters.

attachType, attachId are mandatory. Refer to [the attach types list](https://dev.playonset.com/wiki/AttachType) for the attachType parameter. 

Return object's table

### SetBpDetached

Use `SetBpDetached(bpObject)` to detach your object and blueprint from what it's attached to.

bpObject is mandatory and relate to the object created by the `CreateBp` function.

Return true or false

### IsBpAttached

Use `IsBpAttached(bpObject)` to know if your object is attached to something.

Return true or false

## Some more infos

The collisions of attached objects and blueprints will be disabled to avoid glitch and stuff. It will be updated later.

If your blueprint is spawning another blueprint or this kind of stuff, be carefull to destroy it yourself with `ProcessEvent` and functions you've made in it. The destroying via this script will only destroy the thing you spawned and none of its childrens.

I'm open to suggestions ;)


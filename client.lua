--------- ATTACH Ehh -------------
local QBCore = exports['qb-core']:GetCoreObject()

local attachedCarModel = "npolvette"

-- Variable to keep track of the attached car
local attachedCar = nil

-- Attach the car to the helicopter
function attachCarToHelicopter(playerPed, helicopter)
    -- Check if a car is already attached and still exists
    if attachedCar ~= nil and DoesEntityExist(attachedCar) then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "A car is already attached!"}
        })
        return
    end

    local heliCoords = GetEntityCoords(helicopter)
    local heliForwardVector = GetEntityForwardVector(helicopter)
    local carSpawnCoords = heliCoords + heliForwardVector * 5.0 -- Adjust the distance between helicopter and car

    -- Spawn the car model at the specified coordinates
    attachedCar = CreateVehicle(GetHashKey(attachedCarModel), carSpawnCoords.x, carSpawnCoords.y, carSpawnCoords.z, GetEntityHeading(helicopter), true, false)

    if DoesEntityExist(attachedCar) then
        -- Attach the car to the helicopter
        AttachEntityToEntity(attachedCar, helicopter, GetEntityBoneIndexByName(helicopter, "chassis"), 0.0, 0.0, -1.8, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Car attached to helicopter!"}
        })
    end
end


RegisterCommand("detachcar", function(source, args)
    if DoesEntityExist(attachedCar) then
        DetachEntity(attachedCar, true, true)
        attachedCar = nil
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Car detached from helicopter!"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "No car is attached to the helicopter!"}
        })
    end
end)



-- Attach the nearest car to the helicopter
function attachNearestCarToHelicopter(playerPed, helicopter)
    -- Check if a car is already attached and still exists
    if attachedCar ~= nil and DoesEntityExist(attachedCar) then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "A car is already attached!"}
        })
        return
    end

    local playerCoords = GetEntityCoords(playerPed)
    local closestVehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, 0, 127)

    
    if DoesEntityExist(closestVehicle) then
        -- Attach the car to the helicopter
        AttachEntityToEntity(closestVehicle, helicopter, GetEntityBoneIndexByName(helicopter, "chassis"), 0.0, 0.0, -1.8, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        attachedCar = closestVehicle
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Car attached to helicopter!"}
        })
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "No nearby cars found!"}
        })
    end
end

-- Command to attach the nearest car to the helicopter
RegisterCommand("attachncar", function(source, args)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    -- Check if the player is in a helicopter
    if IsVehicleModel(vehicle, GetHashKey("polmav")) then -- Change the vehicle model to the helicopter model you want to use
        attachNearestCarToHelicopter(playerPed, vehicle)
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "You must be in a helicopter to use this command!"}
        })
    end
end)

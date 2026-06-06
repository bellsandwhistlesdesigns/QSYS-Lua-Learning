-- ==========================================
-- AV Control Framework Demo (Next Upgrade)
-- Author: Douglas Moth
-- ==========================================

local room = {
    name = "Hybrid AV Conference Room",

    state = {
        volume = 65,
        micMuted = true,
        screenDown = true,
        projectorOn = true,
        frontDisplayOn = true,
        cameraOn = true,
        doorOpen = true,
        lightsOn = true,
        occupancy = 12
    }
}

-- ==========================================
-- LOGGING

local function Log(msg)
    print(string.format("%s | %s", room.name, msg))
end

-- ==========================================
-- DEVICE LAYER (single interface per device)

local Device = {}

function Device.Set(key, value, label)
    room.state[key] = value
    Log(label .. ": " .. tostring(value))
end

function Device.Toggle(key, label)
    local newValue = not room.state[key]
    room.state[key] = newValue
    Log(label .. ": " .. tostring(newValue))
end

-- ==========================================
-- DEVICE ACTIONS (clean + reusable per room)

local Devices = {}

-- Volume
function Devices.VolumeUp()
    if room.state.volume < 100 then
        room.state.volume = room.state.volume + 5
    end
    Log("Volume: " .. room.state.volume)
end

function Devices.VolumeDown()
    if room.state.volume > 0 then
        room.state.volume = room.state.volume - 5
    end
    Log("Volume: " .. room.state.volume)
end

-- Mic
function Devices.ToggleMic()
    Device.Toggle("micMuted", "Mic Muted")
end

-- Projector
function Devices.ToggleProjector()
    Device.Toggle("projectorOn", "Projector Power")
end

-- Screen
function Devices.ToggleScreen()
    Device.Toggle("screenDown", "Screen State")
end

-- Display
function Devices.ToggleDisplay()
    Device.Toggle("frontDisplayOn", "Front Display")
end

-- Camera
function Devices.ToggleCamera()
    Device.Toggle("cameraOn", "Camera")
end

-- Door
function Devices.ToggleDoor()
    Device.Toggle("doorOpen", "Door")
end

-- Lights
function Devices.ToggleLights()
    Device.Toggle("lightsOn", "Lights")
end

-- ==========================================
-- EVENT ROUTER 

local EventBus = {}

function EventBus.Trigger(eventName)
    Log("EVENT: " .. eventName)

    local handler = EventBus[eventName]
    if handler then
        handler()
    else
        Log("No handler for event: " .. eventName)
    end
end

-- ==========================================
-- EVENT MAPPINGS (buttons & actions)

EventBus["VolumeUpPressed"] = Devices.VolumeUp
EventBus["VolumeDownPressed"] = Devices.VolumeDown
EventBus["MicButtonPressed"] = Devices.ToggleMic
EventBus["ProjectorButtonPressed"] = Devices.ToggleProjector
EventBus["ScreenButtonPressed"] = Devices.ToggleScreen
EventBus["DisplayButtonPressed"] = Devices.ToggleDisplay
EventBus["CameraButtonPressed"] = Devices.ToggleCamera
EventBus["DoorButtonPressed"] = Devices.ToggleDoor
EventBus["LightsButtonPressed"] = Devices.ToggleLights

-- ==========================================
-- SCENES (DECLARATIVE)

local Scenes = {

    Presentation = function()
        Log("SCENE: Presentation Mode")

        Device.Set("projectorOn", true, "Projector")
        Device.Set("screenDown", true, "Screen Down")
        Device.Set("frontDisplayOn", true, "Front Display")
        Device.Set("cameraOn", false, "Camera")
        Device.Set("lightsOn", false, "Lights")
        Device.Set("doorOpen", true, "Door")
    end,

    VideoConference = function()
        Log("SCENE: Video Conference Mode")

        Device.Set("frontDisplayOn", true, "Front Display")
        Device.Set("cameraOn", true, "Camera")
        Device.Set("screenDown", false, "Screen Up")
        Device.Set("projectorOn", false, "Projector")
        Device.Set("lightsOn", true, "Lights")
        Device.Set("doorOpen", true, "Door")
    end,

    Shutdown = function()
        Log("SCENE: Shutdown Mode")

        Device.Set("frontDisplayOn", false, "Front Display")
        Device.Set("cameraOn", false, "Camera")
        Device.Set("screenDown", false, "Screen Up")
        Device.Set("projectorOn", false, "Projector")
        Device.Set("lightsOn", false, "Lights")
        Device.Set("doorOpen", false, "Door")
    end
}

-- ==========================================
-- SCENE TRIGGER

function EventBus.TriggerScene(sceneName)
    local scene = Scenes[sceneName]

    if scene then
        scene()
    else
        Log("Unknown scene: " .. sceneName)
    end
end

-- ==========================================
-- STATUS

function ShowStatus()
    print("----- ROOM STATUS -----")
    for k, v in pairs(room.state) do
        print(k .. ":", v)
    end
end

-- ==========================================
-- TESTS

EventBus.Trigger("VolumeUpPressed")
EventBus.Trigger("VolumeDownPressed")

EventBus.Trigger("MicButtonPressed")
EventBus.Trigger("ProjectorButtonPressed")
EventBus.Trigger("ScreenButtonPressed")
EventBus.Trigger("DisplayButtonPressed")
EventBus.Trigger("CameraButtonPressed")

EventBus.Trigger("DoorButtonPressed")
EventBus.Trigger("LightsButtonPressed")

EventBus.TriggerScene("Presentation")
ShowStatus()

EventBus.TriggerScene("VideoConference")
ShowStatus()

EventBus.TriggerScene("Shutdown")
ShowStatus()

-- ==========================================
-- BASIC STATUS CHECKS

if room.state.occupancy > 10 then
    Log("Room is heavily occupied")
else
    Log("Room is lightly occupied")
end
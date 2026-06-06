-- ==========================================
-- AV Control System v3 
-- Multi-Room + Scene Data + Event Bus
-- Author: Douglas Moth
-- Dated: May 31 - June 1, 2026

-- ==========================================

-- ==========================================
-- SYSTEM CORE

local System = {
    rooms = {}
}

-- ==========================================
-- LOGGING

local LogLevel = {
    INFO = "INFO",
    WARN = "WARN"
}

local function Log(roomName, level, message)
    print(string.format("[%s] %s | %s", level, roomName, message))
end

-- ==========================================
-- ROOM FACTORY

local function CreateRoom(name)
    return {
        name = name,

        state = {
            volume = 50,
            micMuted = true,
            screenDown = true,
            projectorOn = false,
            displayOn = false,
            cameraOn = false,
            lightsOn = true,
            doorOpen = true,
            occupancy = 0
        },

        devices = {},
        scenes = {}
    }
end



-- ==========================================
-- DEVICE REGISTRY

local Device = {}

function Device:Register(room, key, label)
    room.devices[key] = {
        label = label
    }
end

function Device:Set(room, key, value)
    if room.state[key] == nil then return end

    room.state[key] = value
    Log(room.name, LogLevel.INFO, key .. " = " .. tostring(value))
end

function Device:Toggle(room, key)
    if room.state[key] == nil then return end

    room.state[key] = not room.state[key]
    Log(room.name, LogLevel.INFO, key .. " = " .. tostring(room.state[key]))
end

function Device:AdjustVolume(room, delta)
    room.state.volume = math.max(0, math.min(100, room.state.volume + delta))
    Log(room.name, LogLevel.INFO, "volume = " .. room.state.volume)
end

-- ==========================================
-- EVENT BUS

local EventBus = {}

function EventBus:Trigger(room, event)
    Log(room.name, LogLevel.INFO, "EVENT: " .. event.name)

    local handler = EventBus[event.name]
    if handler then
        handler(room, event.payload)
    else
        Log(room.name, LogLevel.WARN, "No handler for event: " .. event.name)
    end
end

-- ==========================================
-- DEVICE EVENT HANDLERS

EventBus["VolumeUp"] = function(room)
    Device:AdjustVolume(room, 5)
end

EventBus["VolumeDown"] = function(room)
    Device:AdjustVolume(room, -5)
end

EventBus["ToggleMic"] = function(room)
    Device:Toggle(room, "micMuted")
end

EventBus["ToggleProjector"] = function(room)
    Device:Toggle(room, "projectorOn")
end

EventBus["ToggleScreen"] = function(room)
    Device:Toggle(room, "screenDown")
end

EventBus["ToggleDisplay"] = function(room)
    Device:Toggle(room, "displayOn")
end

EventBus["ToggleCamera"] = function(room)
    Device:Toggle(room, "cameraOn")
end

EventBus["ToggleLights"] = function(room)
    Device:Toggle(room, "lightsOn")
end

EventBus["ToggleDoor"] = function(room)
    Device:Toggle(room, "doorOpen")
end

-- ==========================================
-- SCENE ENGINE (DATA-DRIVEN)

local SceneEngine = {}

function SceneEngine:Apply(room, scene)
    Log(room.name, LogLevel.INFO, "SCENE: " .. scene.name)

    for _, action in ipairs(scene.actions) do

        if action.type == "set" then
            Device:Set(room, action.key, action.value)

        elseif action.type == "toggle" then
            Device:Toggle(room, action.key)

        elseif action.type == "volume" then
            Device:AdjustVolume(room, action.value)
        end
    end
end

-- ==========================================
-- SCENES (DATA)

local Scenes = {

    Presentation = {
        name = "Presentation Mode",
        actions = {
            { type = "set", key = "projectorOn", value = true },
            { type = "set", key = "screenDown", value = true },
            { type = "set", key = "displayOn", value = true },
            { type = "set", key = "cameraOn", value = false },
            { type = "set", key = "lightsOn", value = false },
            { type = "set", key = "doorOpen", value = true }
        }
    },

    VideoConference = {
        name = "Video Conference Mode",
        actions = {
            { type = "set", key = "projectorOn", value = false },
            { type = "set", key = "screenDown", value = false },
            { type = "set", key = "displayOn", value = true },
            { type = "set", key = "cameraOn", value = true },
            { type = "set", key = "lightsOn", value = true },
            { type = "set", key = "doorOpen", value = true }
        }
    },

    Shutdown = {
        name = "Shutdown Mode",
        actions = {
            { type = "set", key = "projectorOn", value = false },
            { type = "set", key = "screenDown", value = false },
            { type = "set", key = "displayOn", value = false },
            { type = "set", key = "cameraOn", value = false },
            { type = "set", key = "lightsOn", value = false },
            { type = "set", key = "doorOpen", value = false }
        }
    }
}

-- ==========================================
-- SCENE EVENT

EventBus["RunScene"] = function(room, sceneName)
    local scene = Scenes[sceneName]
    if scene then
        SceneEngine:Apply(room, scene)
    else
        Log(room.name, LogLevel.WARN, "Unknown scene: " .. tostring(sceneName))
    end
end

-- ==========================================
-- ROOM CREATION (MULTI-ROOM SUPPORT)

System.rooms["RoomA"] = CreateRoom("Room A - Main Boardroom")
System.rooms["RoomB"] = CreateRoom("Room B - Huddle Space")

local roomA = System.rooms["RoomA"]
local roomB = System.rooms["RoomB"]

-- ==========================================
-- SIMULATED INPUTS (TESTING)

EventBus:Trigger(roomA, { name = "VolumeUp" })
EventBus:Trigger(roomA, { name = "ToggleMic" })
EventBus:Trigger(roomA, { name = "ToggleProjector" })

EventBus:Trigger(roomA, { name = "RunScene", payload = "Presentation" })
EventBus:Trigger(roomA, { name = "RunScene", payload = "VideoConference" })
EventBus:Trigger(roomA, { name = "RunScene", payload = "Shutdown" })

-- Room B independent control
EventBus:Trigger(roomB, { name = "RunScene", payload = "Presentation" })

-- ==========================================
-- STATUS DUMP

local function DumpRoom(room)
    print("\n----- " .. room.name .. " -----")
    for k, v in pairs(room.state) do
        print(k .. ":", v)
    end
end

DumpRoom(roomA)
DumpRoom(roomB)
-- ==========================================
-- AV Control System v3.1 
-- Multi-Room + Scene Data + Event Bus + UI Panel
-- Author: Douglas Moth
-- Date: May 31 - June 1, 2026

-- NOTE:
-- This is my simulation of a multi-room AV control architecture
-- demonstrating event-driven design, scene-based automation,
-- and UI state rendering similar to real-world AV control systems
-- (Crestron / Q-SYS conceptual model)
-- System, Logging, Room Factory, UI, Device Layer, Scene Engine, Scenes, Event Handlers, Event Bus, Button Panel, Physical Logical Mapping, Room Creation, Simulation tests.
-- ==========================================

-- ==========================================
-- SYSTEM CORE
-- ==========================================

local System = {
    rooms = {}
}

-- ==========================================
-- LOGGING
-- ==========================================

local LogLevel = {
    INFO = "INFO",
    WARN = "WARN"
}

local function Log(roomName, level, message)
    print(string.format("[%s] %s | %s", level, roomName, message))
end

-- ==========================================
-- ROOM FACTORY
-- ==========================================

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
            occupancy = 10
        }
    }
end

-- ==========================================
-- OPERATIONS DASHBOARD UI
-- ==========================================

local UI = {}

function UI.RenderEvent(room, eventName, payload)

    print(string.format(
        "[EVENT] %s -> %s %s",
        room.name,
        eventName,
        payload and ("(" .. tostring(payload) .. ")") or ""
    ))

end

function UI.RenderOperationsDashboard(rooms)

    print("\n==========================================================================")
    print("                     LIVE AV OPERATIONS DASHBOARD")
    print("==========================================================================")

    print(string.format(
        "%-25s %-6s %-6s %-6s %-8s %-8s %-6s %-8s %-8s",
        "ROOM",
        "PROJ",
        "DISP",
        "CAM",
        "LIGHTS",
        "DOOR",
        "VOL",
        "SCREEN",
        "MIC"
    ))

    print("--------------------------------------------------------------------------")

    for _, room in pairs(rooms) do

        local s = room.state

        print(string.format(
            "%-25s %-6s %-6s %-6s %-8s %-8s %-6d %-8s %-8s",
            room.name,
            s.projectorOn and "ON" or "OFF",
            s.displayOn and "ON" or "OFF",
            s.cameraOn and "ON" or "OFF",
            s.lightsOn and "ON" or "OFF",
            s.doorOpen and "OPEN" or "CLOSED",
            s.volume,
            s.screenDown and "DOWN" or "UP",
            s.micMuted and "MUTED" or "LIVE"
        ))

    end

    print("==========================================================================\n")

end

-- ==========================================
-- DEVICE LAYER
-- ==========================================

local Device = {}

function Device:Set(room, key, value, label)
    room.state[key] = value
    Log(room.name, LogLevel.INFO, (label or key) .. " = " .. tostring(value))
end

function Device:Toggle(room, key, label)
    room.state[key] = not room.state[key]
    Log(room.name, LogLevel.INFO, (label or key) .. " = " .. tostring(room.state[key]))
end

function Device:AdjustVolume(room, delta)
    room.state.volume = math.max(0, math.min(100, room.state.volume + delta))
    Log(room.name, LogLevel.INFO, "volume = " .. room.state.volume)
end

-- ==========================================
-- EVENT HANDLERS (CLEAN SEPARATION)
-- ==========================================

local EventHandlers = {}

EventHandlers["VolumeUp"] = function(room)
    Device:AdjustVolume(room, 5)
end

EventHandlers["VolumeDown"] = function(room)
    Device:AdjustVolume(room, -5)
end

EventHandlers["ToggleMic"] = function(room)
    Device:Toggle(room, "micMuted", "Mic Muted")
end

EventHandlers["ToggleProjector"] = function(room)
    Device:Toggle(room, "projectorOn", "Projector")
end

EventHandlers["ToggleScreen"] = function(room)
    Device:Toggle(room, "screenDown", "Screen")
end

EventHandlers["ToggleDisplay"] = function(room)
    Device:Toggle(room, "displayOn", "Display")
end

EventHandlers["ToggleCamera"] = function(room)
    Device:Toggle(room, "cameraOn", "Camera")
end

EventHandlers["ToggleLights"] = function(room)
    Device:Toggle(room, "lightsOn", "Lights")
end

EventHandlers["ToggleDoor"] = function(room)
    Device:Toggle(room, "doorOpen", "Door")
end

-- ==========================================
-- SCENE ENGINE (DATA-DRIVEN)
-- ==========================================

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
-- SCENES (DATA-DRIVEN)
-- ==========================================

local Scenes = {

    Presentation = {
        name = "Presentation Mode",
        actions = {
            { type = "set", key = "projectorOn", value = true },
            { type = "set", key = "screenDown", value = true },
            { type = "set", key = "displayOn", value = false },
            { type = "set", key = "cameraOn", value = true },
            { type = "set", key = "micMuted", value = false },
            { type = "set", key = "lightsOn", value = false },
            { type = "set", key = "doorOpen", value = false },
            { type = "set", key = "volume", value = 60 }
        }
    },

    VideoConference = {
        name = "Video Conference Mode",
        actions = {
            { type = "set", key = "projectorOn", value = false },
            { type = "set", key = "screenDown", value = false },
            { type = "set", key = "displayOn", value = true },
            { type = "set", key = "cameraOn", value = true },
            { type = "set", key = "micMuted", value = false },
            { type = "set", key = "lightsOn", value = false },
            { type = "set", key = "doorOpen", value = false },
            { type = "set", key = "volume", value = 45 }
        }
    },

    FrontOffice = {
        name = "Front Office Mode",
        actions = {
            { type = "set", key = "lightsOn", value = true },
            { type = "set", key = "displayOn", value = true },
            { type = "set", key = "doorOpen", value = true },
            { type = "set", key = "cameraOn", value = true },
            { type = "set", key = "volume", value = 25 }
        }
    },

    Shutdown = {
        name = "Shutdown Mode",
        actions = {
            { type = "set", key = "projectorOn", value = false },
            { type = "set", key = "screenDown", value = false },
            { type = "set", key = "displayOn", value = false },
            { type = "set", key = "cameraOn", value = false },
            { type = "set", key = "micMuted", value = true },
            { type = "set", key = "lightsOn", value = false },
            { type = "set", key = "doorOpen", value = false },
            { type = "set", key = "volume", value = 0 }
        }
    }
}


-- ==========================================
-- EVENT BUS (ROUTER)
-- ==========================================

local EventBus = {}

function EventBus:Trigger(room, event)
    UI.RenderEvent(room, event.name, event.payload)

    local handler = EventHandlers[event.name]

    if handler then
        handler(room, event.payload)
    else
        Log(room.name, LogLevel.WARN, "No handler: " .. event.name)
    end

    -- LIVE UI UPDATE ( new and improved dashboard look)
    UI.RenderOperationsDashboard(System.rooms)
end

-- Scene trigger
EventHandlers["RunScene"] = function(room, sceneName)
    local scene = Scenes[sceneName]

    if scene then
        SceneEngine:Apply(room, scene)
    else
        Log(room.name, LogLevel.WARN, "Unknown scene: " .. tostring(sceneName))
    end
end

-- ==========================================
-- PHYSICAL BUTTON MAPPING LAYER
-- ==========================================

local ButtonPanel = {}

function ButtonPanel:Press(room, buttonId)
    local mapping = self[buttonId]

    if not mapping then
        Log(room.name, LogLevel.WARN,
            "Unmapped button: " .. buttonId)
        return
    end

    if type(mapping) == "string" then

        EventBus:Trigger(room, {
            name = mapping
        })

    elseif type(mapping) == "table" then

        EventBus:Trigger(room, mapping)

    else

        Log(room.name, LogLevel.WARN,
            "Invalid mapping: " .. buttonId)
    end
end

-- ==========================================
-- PHYSICAL TO LOGICAL MAPPINGS

ButtonPanel["MicButton"] = "ToggleMic"
ButtonPanel["ProjectorButton"] = "ToggleProjector"
ButtonPanel["ScreenButton"] = "ToggleScreen"
ButtonPanel["DisplayButton"] = "ToggleDisplay"
ButtonPanel["CameraButton"] = "ToggleCamera"
ButtonPanel["LightsButton"] = "ToggleLights"
ButtonPanel["DoorButton"] = "ToggleDoor"

ButtonPanel["VolumeUpButton"] = "VolumeUp"
ButtonPanel["VolumeDownButton"] = "VolumeDown"

ButtonPanel["PresentationButton"] = {name = "RunScene", payload = "Presentation"}
ButtonPanel["VideoConferenceButton"] = {name = "RunScene", payload = "VideoConference"}
ButtonPanel["FrontOfficeButton"] = {name = "RunScene", payload = "FrontOffice"}
ButtonPanel["ShutdownButton"] = {name = "RunScene", payload = "Shutdown"}


-- ==========================================
-- ROOM CREATION (MULTI-ROOM)
-- ==========================================

System.rooms["RoomA"] = CreateRoom("Room A - Boardroom")
System.rooms["RoomB"] = CreateRoom("Room B - Huddle Space")
System.rooms["RoomC"] = CreateRoom("Room C - SW Theater")
System.rooms["RoomD"] = CreateRoom("Room D - Front Desk")

local roomA = System.rooms["RoomA"]
local roomB = System.rooms["RoomB"]
local roomC = System.rooms["RoomC"]
local roomD = System.rooms["RoomD"]


-- ==========================================
-- SIMULATION TESTS
-- ==========================================
-- RoomA = MainBoardRoom

-- ButtonPanel:Press(roomA, "VolumeUpButton")
-- ButtonPanel:Press(roomA, "VolumeDownButton")
-- ButtonPanel:Press(roomA, "MicButton")
-- ButtonPanel:Press(roomA, "ProjectorButton")
-- ButtonPanel:Press(roomA, "LightsButton")
-- ButtonPanel:Press(roomA, "ScreenButton")
-- ButtonPanel:Press(roomA, "CameraButton")

-- ==========================================
-- Room Scenes

ButtonPanel:Press(roomA, "PresentationButton")
ButtonPanel:Press(roomA, "VideoConferenceButton")
ButtonPanel:Press(roomA, "ShutdownButton")

-- ==========================================
-- RoomB - Huddle Space

ButtonPanel:Press(roomB, "PresentationButton")
ButtonPanel:Press(roomB, "VideoConferenceButton")
ButtonPanel:Press(roomB, "ShutdownButton")

-- ==========================================
-- RoomC - Theater

ButtonPanel:Press(roomC, "PresentationButton")
ButtonPanel:Press(roomC, "ShutdownButton")

-- ==========================================
-- RoomD - Front Office

ButtonPanel:Press(roomD, "FrontOfficeButton")
ButtonPanel:Press(roomD, "ShutdownButton")


-- ==========================================
-- FINAL STATUS
-- ==========================================

UI.RenderOperationsDashboard(System.rooms)
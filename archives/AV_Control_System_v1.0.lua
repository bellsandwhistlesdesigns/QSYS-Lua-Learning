-- ==========================================
-- Hybrid AV Conference Room Demo
-- Author: Douglas Moth
-- Date: May 31, 2026
-- file = av_system.lua
-- ==========================================

local room = {
    name = "Hybrid AV Conference Room",
    occupancy = 12,
    volume = 65,
    micMuted = true,
    screenDown = true,
    projectorOn = true,
    frontDisplayOn = true,
    cameraOn = true,
    doorOpen = true,
    lightsOn = true
}
-- ==========================================
-- Volume Functions

function ShowVolume(room)
    print(room.name .. " Volume is " .. room.volume)
end

function VolumeUp(room)
    if room.volume < 100 then
        room.volume = room.volume + 5
    end
    print(room.name .. " Volume is " .. room.volume)
end

function VolumeUpButtonPressed(room)
    print("EVENT: Volume Up button Pressed")
    VolumeUp(room)
end

function VolumeDown(room)
    if room.volume > 0 then
        room.volume = room.volume - 5
    end
    print(room.name .. " Volume is " .. room.volume)
end

function VolumeDownButtonPressed(room)
    print("EVENT: Volume Down button Pressed")
    VolumeDown(room)
end

-- ==========================================
-- Microphone Functions

function MuteMics(room)
    room.micMuted = true
    print(room.name .. " Room Microphones are muted")
end

function UnMuteMics(room)
    room.micMuted = false
    print(room.name .. " Room Microphones are live")
end

function MuteMicButtonPressed(room)
    print("EVENT: Mute Button Pressed")
    if room.micMuted then
        UnMuteMics(room)
        else
            MuteMics(room)
        end
end

-- ==========================================
-- Projector Functions

function PowerOnProjector(room)
    room.projectorOn = true
    print(room.name .. " Projector powered on")
end

function PowerOffProjector(room)
    room.projectorOn = false
    print(room.name .. " Projector powered off")
end

function ProjectorPowerButtonPressed(room)
    print("EVENT: Projector Button Pressed")
    if room.projectorOn then
        PowerOffProjector(room)
        else
            PowerOnProjector(room)
    end
end

-- ==========================================
-- Screen Functions

function EngageScreenUp(room)
    room.screenDown = false
    print(room.name .. " Projector Screen is up")
end

function EngageScreenDown(room)
    room.screenDown= true
    print(room.name .. " Projector Screen is down")
end

function ScreenPowerButtonPressed(room)
    print("EVENT: Screen Power Button Pressed")
    if room.screenDown then
        EngageScreenUp(room)
        else
            EngageScreenDown(room)
    end
end

-- ==========================================
-- Front Display Functions

function FrontDisplayOn(room)
    room.frontDisplayOn = true
    print(room.name .. " Front display is on")
end

function FrontDisplayOff(room)
    room.frontDisplayOn = false
    print(room.name .. " Front display is off")
end

function FrontDisplayPowerButtonPressed(room)
    print("EVENT: Display Power Button Pressed")
    if room.frontDisplayOn then
        FrontDisplayOff(room)
        else
            FrontDisplayOn(room)
        end
end

-- ==========================================
-- Camera Functions

function CameraOn(room)
    room.cameraOn = true
    print(room.name .. " Room Camera is on")
end

function CameraOff(room)
    room.cameraOn = false
    print(room.name .. " Room Camera is off")
end

function CameraPowerButtonPressed(room)
    print("EVENT: Camera Power Button Pressed")
    if room.cameraOn then
        CameraOff(room)
    else
        CameraOn(room)
    end
end

-- ==========================================
-- Door Functions

function DoorOpen(room)
    room.doorOpen = true
    print(room.name .. " The Room Door is open")
end

function DoorClosed(room)
    room.doorOpen = false
    print(room.name .. " The Room Door is closed")
end

-- ==========================================
-- Room Light Functions

function LightsOn(room)
    room.lightsOn = true
    print(room.name .. " The lights are on")
end

function LightsOff(room)
    room.lightsOn = false
    print(room.name .. " The lights are off")
end

function LightsButtonPressed(room)
    print("EVENT: Lights on Power Button Pressed")
    if room.lightsOn then
        LightsOff(room)
        else
            LightsOn(room)
    end
end

-- ==========================================
-- Scene Function

function StartPresentationMode(room)
    print("SCENE: Presentation Mode")

    PowerOnProjector(room)
    EngageScreenDown(room)
    FrontDisplayOn(room)
    CameraOff(room)
    LightsOff(room)
    DoorOpen(room)
end
function PresentationButtonPressed(room)
    print("EVENT: Presentation Mode Button Pressed")
    StartPresentationMode(room)
end

function StartVideoConferenceMode(room)
    print("SCENE: Video Conference Mode")

    FrontDisplayOn(room)
    CameraOn(room)
    EngageScreenUp(room)
    PowerOffProjector(room)
    LightsOn(room)
    DoorOpen(room)
end
function VideoConferenceButtonPressed(room)
    print("EVENT: Video Conference Mode Button Pressed")
    StartVideoConferenceMode(room)
end

function RoomShutDownMode(room)
    print("SCENE: Room Shut Down Mode")

    FrontDisplayOff(room)
    CameraOff(room)
    EngageScreenUp(room)
    PowerOffProjector(room)
    LightsOff(room)
    DoorClosed(room)
end
function RoomShutDownButtonPressed(room)
    print("EVENT: Room Shut Down Button Pressed")
    RoomShutDownMode(room)
end

-- ==========================================
-- Room Status Function

function ShowRoomStatus(room)
    print("----- Room Status -----")
    print("Projector:", room.projectorOn)
    print("Screen Down:", room.screenDown)
    print("Display:", room.frontDisplayOn)
    print("Camera:", room.cameraOn)
    print("Lights:", room.lightsOn)
    print("Mics Muted:", room.micMuted)
    print("Volume:", room.volume)
    print("Door:", room.doorOpen)
    print("Occupancy:", room.occupancy)
end

-- END OF ROOM FUNCTIONS 

-- ==========================================

-- ==========================================
-- FUNCTION TESTS 

ShowVolume(room) -- testing the function

VolumeUpButtonPressed(room)
print("Volume state:", room.volume)

VolumeDownButtonPressed(room)
print("Volume state:", room.volume)

-- MuteMics(room) -- testing the function

MuteMicButtonPressed(room) -- testing the function 
print("Microphone state:", room.micMuted)

ProjectorPowerButtonPressed(room) -- testing the function
print("Projector state:", room.projectorOn)

-- PowerOnProjector(room) -- testing the function
-- print("Projector state:", room.projectorOn) 

-- PowerOffProjector(room) -- testing the function
-- print("Projector state:", room.projectorOn)

ScreenPowerButtonPressed(room) -- testing the function
print("Screen state:", room.screenDown)

-- EngageScreenUp(room) -- testing the function
-- print("ScreenDown state:", room.screenDown)

-- EngageScreenDown(room) -- testing the function
-- print("ScreenDown state:", room.screenDown)

-- FrontDisplayOn(room) -- testing the function
-- print("FrontDisplay state:", room.frontDisplayOn)

-- FrontDisplayOff(room) -- testing the function
-- print("FrontDisplay state:", room.frontDisplayOn)

FrontDisplayPowerButtonPressed(room) -- testing the function
print("FrontDisplay state:", room.frontDisplayOn)

-- CameraOn(room) -- testing the function
-- print("RoomCamera state:", room.cameraOn)

-- CameraOff(room) -- testing the function
-- print("RoomCamera state:", room.cameraOn)

CameraPowerButtonPressed(room) -- testing the function
print("RoomCamera state:", room.cameraOn)

DoorOpen(room) -- testing the function
print("DoorOpen state:", room.doorOpen)

DoorClosed(room) -- testing the function
print("DoorOpen state:", room.doorOpen)

-- LightsOn(room) -- testing the function
-- print("Lights state:", room.lightsOn)

-- LightsOff(room) -- testing the function
-- print("Lights state:", room.lightsOn)

LightsButtonPressed(room) -- testing the function
print("Lights state:", room.lightsOn)

PresentationButtonPressed(room) -- testing the function

ShowRoomStatus(room)

VideoConferenceButtonPressed(room) -- testing the function

ShowRoomStatus(room)

RoomShutDownButtonPressed(room) -- testing the function

ShowRoomStatus(room)

-- END FUNCTION TESTS 
-- ==========================================

-- ==========================================
-- STATUS CHECKS AND PRINTS

-- Room Occupancy

if room.occupancy > 10 then
    print(room.name .. " Room is heavily occupied")
else
    print(room.name .. " Room is lightly occupied")
end


-- check if volume is too high

if room.volume > 50 then
    print(room.name .." Room volume is high")
else
    print(room.name .. " Room volume is low")
end



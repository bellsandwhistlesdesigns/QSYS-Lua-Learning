-- ==========================================
-- TCP SOCKET FOR PROJECTORS V1.0
-- Created By: Douglas Moth
-- Date: June 5, 2026
-- Phase 1 Complete - Driver Simulation Projector
-- ==========================================

-- ==========================================
-- Device Driver State Table for Projector
-- ==========================================

Projector = {

        IP = "192.168.1.50",
        Port = 23,

        -- Placeholder for Q-SYS socket
        Socket = nil, 

        State = {
            Connected = false,

        Control = {
            Power = false,
            Input = "HDMI1",
            Volume = 45,
            Mute = false
        },

        Feedback = {
            LampHours = 1001,
            Temperature = 34
        }
    }
}

-- ==========================================
-- End State Table
-- ==========================================

-- ==========================================
-- SIMULATED DEVICE RESPONSES
-- ==========================================

function Projector.SimulateResponse(command)

    if command == "PWR ON" then
        Projector.ParseResponse("PWR=ON")

    elseif command == "PWR OFF" then
        Projector.ParseResponse("PWR=OFF")
    
    elseif command == "INPUT HDMI1" then
        Projector.ParseResponse("INPUT=HDMI1")
        
    elseif command == "INPUT HDMI2" then
        Projector.ParseResponse("INPUT=HDMI2")
    end

end

-- ==========================================
-- CONNECTION FUNCITONS
-- ==========================================

function Projector.Connect()

    print("Connecting to "
    .. Projector.IP
    .. ":"
    .. Projector.Port)

    Projector.State.Connected = true
end

function Projector.Disconnect()

print("Disconnecting")

Projector.State.Connected = false

Projector.State.Control.Power = false
Projector.State.Control.Mute = false

end

-- End State Table Connected Function
-- ==========================================

-- ==========================================
-- COMMUNICATION FUNCTIONS
-- ==========================================

function Projector.SendCommand(command)

print("TCP SEND -> " .. command)

Projector.SimulateResponse(command)

end

function Projector.ParseResponse(response)

print("TCP RECV -> " .. response)

-- Power Feedback

if response == "PWR=ON" then

    Projector.State.Control.Power = true

elseif response == "PWR=OFF" then

    Projector.State.Control.Power = false

end

-- Input Feedback

local input =
    string.match(response,
    "INPUT=(.+)")

if input then

    Projector.State.Control.Input = input

end

-- Temperature Feedback

local temp =
    string.match(response,
    "TEMP=(%d+)")

if temp then

    Projector.State.Feedback.Temperature =
        tonumber(temp)

end

-- Lamp Hours Feedback

local lamp =
    string.match(response,
    "LAMP=(%d+)")

if lamp then

    Projector.State.Feedback.LampHours =
        tonumber(lamp)

end

end

-- ==========================================
-- END COMMUNICATIONS FUNCTIONS
-- ==========================================

-- ==========================================
-- Begin State Table .Control functions
-- ==========================================

-- ==========================================
-- Power On Function 

function Projector.PowerOn()

if not Projector.State.Connected then

    print("Projector not connected")
    return

end

Projector.SendCommand("PWR ON")

end

function Projector.PowerOff()

if not Projector.State.Connected then

    print("Projector not connected")
    return

end

Projector.SendCommand("PWR OFF")

end

function Projector.SetInput(input)

if not Projector.State.Connected then

    print("Projector not connected")
    return

end

Projector.SendCommand(
    "INPUT " .. input
)

end

function Projector.SetVolume(level)

if not Projector.State.Connected then

    print("Projector not connected")
    return

end

level = math.max(
    0,
    math.min(100, level)
)

Projector.SendCommand(
    "VOL " .. level
)

-- Simulated local update
Projector.State.Control.Volume =
    level

end

function Projector.ToggleMute()

if not Projector.State.Connected then

    print("Projector not connected")
    return

end

Projector.State.Control.Mute =
    not Projector.State.Control.Mute

Projector.SendCommand("MUTE")

end

-- ==========================================



-- ==========================================
-- End of .Control Functions
-- ==========================================

-- ==========================================
-- Start of .Feedback Functions

function Projector.GetLampHours()
    return Projector.State.Feedback.LampHours
end

function Projector.GetTemperature()
    return Projector.State.Feedback.Temperature
end

-- End of .Feedback Functions
-- ==========================================

-- ==========================================
-- Projector Status
-- ==========================================

function Projector.Status()

    print("\nPROJECTOR STATUS")

    print("Connected:",
        Projector.State.Connected)

    print("Power:",
        Projector.State.Control.Power)

    print("Input:", 
        Projector.State.Control.Input)

    print("Volume:",
        Projector.State.Control.Volume)

    print("Mute:",
        Projector.State.Control.Mute)

    print("LampHours:",
        Projector.GetLampHours())

    print("Temperature:",
        Projector.GetTemperature())
end

-- End of Status
-- ==========================================


-- ==========================================
-- Projector Function Tests
-- ==========================================

Projector.ParseResponse("PWR=ON")
Projector.ParseResponse("PWR=OFF")
Projector.ParseResponse("INPUT=HDMI1")
Projector.ParseResponse("INPUT=HDMI2")
Projector.ParseResponse("TEMP=42")
Projector.ParseResponse("LAMP=1250")

Projector.Status()

Projector.Connect()

Projector.PowerOn()

Projector.SetVolume(75)

Projector.Status()

Projector.PowerOff()

Projector.Disconnect()

Projector.Status()

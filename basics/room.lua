local rooms = {
    {
    name = "Hybrid AV Office",
    volume = 75,
    micMuted = false
    },
    {
    name = "Hybrid AV Conference Room",
    volume = 75,
    micMuted = false
    },
    {
    name = "Hybrid AV Sub Office",
    volume = 75,
    micMuted = false,
    }
}

for i, room in ipairs(rooms) do
    print(room.name, room.volume, room.micMuted)
end
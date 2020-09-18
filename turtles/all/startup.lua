sleep(1)

os.loadAPI("/programs/inventory.lua")
os.loadAPI("/programs/messaging.lua")
os.loadAPI("/programs/modem.lua")
os.loadAPI("/programs/position.lua")
os.loadAPI("/programs/direction.lua")
os.loadAPI("/programs/command.lua")
os.loadAPI("/programs/state.lua")

position.refresh()

print(textutils.serialise(table.pack(position.get())))

settings.load()

state.watchState()

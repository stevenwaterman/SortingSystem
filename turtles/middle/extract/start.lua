local type, x, y, z, slice = position.get()
local ourRequests = allRequests[slice]

state.setSlice("turn", { ourRequests = ourRequests, shulkerNumber = 1 })
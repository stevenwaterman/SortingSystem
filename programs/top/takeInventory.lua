local x, y, subState = ...

if subState == "done" then
  shell.run("/programs/_done.lua")
end
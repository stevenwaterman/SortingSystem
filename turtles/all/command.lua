function execute(command)
  local file = fs.open("/command", "w")
  file.write(command)
  file.close()
  
  os.run({}, "/command")

  fs.delete("/command")
end

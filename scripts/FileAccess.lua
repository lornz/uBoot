--SOURCE: http://stackoverflow.com/questions/11201262/file-read-in-lua

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file, directory)
  local path = system.pathForFile( file, directory )
  local f = io.open(path, "r")
  lines = {}
  for line in f:lines() do 
    lines[#lines + 1] = line
  end
  return lines
end
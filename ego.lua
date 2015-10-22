module (..., package.seeall)


function saveFile( fileName, fileData )
	--Path for file
	local path = system.pathForFile( fileName, system.DocumentsDirectory )
	--Open the file
	local file = io.open( path, "w+" )
	
	--Save specified value to the file
	if file then
	   file:write( fileData )
	   io.close( file )
	end
end

--Load function
function loadFile( fileName )
--Path for file
local path = system.pathForFile( fileName, system.DocumentsDirectory )
--Open the file
local file = io.open( path, "r" )
	
	--If the file exists return the data
	if file then
	   local fileData = file:read( "*a" )
	   io.close( file )
	   return fileData
	--If the file doesn't exist create it and write it with "empty"
	else
	   file = io.open( path, "w" )
	   file:write( "empty" )
	   io.close( file )
	   return "empty"
	end
end
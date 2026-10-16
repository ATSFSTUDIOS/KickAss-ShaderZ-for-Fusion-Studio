_VERSION = [[v1.0 2019-12-17]]
--[[--
==============================================================================
Save Selection to Macro.lua - v1.0 2019-12-17
==============================================================================
Requires : Fusion v9.0.2-16.1.1++ or Resolve v15-16.1.1+
Created by : Andrew Hazelden <andrew@andrewhazelden.com>

==============================================================================
Overview
==============================================================================
The "Save Selection to Macro.lua" script will export the active Nodes view selection to a new Fusion "Macros:/" PathMap based ".setting" file on disk.

--]]--

-- Get the current operating system platform
platform = (FuPLATFORM_WINDOWS and 'Windows') or (FuPLATFORM_MAC and 'Mac') or (FuPLATFORM_LINUX and 'Linux')

-- Open the macro .setting text file in an external editing program
function OpenDocument(title, appPath, docPath)
	if platform == 'Windows' then
		-- Running on Windows
		command = 'start "" "' .. appPath .. '" "' .. docPath .. '" &'
	elseif platform == 'Mac' then
		-- Running on Mac
		command = 'open -a "' .. appPath .. '" "' .. docPath .. '" &'
	 elseif platform == "Linux" then
		-- Running on Linux
		command = '"' .. appPath .. '" "' .. docPath .. '" &'
	else
		print('[Error] There is an invalid Fusion platform detected')
		return
	end

	comp:Print('[' .. title .. '] [App] "' .. appPath .. '" [Document] "' .. docPath .. '"\n')
	-- comp:Print('[Launch Command] ' .. tostring(command) .. '\n')
	os.execute(command)
end

-- Save the macro to disk
-- Example: SaveMacro(nodes, '/Users/WSL/Desktop/Macro.setting')
function SaveMacro(settingString, filepath)
	print('[Save a Macro] ' .. tostring(filepath))
	-- Open up the file pointer for the output textfile
	outFile, err = io.open(filepath, 'w')
	if err then 
		print('[Error Opening File for Writing] ' .. tostring(filepath))
		return err
	end

	-- Write out a "Macros:/Macro.setting" file.
	outFile:write(settingString)
	outFile:write('\n')
	outFile:close()
end


-- Open the macro in a script editor
function EditMacro(filepath)
	-- Check if the .setting file exists
	if bmd.fileexists(filepath) then	
		-- Get the current Fusion "Script Editor" preference
		editorPath = fu:GetPrefs('Global.Script.EditorPath')
		if editorPath == nil or editorPath == "" then
			comp:Print('[Script Editor] The "Editor Path" is empty. Please choose a text editor in the Fusion Preferences "Global and Default Settings > Script > Editor Path" section.\n')
			app:ShowPrefs("PrefsScript")
		else
			-- Open the macro .setting text file in an external editing program
			OpenDocument('Script Editor', editorPath, filepath)
		end
	end
end

-- The main function
function Main()
	-- Get the current foreground comp
	comp = fusion.CurrentComp

	-- Get the selected nodes as a string based upon the raw Lua table data
	local nodes = bmd.writestring(comp:CopySettings())

	-- Get the number of selected nodes
	local selected = #comp:GetToolList(true)

	-- Check if any nodes were selected, and the CopySettings() command succeeded
	if(selected > 0) and nodes then
		-- Get the active node from the Nodes View
		selectedTool = tool or comp.ActiveTool
		if selectedTool ~= nil and selectedPath ~= '' then
			-- The selection was valid so append a file extension
			selectedTool = selectedTool .. '.setting'
		else
			-- The selection was a nil value so force in a default node name
			selectedTool = 'Macro.setting'
		end

		-- Show a file dialog and get the name of the file to save
		selectedFilePath = comp:MapPath(fu:RequestFile('Macros:/', selectedTool, {FReqB_Saving = true}))
		if selectedFilePath and selectedFilePath ~= '' then
			-- Save the macro to disk
			SaveMacro(nodes, selectedFilePath)

			-- Open the macro in a script editor
			EditMacro(selectedFilePath)
		else
			print('[Save a Macro] Please enter a filename for the macro.')
			return
		end
	end
end


Main()
print("[Done]")

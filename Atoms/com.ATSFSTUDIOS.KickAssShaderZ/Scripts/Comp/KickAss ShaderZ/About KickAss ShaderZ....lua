_VERSION = [[v1.2.1 2026-01-24]]
--[[--
==============================================================================
About KickAss ShaderZ.lua - v1.21 2026-01-24 -4
==============================================================================
Requires    : Fusion v9.0.2-20+ or Resolve v15-20+
Created by  : andromeda_girl
              Andrew Hazelden <andrew@andrewhazelden.com>


==============================================================================
Overview
==============================================================================
KickAss ShaderZ aka "KAS" is a collection of Fusion 3D workspace based surface materials created by the Fusion community itself.

==============================================================================
Installation
==============================================================================
This script is deployed automatically by KickAss's installer and saved to:

AllData:/Reactor/KickAss/Deploy/Scripts/Comp/KickAss Shaderz/About KickAss ShaderZ.lua

==============================================================================
Usage
==============================================================================
Step 1. Use Reactor to install "KickAss ShaderZ".

Step 2. Restart Fusion.

Step 3. A "KickAss ShaderZ" menu has been added to the main menu bar in Fusion Standalone.

Step 4. The "KickAss Shaderz > About KickAss Shaderz" menu item provides access to the version number of the release.

--]]--

-- Open a Webpage
-- Example: OpenURL("We Suck Less", "https://www.steakunderwater.com/")
function OpenURL(siteName, path)
	if platform == "Windows" then
		-- Running on Windows
		command = "explorer \"" .. path .. "\""
	elseif platform == "Mac" then
		-- Running on Mac
		command = "open \"" .. path .. "\" &"
	elseif platform == "Linux" then
		-- Running on Linux
		command = "xdg-open \"" .. path .. "\" &"
	else
		comp:Print("[Error] There is an invalid Fusion platform detected\n")
		return
	end

	os.execute(command)

	-- comp:Print("[Launch Command] " tostring(command) .. "\n")
	comp:Print("[Opening URL] " .. tostring(path) .. "\n")
end


-- Create the "About KickAss Shaders" UI Manager dialog
function AboutKickAssWin()
	-- Configure the window Size
	local originX, originY, width, height = 200, 200, 595, 212

	-- Create the new UI Manager Window
	local win = disp:AddWindow({
		ID = "AboutKickAssWin",
		TargetID = "AboutKickAssWin",
		WindowTitle = "About KickAss ShaderZ",
		WindowFlags = {
			Window = true,
			WindowStaysOnTopHint = true,
		},
		Geometry = {
			originX,
			originY,
			width,
			height,
		},

		ui:VGroup {
			ID = "root",

			ui:HGroup{
				Weight = 0,
				
				ui:VGroup {
					Weight = 1,
					Margin = 0,
					Spacing = 0,
					Padding = 0,
					ui:Label {
						ID = "KickAssTitle",
						Weight = 0,

						Text = "KickAss ShaderZ",
						ReadOnly = true,
						Alignment = {
							AlignHCenter = true,
							AlignVCenter = true,
						},
						Font = ui:Font{
							PixelSize = 36,
						},
					},

					ui:Label {
						ID = "VersionLabel",
						Weight = 1,

						Text = _VERSION,
						WordWrap = true,
						Alignment = {
							AlignHCenter = true,
							AlignVCenter = true,
						},
						-- Font = ui:Font{
						-- 	PixelSize = 18,
						-- },
					},

				},
			},

			ui:VGroup{
				ui:Label {
					ID = "AboutLabel",
					Text = [["KickAss ShaderZ" is a community supported repository of material shaders for the Fusion community by the Fusion community. Curated by Andromeda_Girl and developed for Reactor by Andrew Hazelden. WSL members can submit shaders to be added and watch the library grow.]],
					OpenExternalLinks = true,
					WordWrap = true,
					Alignment = {
						AlignHCenter = true,
						AlignVCenter = true,
					},
					-- Font = ui:Font{
					-- 	PixelSize = 14,
					-- },
				},

				ui:Label {
					ID = "URLLabel",
					Weight = 0,
					Text = [[Copyright © 2019-2026 We Suck Less Community<br><a href="https://www.steakunderwater.com/wesuckless/viewtopic.php?p=27949#p27949" style="color: rgb(139,155,216)">https://www.steakunderwater.com/wesuckless/viewtopic.php?p=27949#p27949</a>]],
					OpenExternalLinks = true,
					WordWrap = true,
					Alignment = {
						AlignHCenter = true,
					},
					-- Font = ui:Font{
					-- 	PixelSize = 12,
					-- },
				},

			},
		},
	})


	-- Add your GUI element based event functions here:
	itm = win:GetItems()

	-- The window was closed
	function win.On.AboutKickAssWin.Close(ev)
		disp:ExitLoop()
	end

	-- Open the We Suck Less webpage when the KickAss logo is clicked
	function win.On.KickAssIconButton.Clicked(ev)
		OpenURL("We Suck Less", "https://www.steakunderwater.com/wesuckless/viewtopic.php?p=27949#p27949")
		disp:ExitLoop()
	end

	-- The app:AddConfig() command that will capture the "Control + W" or "Control + F4" hotkeys so they will close the window instead of closing the foreground composite.
	app:AddConfig("AboutKickAssWin", {
		Target {
			ID = "AboutKickAssWin",
		},

		Hotkeys {
			Target = "AboutKickAssWin",
			Defaults = true,

			CONTROL_W  = "Execute{ cmd = [[ app.UIManager:QueueEvent(obj, 'Close', {}) ]] }",
			CONTROL_F4 = "Execute{ cmd = [[ app.UIManager:QueueEvent(obj, 'Close', {}) ]] }",
			ESCAPE = "Execute{ cmd = [[ app.UIManager:QueueEvent(obj, 'Close', {}) ]] }",
		},
	})

	-- Init the window
	win:Show()
	disp:RunLoop()
	win:Hide()
	app:RemoveConfig('AboutKickAssWin')
	collectgarbage()

	return win,win:GetItems()
end

-- The Main function
function Main()
	-- Find out the current Fusion host platform (Windows/Mac/Linux)
	platform = (FuPLATFORM_WINDOWS and "Windows") or (FuPLATFORM_MAC and "Mac") or (FuPLATFORM_LINUX and "Linux")

	-- Display the "About KickAss" dialog
	ui = app.UIManager
	disp = bmd.UIDispatcher(ui)
	AboutKickAssWin()
end


Main()
print("[Done]")

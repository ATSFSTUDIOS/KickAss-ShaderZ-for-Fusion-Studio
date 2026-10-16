_VERSION = [[v1.2 2022-11-28]]
--[[--
==============================================================================
Content Browser.lua - v1.2 2021-11-29 01.06 GMT -4
==============================================================================
Requires    : Fusion v9.0.2-18.1+ or Resolve v15-18.1+
Created by  : Andrew Hazelden <andrew@andrewhazelden.com>

==============================================================================
Overview
==============================================================================
ShaderZ Browser is a content navigator that displays resources inside the hierarchy of:

	Macros:/KickAss Shaderz/Native ShaderZ/

The buttons are programmed to add the associated .setting file to the composite when clicked.

==============================================================================
Installation
==============================================================================
This script is deployed automatically by KickAss's installer and saved to:

	AllData:/Reactor/KickAss/Deploy/Scripts/Comp/KickAss Shaderz/Content Browser....lua

==============================================================================
Usage
==============================================================================
Step 1. Use Reactor to install "KickAss ShaderZ".

Step 2. Restart Fusion.

Step 3. A "KickAss ShaderZ" menu has been added to the main menu bar in Fusion Standalone.

Step 4. The "KickAss ShaderZ > Content Browser..." menu item provides access to surface material centric "Fusion Bin" like content browser window.

==============================================================================
Todo
==============================================================================
- Add a UI Manager "find window" check to avoid multiple content browser windows from loading at the same time
- Add a Multipath scanning Lua script to auto-regenerate each of the Category Tabs and their contents.
- Add an icon for .comp files so they could be listed as a clickable entry.
- Add a pair of "Next" and "Previous" buttons to allow browsing multiple pages of content
- Add a view toggle button to switch the Content Browser layout between a list (iu:Tree) view and the current icon grid view layout.
- Add a mini vs large icon control to allow switching between a compact content browser window, and the current 130x100px icon size for each macro.
- Save the window position when it is closed, and then restore that position the next time the window is displayed. (This would require a window position reset option when a dual window layout is changed back to a single monitor setup.)
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
function KickAssWin()
	-- Configure the window Size
	local originX, originY, width, height = 50, 115, 1200, 390
	--local originX, originY, width, height = 50, 115, 1200, 530

	-- Path to ShaderZ macros folder
	local imagesFolder = "Macros:/KickAss ShaderZ/Native ShaderZ/"

	-- Max shaders per category
	-- 2x7 buttons
	local totalShaderZ = 14
	-- 3x7 buttons
	-- local totalShaderZ = 21

	-- Thumbnails image table
	local shadersTable = {
		HDRI = {
			"kas_Parkland",
			"kas_SimonsTownRocks",
			"kas_StNicholasChurch",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
--			"",
--			"",
--			"",
--			"",
--			"",
--			"",
--			"",
		},
		Industrial = {
			"kas_Atomic",
			"kas_Chrome",
			"kas_CobaltBlueCarbonFibre",
			"kas_GlassDeepBlue",
			"kas_GlassDeepRuby",
			"kas_GlassDirty",
			"kas_GlassQuartzScratched",
			"kas_Gold",
			"kas_HeatShield",
			"kas_MetalGalvanized",
			"kas_MetalScuzzy",
			"kas_Radioactive",
			"kas_RustyNail",
			"kas_Xray",
			"",
--			"",
--			"",
--			"",
--			"",
--			"",
--			"",
--			"",
		},
		Natural = {
			"kas_DarkBlueIceShard",
			"kas_GreenEctoplasm",
			"kas_IridescentBlue",
			"kas_MarbleStone",
			"kas_Ocean",
			"kas_OrganicMote",
			"kas_RedBloodCell",
			"kas_StoneWall",
			"kas_VelvetyMoss",
			"kas_VolcanicMagma",
			"",
			"",
			"",
			"",
			"",
--			"",
--			"",
--			"",
--			"",
--			"",
--			"",
--			"",
		},
		Utility = {
			"kas_GreyCheckerboard",
			"kas_IconSaver",
			"kas_ShaderBall",
			"kas_ShaderBallDragon",
			"kas_ShaderPreview",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
--			"",
--			"",
--			"",
--			"",
--			"",
--			"",
--			"",
		},
	}

	-- Create the new UI Manager Window
	local win = disp:AddWindow({
		ID = "KickAssWin",
		TargetID = "KickAssWin",
		WindowTitle = "KickAss ShaderZ | Content Browser",
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
				Weight = 0.01,
				-- Add three buttons that have an icon resource attached and no border shading
				ui:Button{
					ID = 'CategoryButton1',
					Text = 'Industrial',
					Flat = true,
					Checkable = true,
					Checked = true,
					MinimumSize = {128, 64},
				},
				ui:Button{
					ID = 'CategoryButton2',
					Text = 'Natural',
					Flat = true,
					Checkable = true,
					MinimumSize = {128, 64},
				},
				ui:Button{
					ID = 'CategoryButton3',
					Text = 'Utility',
					Flat = true,
					Checkable = true,
					MinimumSize = {128, 64},
				},
				ui:Button{
					ID = 'CategoryButton4',
					Text = 'HDRI',
					Flat = true,
					Checkable = true,
					MinimumSize = {128, 64},
				},
			},
			ui:HGroup{
				ID = "ShadersHGroup1",
				-- Shader 1
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton1",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel1",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 2
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton2",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel2",
						
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 3
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton3",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel3",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 4
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton4",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel4",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 5
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton5",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel5",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 6
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton6",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel6",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 7
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton7",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel7",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
			},
			ui:HGroup{
				ID = "ShadersHGroup2",
				-- Shader 8
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton8",
						Flat = true,
						IconSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel8",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 9
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton9",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel9",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 10
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton10",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel10",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 11
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton11",
						Flat = true,
						IconSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel11",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 12
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton12",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel12",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 13
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton13",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel13",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
				-- Shader 14
				ui:VGroup{
					Weight = 0.01,
					MinimumSize = {160,100},
					ui:Button{
						Weight = 0.01,
						ID = "ContentButton14",
						Flat = true,
						IconSize = {130,100},
						MinimumSize = {130,100},
						Icon = ui:Icon{
						}, 
					},
					ui:Label{
						Weight = 0.01,
						ID = "ContentLabel14",
						Alignment = {
							AlignHCenter = true,
							AlignTop = true,
						},
					},
				},
			},
--			ui:HGroup{
--				ID = "ShadersHGroup4",
--				-- Shader 15
--				ui:VGroup{
--					Weight = 0.01,
--					ui:Button{
--						Weight = 0.01,
--						ID = "ContentButton15",
--						Flat = true,
--						IconSize = {130,100},
--						MinimumSize = {130,100},
--						Icon = ui:Icon{
--						}, 
--					},
--					ui:Label{
--						Weight = 0.01,
--						ID = "ContentLabel15",
--						Alignment = {
--							AlignHCenter = true,
--							AlignTop = true,
--						},
--					},
--				},
--				-- Shader 16
--				ui:VGroup{
--					Weight = 0.01,
--					ui:Button{
--						Weight = 0.01,
--						ID = "ContentButton16",
--						Flat = true,
--						IconSize = {130,100},
--						MinimumSize = {130,100},
--						Icon = ui:Icon{
--						}, 
--					},
--					ui:Label{
--						Weight = 0.01,
--						ID = "ContentLabel16",
--						Alignment = {
--							AlignHCenter = true,
--							AlignTop = true,
--						},
--					},
--				},
--				-- Shader 17
--				ui:VGroup{
--					Weight = 0.01,
--					ui:Button{
--						Weight = 0.01,
--						ID = "ContentButton17",
--						Flat = true,
--						IconSize = {130,100},
--						MinimumSize = {130,100},
--						Icon = ui:Icon{
--						}, 
--					},
--					ui:Label{
--						Weight = 0.01,
--						ID = "ContentLabel17",
--						Alignment = {
--							AlignHCenter = true,
--							AlignTop = true,
--						},
--					},
--				},
--				-- Shader 18
--				ui:VGroup{
--					Weight = 0.01,
--					ui:Button{
--						Weight = 0.01,
--						ID = "ContentButton18",
--						Flat = true,
--						IconSize = {130,100},
--						MinimumSize = {130,100},
--						Icon = ui:Icon{
--						}, 
--					},
--					ui:Label{
--						Weight = 0.01,
--						ID = "ContentLabel18",
--						Alignment = {
--							AlignHCenter = true,
--							AlignTop = true,
--						},
--					},
--				},
--				-- Shader 19
--				ui:VGroup{
--					Weight = 0.01,
--					ui:Button{
--						Weight = 0.01,
--						ID = "ContentButton19",
--						Flat = true,
--						IconSize = {130,100},
--						MinimumSize = {130,100},
--						Icon = ui:Icon{
--						}, 
--					},
--					ui:Label{
--						Weight = 0.01,
--						ID = "ContentLabel19",
--						Alignment = {
--							AlignHCenter = true,
--							AlignTop = true,
--						},
--					},
--				},
--				-- Shader 20
--				ui:VGroup{
--					Weight = 0.01,
--					ui:Button{
--						Weight = 0.01,
--						ID = "ContentButton20",
--						Flat = true,
--						IconSize = {130,100},
--						MinimumSize = {130,100},
--						Icon = ui:Icon{
--						}, 
--					},
--					ui:Label{
--						Weight = 0.01,
--						ID = "ContentLabel20",
--						Alignment = {
--							AlignHCenter = true,
--							AlignTop = true,
--						},
--					},
--				},
--				-- Shader 21
--				ui:VGroup{
--					Weight = 0.01,
--					ui:Button{
--						Weight = 0.01,
--						ID = "ContentButton21",
--						Flat = true,
--						IconSize = {130,100},
--						MinimumSize = {130,100},
--						Icon = ui:Icon{
--						}, 
--					},
--					ui:Label{
--						Weight = 0.01,
--						ID = "ContentLabel21",
--						Alignment = {
--							AlignHCenter = true,
--							AlignTop = true,
--						},
--					},
--				},
--			},

			-- Flexible spacer
			ui:VGap(5, 5),

			ui:VGroup{
				Weight = 0.01,
				ui:Label {
					ID = "URLLabel",
					Weight = 0.01,
					Text = [[Copyright © 2019-2021 We Suck Less Community<br><a href="https://www.steakunderwater.com/wesuckless/viewtopic.php?p=27949#p27949" style="color: rgb(139,155,216)">https://www.steakunderwater.com/wesuckless/viewtopic.php?p=27949#p27949</a>]],
					OpenExternalLinks = true,
					WordWrap = true,
					Alignment = {
						AlignHCenter = true,
					},
				},
			},
		},
	})


	-- Add your GUI element based event functions here:
	itm = win:GetItems()

	-- The window was closed
	function win.On.KickAssWin.Close(ev)
		disp:ExitLoop()
	end

	function win.On.CategoryButton1.Clicked(ev)
		print("[Category] Industrial")

		-- Update the linked state of the buttons
		itm.CategoryButton1.Checked = true
		itm.CategoryButton2.Checked = false
		itm.CategoryButton3.Checked = false
		itm.CategoryButton4.Checked = false

		-- Update the icons in the content browser window
		UpdateIconButtons()
	end
	
	function win.On.CategoryButton2.Clicked(ev)
		print("[Category] Natural")

		-- Update the linked state of the buttons
		itm.CategoryButton1.Checked = false
		itm.CategoryButton2.Checked = true
		itm.CategoryButton3.Checked = false
		itm.CategoryButton4.Checked = false

		-- Update the icons in the content browser window
		UpdateIconButtons()
	end
	
	function win.On.CategoryButton3.Clicked(ev)
		print("[Category] Utility")

		-- Update the linked state of the buttons
		itm.CategoryButton1.Checked = false
		itm.CategoryButton2.Checked = false
		itm.CategoryButton3.Checked = true
		itm.CategoryButton4.Checked = false

		-- Update the icons in the content browser window
		UpdateIconButtons()
	end
	
	function win.On.CategoryButton4.Clicked(ev)
		print("[Category] HDRI")

		-- Update the linked state of the buttons
		itm.CategoryButton1.Checked = false
		itm.CategoryButton2.Checked = false
		itm.CategoryButton3.Checked = false
		itm.CategoryButton4.Checked = true

		-- Update the icons in the content browser window
		UpdateIconButtons()
	end

	function UpdateIconButtons()
		-- Refresh the shader icons
		local activeCategory = ""
		local activeTable = {}

		if itm.CategoryButton1.Checked then
			-- Industrial
			activeCategory = "Industrial"
			activeTable = shadersTable.Industrial
		elseif itm.CategoryButton2.Checked then
			-- Natural
			activeCategory = "Natural"
			activeTable = shadersTable.Natural
		elseif itm.CategoryButton3.Checked then
			-- Utility
			activeCategory = "Utility"
			activeTable = shadersTable.Utility
		elseif itm.CategoryButton4.Checked then
				-- HDRI
			activeCategory = "HDRI"
			activeTable = shadersTable.HDRI
		else
			activeCategory = "Industrial"
			activeTable = shadersTable.Industrial
		end

		-- Control names
		LabelTable = {
			itm.ContentLabel1,
			itm.ContentLabel2,
			itm.ContentLabel3,
			itm.ContentLabel4,
			itm.ContentLabel5,
			itm.ContentLabel6,
			itm.ContentLabel7,
			itm.ContentLabel8,
			itm.ContentLabel9,
			itm.ContentLabel10,
			itm.ContentLabel11,
			itm.ContentLabel12,
			itm.ContentLabel13,
			itm.ContentLabel14,
			itm.ContentLabel15,
			itm.ContentLabel16,
			itm.ContentLabel17,
			itm.ContentLabel18,
			itm.ContentLabel19,
			itm.ContentLabel20,
			itm.ContentLabel21,
		}

		buttonTable = {
			itm.ContentButton1,
			itm.ContentButton2,
			itm.ContentButton3,
			itm.ContentButton4,
			itm.ContentButton5,
			itm.ContentButton6,
			itm.ContentButton7,
			itm.ContentButton8,
			itm.ContentButton9,
			itm.ContentButton10,
			itm.ContentButton11,
			itm.ContentButton12,
			itm.ContentButton13,
			itm.ContentButton14,
			itm.ContentButton15,
			itm.ContentButton16,
			itm.ContentButton17,
			itm.ContentButton18,
			itm.ContentButton19,
			itm.ContentButton20,
			itm.ContentButton21,
		}
	
		-- Scan through each of the shader buttons
		for i = 1,totalShaderZ,1
		do
			local btnNum = i
			local lblID = 'ContentLabel' .. tostring(btnNum)
			local btnID = 'ContentButton' .. tostring(btnNum)

			local iconFilename = tostring(imagesFolder) .. tostring(activeCategory) .. tostring(osSeparator) .. tostring(activeTable[btnNum] or "") .. ".png"
			local macroName =tostring(activeTable[btnNum] or "")
			local macroFilename = tostring(imagesFolder) .. tostring(activeCategory) .. tostring(osSeparator) .. tostring(activeTable[btnNum] or "") .. ".setting"

			-- Refresh the button icon
			buttonTable[btnNum]:SetIcon(
			ui:Icon{
				File = iconFilename
			})

			-- Refresh the button label
			LabelTable[btnNum].Text = macroName
		end
	end


	for i = 1,totalShaderZ,1
	do
		local btnNum = i
		local btnID = 'ContentButton' .. tostring(btnNum)

		-- Button handler function
		win.On[btnID].Clicked = function(ev)
			local activeCategory = ""
			local activeTable = {}
			if itm.CategoryButton1.Checked then
				-- Industrial
				activeCategory = "Industrial"
				activeTable = shadersTable.Industrial
			elseif itm.CategoryButton2.Checked then
				-- Natural
				activeCategory = "Natural"
				activeTable = shadersTable.Natural
			elseif itm.CategoryButton3.Checked then
				-- Utility
				activeCategory = "Utility"
				activeTable = shadersTable.Utility
			elseif itm.CategoryButton4.Checked then
				-- HDRI
				activeCategory = "HDRI"
				activeTable = shadersTable.HDRI
			else
				activeCategory = "Industrial"
				activeTable = shadersTable.Industrial
			end

			if activeTable[btnNum] ~= "" then
				local macroFilename = imagesFolder .. activeCategory .. osSeparator .. tostring(activeTable[btnNum] or "") .. ".setting"
				print('[Adding Macro] ' .. tostring(macroFilename))

				-- Get the current comp
				comp = app:GetAttrs().FUSIONH_CurrentComp

				-- Verify the comp pointer is valid
				if not comp then
					print('[KickAss ShaderZ] Please open a Fusion composite before adding a shader.')
					return
				end

				-- Deslect all nodes
				-- comp:SetActiveTool()

				-- Copy/Paste the macro into the foreground comp
				comp:Paste(bmd.readfile(comp:MapPath(macroFilename)))
			else
				print('[Empty Shader Slot]')
			end
		end
	end

	-- The app:AddConfig() command that will capture the "Control + W" or "Control + F4" hotkeys so they will close the window instead of closing the foreground composite.
	app:AddConfig("KickAssWin", {
		Target {
			ID = "KickAssWin",
		},

		Hotkeys {
			Target = "KickAssWin",
			Defaults = true,

			CONTROL_W  = "Execute{ cmd = [[ app.UIManager:QueueEvent(obj, 'Close', {}) ]] }",
			CONTROL_F4 = "Execute{ cmd = [[ app.UIManager:QueueEvent(obj, 'Close', {}) ]] }",
			ESCAPE = "Execute{ cmd = [[ app.UIManager:QueueEvent(obj, 'Close', {}) ]] }",
		},
	})

	-- Update the icons in the content browser window
	UpdateIconButtons()

	-- Init the window
	win:Show()
	disp:RunLoop()
	win:Hide()
	app:RemoveConfig("KickAssWin")
	collectgarbage()

	return win,win:GetItems()
end

-- The Main function
function Main()
	-- Find out the current Fusion host platform (Windows/Mac/Linux)
	platform = (FuPLATFORM_WINDOWS and "Windows") or (FuPLATFORM_MAC and "Mac") or (FuPLATFORM_LINUX and "Linux")

	-- Add the platform specific folder slash character
	osSeparator = package.config:sub(1,1)

	-- Display the "About KickAss" dialog
	ui = app.UIManager
	disp = bmd.UIDispatcher(ui)
	KickAssWin()
end


Main()
print("[Done]")

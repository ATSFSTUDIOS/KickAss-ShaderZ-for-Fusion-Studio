-- kas_Chrome
-- Get the current comp
comp = app:GetAttrs().FUSIONH_CurrentComp

-- Verify the comp pointer is valid
if not comp then
	print('[KickAss ShaderZ] Please open a Fusion composite before adding a shader.')
	return
end

-- Deslect all nodes
comp:SetActiveTool()

-- Add a macro node to the composite
comp:DoAction("AddSetting", {filename = "Macros:/KickAss ShaderZ/Native ShaderZ/Industrial/kas_Chrome.setting"})
